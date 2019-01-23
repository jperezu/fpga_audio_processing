----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.11.2018 12:43:00
-- Design Name: 
-- Module Name: package_dsed - 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package package_dsed is

    constant sample_size: integer := 8;
    
    constant c0_low : signed(7 downto 0) :=  "00000101";
    constant c1_low : signed(7 downto 0) :=   "00011111";
    constant c2_low : signed(7 downto 0) :=   "00111001";
    constant c3_low : signed(7 downto 0) :=   "00011111";
    constant c4_low : signed(7 downto 0) :=   "00000101";
    
    constant c0_high : signed(7 downto 0) :=  "11111111";
    constant c1_high : signed(7 downto 0) :=  "11100110";
    constant c2_high : signed(7 downto 0) :=  "01001101";
    constant c3_high : signed(7 downto 0) :=  "11100110";
    constant c4_high : signed(7 downto 0) :=  "11111111";

    constant factor_muestreo : std_logic_vector (6 downto 0) := "1101000";
    
    
end package_dsed;
