----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2018 14:03:39
-- Design Name: 
-- Module Name: ca2 - Behavioral
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

entity ca2 is
    Port (  bin : in std_logic_vector (sample_size-1 downto 0);
            comp  : out std_logic_vector (sample_size-1 downto 0) 
            );
end ca2;

architecture Behavioral of ca2 is

signal mask : std_logic_vector(sample_size-1 downto 0);

begin
    mask <= (sample_size-1 => '1', others => '0');
    comp <= bin xor mask;

end Behavioral;
