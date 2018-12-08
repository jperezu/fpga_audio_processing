----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2018 21:59:53
-- Design Name: 
-- Module Name: dsed_audio_tb - Behavioral
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

entity dsed_audio_tb is
--  Port ( );
end dsed_audio_tb;

architecture Behavioral of dsed_audio_tb is

component dsed_audio
    Port (
        clk_100Mhz : in std_logic;
        reset: in std_logic;
        --Control ports
        BTNL: in STD_LOGIC; -- Record audio (last place)
        BTNC: in STD_LOGIC; -- Erase memory
        BTNR: in STD_LOGIC; -- play options (SW0, SW1) ==> (X,X) 
        SW0: in STD_LOGIC;  -- play audio (0,0), play backwards (1,0), 
        SW1: in STD_LOGIC;  -- play low pass (0,1), play high pass (1,1)
        --To/From the microphone
        micro_clk : out STD_LOGIC;
        micro_data : in STD_LOGIC;
        micro_LR : out STD_LOGIC;
        --To/From the mini-jack
        jack_sd : out STD_LOGIC;
        jack_pwm : out STD_LOGIC
    );
end component;


signal clk : std_logic;
constant clk_period: time:= 10 ns;
signal reset_s, micro_data_s, pwm : std_logic;
signal btnl_s, btnc_s, btnr_s : std_logic;

begin

DUT: dsed_audio port map(
             clk_100Mhz => clk,
             reset  => reset_s,
             BTNL => btnl_s, 
             BTNC => btnc_s,
             BTNR => btnr_s,
             SW0 => '0',
             SW1 => '0',
             micro_data => micro_data_s,
             jack_pwm => pwm
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
                wait for 40 us;
                reset_s <= '1';
                btnl_s <= '0';
                btnc_s <= '0';
                btnr_s <= '0';
                micro_data_s <= '0';
                wait for 10 * clk_period;
                btnl_s <= '1';
                reset_s <= '0';
                micro_data_s <= '1';
                wait for 10 * clk_period;
                micro_data_s <= '0';
                wait for 10 * clk_period;
                micro_data_s <= '1';
                wait for 10 * clk_period;
                micro_data_s <= '1';
                wait for 100000 * clk_period;
                btnl_s <= '0';
                micro_data_s <= '1';
                wait for 10 * clk_period;
                micro_data_s <= '0';
                wait for 10 * clk_period;
                micro_data_s <= '1'; 
                wait for 10 * clk_period;                 
                btnr_s <= '1';
                wait for 10 * clk_period;
                micro_data_s <= '0';
                wait for 100005 * clk_period;
                reset_s <= '1';
                wait;            
            end process;
    
end Behavioral;