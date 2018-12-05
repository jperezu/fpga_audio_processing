----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2018 22:55:43
-- Design Name: 
-- Module Name: dsed_audio - Behavioral
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

entity dsed_audio is
    Port (
        clk_100Mhz : in std_logic;
        reset: in std_logic;
        --Control ports
        BTNL: in STD_LOGIC;
        BTNC: in STD_LOGIC;
        BTNR: in STD_LOGIC;
        SW0: in STD_LOGIC;
        SW1: in STD_LOGIC;
        --To/From the microphone
        micro_clk : out STD_LOGIC;
        micro_data : in STD_LOGIC;
        micro_LR : out STD_LOGIC;
        --To/From the mini-jack
        jack_sd : out STD_LOGIC;
        jack_pwm : out STD_LOGIC
    );
end dsed_audio;

architecture Behavioral of dsed_audio is

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

begin

--U_AI: audio_interface port map(
--           clk_12megas => ,
--           reset => reset,
--           record_enable => ,
--           sample_out => ,
--           sample_out_ready => ,
--           micro_clk => ,
--           micro_data => ,
--           micro_LR => ,
--           play_enable => ,
--           sample_in => ,
--           sample_request => ,
--           jack_sd => ,
--           jack_pwm => 
--           ); 



end Behavioral;
