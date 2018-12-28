----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2018 17:48:34
-- Design Name: 
-- Module Name: multiplexor_1 - Behavioral
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
use work.package_dsed.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplexor_1 is
    Port ( a0 : in signed (sample_size-1 downto 0);
           ctrl : in STD_LOGIC;
           b : out signed (sample_size-1 downto 0));
end multiplexor_1;

architecture Behavioral of multiplexor_1 is

signal  zero : signed (sample_size-1 downto 0) := (others => '0');
begin

with ctrl select
    b <= a0 when '0',
         zero when others;

end Behavioral;
