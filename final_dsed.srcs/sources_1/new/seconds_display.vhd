----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2019 18:44:30
-- Design Name: 
-- Module Name: seconds_display - Behavioral
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

entity seconds_display is
  Port (seconds : in  std_logic_vector (4 downto 0);
        display_dec : out std_logic_vector (6 downto 0);
        display_un : out std_logic_vector (6 downto 0)
        );
end seconds_display;

architecture Behavioral of seconds_display is

begin

with seconds select display_un <=
         "1000000" when "00000", --0
         "1111001" when "00001", --1
         "0100100" when "00010", --2
         "0110000" when "00011", --3
         "0011001" when "00100", --4
         "0010010" when "00101", --5
         "0000010" when "00110", --6
         "1111000" when "00111", --7
         "0000000" when "01000", --8
         "0011000" when "01001", --9
         "1000000" when "01010", --10
         "1111001" when "01011", --11
         "0100100" when "01100", --12
         "0110000" when "01101", --13
         "0011001" when "01110", --14
         "0010010" when "01111", --15
         "0000010" when "10000", --16
         "1111000" when "10001", --17
         "0000000" when "10010", --18
         "0011000" when "10011", --19
         "1000000" when "10100", --20
         "1111001" when "10101", --21
         "0100100" when "10110", --22
         "0110000" when "10111", --23
         "0011001" when "11000", --24
         "0010010" when "11001", --25
         "0000010" when "11010", --26
         "1111000" when "11011", --27
         "0000000" when "11100", --28
         "0011000" when "11101", --29
         "1000000" when "11110", --30
         "1111001" when "11111", --31
         "1111111" when others; --E

with seconds select display_dec <=
         "1000000" when "00000", --0
         "1000000" when "00001", --1
         "1000000" when "00010", --2
         "1000000" when "00011", --3
         "1000000" when "00100", --4
         "1000000" when "00101", --5
         "1000000" when "00110", --6
         "1000000" when "00111", --7
         "1000000" when "01000", --8
         "1000000" when "01001", --9
         "1111001" when "01010", --10
         "1111001" when "01011", --11
         "1111001" when "01100", --12
         "1111001" when "01101", --13
         "1111001" when "01110", --14
         "1111001" when "01111", --15
         "1111001" when "10000", --16
         "1111001" when "10001", --17
         "1111001" when "10010", --18
         "1111001" when "10011", --19
         "0100100" when "10100", --20
         "0100100" when "10101", --21
         "0100100" when "10110", --22
         "0100100" when "10111", --23
         "0100100" when "11000", --24
         "0100100" when "11001", --25
         "0100100" when "11010", --26
         "0100100" when "11011", --27
         "0100100" when "11100", --28
         "0100100" when "11101", --29
         "0110000" when "11110", --30
         "0110000" when "11111", --31
         "1111111" when others; --E

end Behavioral;
