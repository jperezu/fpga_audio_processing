----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.11.2018 13:03:16
-- Design Name: 
-- Module Name: en_4_cycles - Behavioral
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

entity en_4_cycles is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas: out STD_LOGIC;
           en_2_cycles: out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end en_4_cycles;


architecture Behavioral of en_4_cycles is
signal r_reg: std_logic_vector(1 downto 0);
signal r_next: std_logic_vector(1 downto 0);
signal clk3_s: std_logic;
signal en4_s: std_logic;
signal cuenta: std_logic_vector(2 downto 0);
signal cuenta_next: std_logic_vector(2 downto 0);
begin
--Register
    process(clk_12megas, clk3_s, reset)
        begin
            if (reset = '1') then
                r_reg <= (0=>'1', others => '0');
                cuenta <= (others => '0');
             elsif (clk_12megas'event and clk_12megas = '1') then
                cuenta <= cuenta_next;
                r_reg <= r_next;               
             end if; 
    end process;
    
--Next state logic
r_next <= r_reg(0) & r_reg(1);
cuenta_next <= (others => '0') when cuenta = "011" else
        std_logic_vector(unsigned(cuenta)+ 1);
clk3_s <= '1' when cuenta >= "010" else '0';
en4_s <= '1' when clk3_s = '1' and r_next >= "01" and r_reg ="01" else '0';
--output logic
en_2_cycles <= r_reg(1);
clk_3megas <= clk3_s;
en_4_cycles <= en4_s;

end Behavioral;
