--
-- Entity: inverter
-- Architecture : structural 
-- Author: zjones3
-- Created On: 10/30/18
--
library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity inverter is

  port (
    invIn    : in  std_ulogic;
    invOut   : out std_ulogic);
end inverter;

architecture structural of inverter is

begin

  invOut <= not invIn;

end structural;

