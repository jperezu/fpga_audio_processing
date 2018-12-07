----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2018 18:07:44
-- Design Name: 
-- Module Name: RAM_tb - Behavioral
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

entity RAM_tb is
--  Port ( );
end RAM_tb;

architecture Behavioral of RAM_tb is

component RAM is
  port (
    addra : in std_logic_vector ( 18 downto 0 );
    clka : in std_logic;
    dina : in std_logic_vector (7 downto 0);
    ena : in std_logic;
    wea : in std_logic_vector (0 downto 0);
    douta : out std_logic_vector (7 downto 0)
  );
end component;

signal clk : std_logic;
constant clk_period: time:= 83.33 ns;

signal addr : std_logic_vector (18 downto 0);
signal en : std_logic;
signal din, dout : std_logic_vector (7 downto 0);
signal we : std_logic_vector (0 downto 0);
begin

DUT: RAM port map (
      addra => addr,
      clka => clk,
      dina => din,
      ena => en,
      wea =>  we,
     douta => dout
); 

clk_process :process
                begin
                clk <= '0';
                wait for clk_period/2;
                clk <= '1';
                wait for clk_period/2;
            end process;        
stim_process : process
                begin
                en <= '1';
                we <= "1";
                addr <= (1 => '1' , others => '0');
                din <= (others => '1');
                wait for 124 ns;
                en <= '0';
                we <= "0";
                wait for 42 ns;
                en <= '1';
                wait for 248 ns;
                en <= '0';
                wait;            
            end process;


end Behavioral;
