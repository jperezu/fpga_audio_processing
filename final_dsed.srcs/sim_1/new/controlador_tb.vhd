----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2018 23:43:09
-- Design Name: 
-- Module Name: controlador_tb - Behavioral
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

entity controlador_tb is
--  Port ( );
end controlador_tb;

architecture Behavioral of controlador_tb is

component controlador 
     Port ( clk_100Mhz : in std_logic;
        reset: in std_logic;
        --To/From the microphone
        micro_clk : out STD_LOGIC;
        micro_data : in STD_LOGIC;
        micro_LR : out STD_LOGIC;
        --To/From the mini-jack
        jack_sd : out STD_LOGIC;
        jack_pwm : out STD_LOGIC);
end component;


signal clk : std_logic;
constant clk_period: time:= 10 ns;
signal reset_s, micro_data_s : std_logic;

begin

           
DUT: controlador port map (
          clk_100Mhz => clk,
          reset => reset_s,
          micro_data => micro_data_s
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
                reset_s <= '1';
                micro_data_s <= '0';
                wait for 10 us;
                reset_s <= '0';
                micro_data_s <= '1';
                wait for 500 us;
                micro_data_s <= '0';
                wait for 1000 us;
                micro_data_s <= '1';
                wait for 500 us;
                micro_data_s <= '0';
                wait for 200 us;
                micro_data_s <= '1';
                wait for 300 us;
                micro_data_s <= '0';
                wait for 500 us;
                micro_data_s <= '1'; 
                wait for 500 us;                 
                reset_s <= '1';
                wait for 500 us;
                micro_data_s <= '0';
                wait for 500 us;
                reset_s <= '0';
                wait;            
            end process;

end Behavioral;
