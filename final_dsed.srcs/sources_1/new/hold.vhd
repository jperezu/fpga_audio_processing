----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.12.2018 11:15:53
-- Design Name: 
-- Module Name: hold - Behavioral
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

entity hold is
Port ( clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       en: in STD_LOGIC;
       d : in signed (sample_size-1 downto 0);
       q : out signed (sample_size-1 downto 0));
end hold;

architecture Behavioral of hold is

signal reg_signal : signed (sample_size-1 downto 0);

begin

process (clk, rst, en)
    begin
    if (rst = '1') then
        reg_signal <= to_signed(0, sample_size);
     elsif (clk'event and clk = '1') then
        if (en = '1') then
            reg_signal <= d;
        end if;               
     end if; 
end process;

q <= reg_signal;


end Behavioral;
