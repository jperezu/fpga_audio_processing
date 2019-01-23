----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2019 09:34:35
-- Design Name: 
-- Module Name: level - Behavioral
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

entity level is
  Port (clk_12megas : in STD_LOGIC; 
        reset : in STD_LOGIC;
        sample_in : in std_logic_vector (sample_size-1 downto 0);
        enable : in std_logic;
        leds : out std_logic_vector (7 downto 0)
   );
end level;

architecture Behavioral of level is

signal mult : std_logic_vector (12 downto 0);
signal leds_number : std_logic_vector (3 downto 0);
signal sum : unsigned (3 downto 0);
signal s_0, s_1, s_2, s_3, s_4, s_5, s_6, s_7 : std_logic_vector(3 downto 0); 

signal contador : std_logic_vector (24 downto 0) := (others => '0');
signal led_reg, led_value : std_logic_vector (7 downto 0);
begin

process (clk_12megas, reset)
    begin
        if (reset = '1') then
            contador <= (others => '0');
            led_reg <= (others => '0');
        end if;
        if (clk_12megas'event and clk_12megas='1') then
            if (unsigned(contador) >= to_unsigned(1500000,24)) then
                led_reg <= led_value;
                contador<=(others=>'0');
            else
                contador <= std_logic_vector(unsigned(contador) + 1);
            end if;
        end if;
end process;


--mult <= std_logic_vector(unsigned(sample_in) *  to_unsigned(31, 5)) ;
--leds_number <= mult(12 downto 9);
s_7 <= "000" & sample_in(7);
s_6 <= "000" & sample_in(6);
s_5 <= "000" & sample_in(5);
s_4 <= "000" & sample_in(4);
s_3 <= "000" & sample_in(3);
s_2 <= "000" & sample_in(2);
s_1 <= "000" & sample_in(1);
s_0 <= "000" & sample_in(0);
sum <=  unsigned (s_7) + unsigned (s_6) + unsigned (s_5) + unsigned (s_4) +
        unsigned (s_3) + unsigned (s_2) + unsigned (s_1) + unsigned (s_0);


led_value <= "00000001" when (std_logic_vector(sum) = "0001" and enable = '1') else
             "00000011" when (std_logic_vector(sum) = "0010" and enable = '1') else
             "00000111" when (std_logic_vector(sum) = "0011" and enable = '1') else
             "00001111" when (std_logic_vector(sum) = "0100" and enable = '1') else
             "00011111" when (std_logic_vector(sum) = "0101" and enable = '1') else
             "00111111" when (std_logic_vector(sum) = "0110" and enable = '1') else
             "01111111" when (std_logic_vector(sum) = "0111" and enable = '1') else
             "11111111" when (std_logic_vector(sum) = "1111" and enable = '1') else
             "00000000";
        
leds <= led_reg;  
      
end Behavioral;
