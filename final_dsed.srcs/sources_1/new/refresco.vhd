----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2019 18:56:58
-- Design Name: 
-- Module Name: refresco - Behavioral
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

entity refresco is
  Port (clk_12megas : in STD_LOGIC; 
        reset : in STD_LOGIC;
        display_dec : in std_logic_vector (6 downto 0);
        display_un : in std_logic_vector (6 downto 0);
        number : out std_logic_vector (6 downto 0);
        select_disp : out std_logic_vector (7 downto 0)
   );
end refresco;

architecture Behavioral of refresco is

signal contador : std_logic_vector (17 downto 0) := (others => '0');
signal select_disp_signal : std_logic;

begin

process (clk_12megas, reset)
    begin
        if (reset = '1') then
            contador <= (others => '0');
            select_disp_signal <= '0';
        end if;
        if (clk_12megas'event and clk_12megas='1') then
            if (unsigned(contador) >= to_unsigned(192000,17)) then
                select_disp_signal <= not select_disp_signal;
                contador<=(others=>'0');
            else
                contador <= std_logic_vector(unsigned(contador) + 1);
            end if;
        end if;
end process;

number <= display_dec when (select_disp_signal = '0') else
          display_un;

select_disp <= "111111" & select_disp_signal & (not select_disp_signal) when (reset = '0')
                else "11111100";

end Behavioral;
