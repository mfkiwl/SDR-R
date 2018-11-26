----------------------------------------------------------------------------
--Author: Paul Effingham
--UMBC: effing1
--November 21 2018
--This is the top level of the UART-TX.
--This chip will have two 8-bit registers, one counting up, the other counting down.
--These registers are to simulate having an I and Q 8-bit register changing constantly
--The goal is to send the incoming data of these registers to the UART-TX and send them
--over USB.					
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity GPIO_demo is
Port ( 
    CLK 		: in  STD_LOGIC;
    UART_TXD 	: out  STD_LOGIC);
end GPIO_demo;

architecture Behavioral of GPIO_demo is

component UART_TX_CTRL
Port(
	SEND : in std_logic;
	DATA : in std_logic_vector(7 downto 0);
	CLK : in std_logic;          
	READY : out std_logic;
	UART_TX : out std_logic);
end component;

component clk_wiz_0
port(
    clk_in1         : in std_logic;
    clk_out1        : out std_logic;
    reset           : in std_logic);
end component;

component up_down_counter
Port (
	cout    : out std_logic_vector (7 downto 0); 
    up_down : in  std_logic;                   -- up_down control for counter
    clk     : in  std_logic;                   -- Input clock
    reset   : in  std_logic);                   -- Input reset
end component;

component mux
Port (
    SEL    : in  std_logic;
    A : in  std_logic_vector(7 downto 0); 
    B : in  std_logic_vector(7 downto 0);
    X : out std_logic_vector(7 downto 0));
end component;

type UART_STATE_TYPE is (RST_REG, LD_BYTE, WAIT_RDY, SEND_BYTE);

constant TMR_CNTR_MAX : std_logic_vector(26 downto 0) := "101111101011110000100000000"; --100,000,000 = clk cycles per second
constant TMR_VAL_MAX : std_logic_vector(3 downto 0) := "1001"; --9

constant RESET_CNTR_MAX : std_logic_vector(17 downto 0) := "110000110101000000";-- 100,000,000 * 0.002 = 200,000 = clk cycles per 2 ms

signal dataSend : std_logic(7 downto 0);
--Contains the length of the current string being sent over uart.


--UART_TX_CTRL control signals
signal uartRdy : std_logic;
signal uartSend : std_logic := '0';
signal uartData : std_logic_vector (7 downto 0):= "00000000";
signal uartTX : std_logic;

--Current uart state signal
signal uartState : UART_STATE_TYPE := RST_REG;

signal clk_cntr_reg : std_logic_vector (4 downto 0) := (others=>'0'); 

--this counter counts the amount of time paused in the UART reset state
signal reset_cntr : std_logic_vector (17 downto 0) := (others=>'0');

--clock signal
signal clk100 : std_logic;
signal clkRst : std_logic := '0';

--Up Down Counters
signal up_count_out, down_count_out, mux_out : std_logic_vector(7 downto 0);

rdy_prev : std_logic;
muxSelect : std_logic := '0';


begin
----------------------------------------------------------
------                Clocking                  -------
----------------------------------------------------------

inst_clk: clk_wiz_0
    port map(
    clk_in1 => CLK,
    clk_out1 => CLK100,
    reset => clkRst
);
----------------------------------------------------------
------                Counter_up                   -------
----------------------------------------------------------      
INST_up_down_counter: up_down_counter port map(
    cout    => up_count_out,
    up_down => '1',
    clk     => CLK100,
    reset   => clkRst
);

----------------------------------------------------------
------                Counter_down                 -------
----------------------------------------------------------  
 INST_up_down_counter: up_down_counter port map(
    cout    => down_count_out,
    up_down => '0',
    clk     => CLK100,
    reset   => clkRst
);
----------------------------------------------------------
------                Counter Mux                  -------
----------------------------------------------------------  
INST_mux: mux port map(
    SEL => muxSelect, -------- Need to change to a signal
    A => up_count_out,
    B => down_count_out,
    X => mux_out
);

----------------------------------------------------------
------              UART Control                   -------
----------------------------------------------------------
--Messages are sent on reset and when a button is pressed.

--This counter holds the UART state machine in reset for ~2 milliseconds. This
--will complete transmission of any byte that may have been initiated during 
--FPGA configuration due to the UART_TX line being pulled low, preventing a 
--frame shift error from occuring during the first message.
process(CLK)
begin
  if (rising_edge(CLK100)) then
    if ((reset_cntr = RESET_CNTR_MAX) or (uartState /= RST_REG)) then
      reset_cntr <= (others=>'0');
    else
      reset_cntr <= reset_cntr + 1;
    end if;
  end if;
end process;

---			State Machine			---
---		1. Reset					---
---		2. Ld Byte -->3				---
---		3. Wait Rdy -->4			---
---		4. Send Byte -->2			---
---		5. OtHER -> RESET			---
next_uartState_process : process (CLK100)
begin
	if (rising_edge(CLK100)) then
		case uartState is
		when RST_REG =>
		if (reset_cntr = RESET_CNTR_MAX) then
          uartState <= LD_BYTE;
		end if;
		when LD_BYTE=>
			uartState <= WAIT_RDY;
		when WAIT_RDY =>
			if(uartRdy = '1') then
				uartState => SEND_BYTE;
			end if;
		when SEND_BYTE =>
			uartState => LD_BYTE;
		when others=> --Should not reach
			uartState <= RST_REG;
		end case;
	end if;
end process;

---Ld Byte
Load_byte_process : process (CLK100)
begin
    --Having it gated on a clock cycle prevents going to send too fast
    if (rising_edge(CLK100)) then
        --Only during the load byte state machine section
        if (uartState = LD_BYTE) then
            --During the load state, the Mux needs to collect the right Select
            --Have the correct 8-bit add/subtract selected with correct add or hold state
            --then send to the wait state
            
            --data is set to what mux out is 
            DATA <= mux_out;
        
        end if;
    end if;
end process;

---Send Byte
Send_byte_process : process (CLK100)
begin
    if (rising_edge(CLK100)) then
        if (uartState = SEND_BYTE) then
            uartSend <= '1';
        else
            uartSend <= '0';
        
        end if;
    end if;
end process;

--Mux select control
mux_select_process : process(CLK100)
begin
    if (rising_edge(CLK100)) then
        if (rdy_prev & !uartRdy) then
            muxSelect = !muxSelect;
        else    
            muxSelect = muxSelect;
        end if;
        rdy_prev = uartRdy;
    end if;
end process;

--Component used to send a byte of data over a UART line.
Inst_UART_TX_CTRL: UART_TX_CTRL port map(
		SEND => uartSend,
		DATA => uartData,
		CLK => CLK100,
		READY => uartRdy,
		UART_TX => uartTX 
	);

UART_TXD <= uartTX;

end Behavioral;
