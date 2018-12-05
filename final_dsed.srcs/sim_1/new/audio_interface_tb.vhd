----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2018 20:17:38
-- Design Name: 
-- Module Name: audio_interface_tb - Behavioral
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

entity audio_interface_tb is
--  Port ( );
end audio_interface_tb;

architecture Behavioral of audio_interface_tb is

component audio_interface 
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
    --Recording ports
    --To/From the controller
           record_enable: in STD_LOGIC;
           sample_out: out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready: out STD_LOGIC;
    --To/From the microphone
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC := '1';
    --Playing ports
    --To/From the controller
           play_enable: in STD_LOGIC;
           sample_in: in std_logic_vector(sample_size-1 downto 0);
           sample_request: out std_logic;
    --To/From the mini-jack
           jack_sd : out STD_LOGIC := '1';
           jack_pwm : out STD_LOGIC);
end component;

signal clk : std_logic;
constant clk_period: time:= 167 ns;

signal reset_s, record_s, micro_data_s, play_s : std_logic;
signal sample_s : std_logic_vector(sample_size-1 downto 0);
begin

DUT: audio_interface port map (
        clk_12megas => clk,
        reset  => reset_s,
        record_enable  => record_s,
        micro_data  => micro_data_s,
        play_enable  => play_s,
        sample_in  => sample_s 
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
               
                record_s <= '0';
                play_s <= '0';
                
                micro_data_s <= '0';
                sample_s <= "00000000";
                wait for 100 us;
                
                reset_s <= '0';
                                
                record_s <= '1';
                play_s <= '1';
                
                micro_data_s <= '1';
                sample_s <= "11111111";
               -- wait for 100 us;
                
                wait;            
            end process;

end Behavioral;
