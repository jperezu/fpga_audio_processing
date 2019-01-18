----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.12.2018 17:28:41
-- Design Name: 
-- Module Name: mux_sel - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_sel is
    Port ( a0 : in STD_LOGIC;
           a1 : in STD_LOGIC;
           ctrl : in STD_LOGIC;
           b : out STD_LOGIC);
end mux_sel;

architecture Behavioral of mux_sel is

begin

with ctrl select
    b <= a0 when '0',
         a1 when '1',
         '0' when others;

end Behavioral;
