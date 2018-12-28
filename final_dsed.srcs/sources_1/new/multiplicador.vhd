----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2018 12:28:56
-- Design Name: 
-- Module Name: multiplicador - Behavioral
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

entity multiplicador is
    Port ( a : in signed (sample_size-1 downto 0);
           b : in signed (sample_size-1 downto 0);
           c : out signed (sample_size-1 downto 0));
end multiplicador;

architecture Behavioral of multiplicador is

signal mult : signed ((2*sample_size)-1 downto 0);

begin

mult <=  a * b;
c <= mult (14 downto 7);

end Behavioral;
