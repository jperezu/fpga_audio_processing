----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2018 12:18:18
-- Design Name: 
-- Module Name: multiplexor - Behavioral
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

entity multiplexor is
    Port ( a0 : in signed (sample_size-1 downto 0);
           a1 : in signed (sample_size-1 downto 0);
           a2 : in signed (sample_size-1 downto 0);
           a3 : in signed (sample_size-1 downto 0);
           a4 : in signed (sample_size-1 downto 0);
           a5 : in signed (sample_size-1 downto 0);
           a6 : in signed (sample_size-1 downto 0);
           ctrl : in STD_LOGIC_VECTOR (2 downto 0);
           b : out signed (sample_size-1 downto 0));
end multiplexor;

architecture Behavioral of multiplexor is

begin

with ctrl select
    b <= a0 when "000",
         a1 when "001",
         a2 when "010",
         a3 when "011",
         a4 when "100",
         a5 when "101",
         a6 when "110",
         to_signed(0, sample_size) when others;

end Behavioral;
