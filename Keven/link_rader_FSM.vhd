library  IEEE;
use ieee.std_logic_1164.all;

entity link_rader_FSM is
    port (
        ADC       : in std_logic_vector(7 downto 0);
        rader     : in std_logic;
        rader_clk : in std_logic;
        reset     : in std_logic;
        pulse_clk : in std_logic;
        even_odd_out : out std_logic_vector(15 downto 0);
        fifo_wr_en  : out std_logic
       -- fake_rader_Clk    : out std_logic;
       -- is_fourth : out std_logic;
       -- even_data_out   : out std_logic_vector(7 downto 0);
       -- odd_data_out    : out std_logic_vector(7 downto 0);
       -- rader_input     : out std_logic_vector(7 downto 0);
       -- is_even_en      : out std_logic;
       -- is_odd_en       : out std_logic
    );
end link_rader_FSM;

architecture Behavioral of link_rader_FSM is

--component faux_Clk 
--    port(
--        rader       : in std_logic;
--        rader_Clk   : in std_logic;
--        reset     : in std_logic;
--        fake_Clk    : out std_logic
--    );
--end component;

component countFour 
    port(
        rader_Clk   : in std_logic;
        fake_Clk    : in std_logic;
        reset     : in std_logic;
        max_count   : out std_logic;
        min_count   : out std_logic;
        even_en     : out std_logic;
        odd_en      : out std_logic 
    );
end component;

component DFF
    port(
        D   : in std_logic_vector(7 downto 0);
        CE  : in std_logic;
        CLK : in std_logic;
        reset : in std_logic;
        Q   : out std_logic_vector(7 downto 0)
    );
end component;

component filter_even
    port(
    data_in : in std_logic_vector(7 downto 0);
    clk_var : in std_logic;
    enable  : in std_logic;
    reset   : in std_logic;
    data_out: out std_logic_vector(7 downto 0)
    );
end component;

component filter_odd
    port(
        data_in : in std_logic_vector(7 downto 0);
        clk_var : in std_logic;
        enable  : in std_logic;
        reset   : in std_logic;
        data_out : out std_logic_vector(7 downto 0)
    ); 
end component;
    
        --SIGNALS--
signal fake_clock, fourthCount, even_enable, odd_enable, zero_count : std_logic;
--DFF's
signal DFF_Q1, even_out, odd_out : std_logic_vector(7 downto 0);
--Rader Filters
signal even_output, odd_output : std_logic_vector(7 downto 0);
        -----------


begin

--faux : faux_Clk port map (  rader => rader,
--                            rader_Clk => rader_Clk,
--                            reset     => reset,
--                            fake_Clk => fake_clock     );

count : countFour port map (rader_Clk => rader_Clk,
                            fake_Clk  => pulse_clk,  
                            reset     => reset,
                            max_count => fourthCount,
                            min_count => fifo_wr_en,
                            even_en   => even_enable,
                            odd_en    => odd_enable  );

even : filter_even port map (   data_in  => DFF_Q1,
                                clk_var  => rader_Clk,
                                enable   => even_enable,
                                reset    => reset,
                                data_out => even_output );

odd : filter_odd port map (     data_in  => DFF_Q1,
                                clk_var  => rader_Clk,
                                enable   => odd_enable,
                                reset    => reset,
                                data_out => odd_output  );

DFF1  : DFF port map (  D     => ADC, 
                        CE    => pulse_clk,
                        reset => reset,
                        CLK   => rader_Clk,
                        Q     => DFF_Q1   );

DFF2  : DFF port map (  D   => even_output,
                        CE  => fourthCount,
                        reset  => reset,
                        CLK => rader_Clk,
                        Q   => even_out   );

DFF3  : DFF port map (  D   => odd_output,
                        CE  => fourthCount,
                        reset  => reset,
                        CLK => rader_Clk,
                        Q   => odd_out   );        
--rader_input <= DFF_Q1;                       
--is_fourth <= fourthCount;
--even_data_out <= even_output;
--odd_data_out  <= odd_output;
--fake_rader_Clk <= fake_clock;
even_odd_out <= even_out & odd_out;
--is_even_en <= even_enable;
--is_odd_en <= odd_enable;

end Behavioral;