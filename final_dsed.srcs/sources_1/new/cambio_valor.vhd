----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.12.2018 14:54:55
-- Design Name: 
-- Module Name: cambio_valor - Behavioral
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

entity cambio_valor is
Port ( clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       d : in std_logic_vector ( 18 downto 0 );
       sample_play_enable : out STD_LOGIC);
end cambio_valor;

architecture Behavioral of cambio_valor is

signal reg_signal :  std_logic_vector ( 18 downto 0 );
signal signal_changed : std_logic;
begin

process (clk, rst, d)
    begin
    if (rst = '1') then
        reg_signal <= (others => '0');
     elsif (clk'event and clk = '1') then
        if (reg_signal /= d) then
            reg_signal <= d;
            signal_changed <= '1';
        else 
            signal_changed <= '0';
        end if;               
     end if; 
end process;

sample_play_enable <= signal_changed;

end Behavioral;
