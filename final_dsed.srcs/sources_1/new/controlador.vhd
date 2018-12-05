----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2018 20:54:06
-- Design Name: 
-- Module Name: controlador - Behavioral
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

entity controlador is
    Port (
        clk_100Mhz : in std_logic;
        reset: in std_logic;
        --To/From the microphone
        micro_clk : out STD_LOGIC;
        micro_data : in STD_LOGIC;
        micro_LR : out STD_LOGIC;
        --To/From the mini-jack
        jack_sd : out STD_LOGIC;
        jack_pwm : out STD_LOGIC
        );
end controlador;


architecture Behavioral of controlador is

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
           micro_LR : out STD_LOGIC;
    --Playing ports
    --To/From the controller
           play_enable: in STD_LOGIC;
           sample_in: in std_logic_vector(sample_size-1 downto 0);
           sample_request: out std_logic;
    --To/From the mini-jack
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC);
end component;

component clk_12M 
    Port (
        clk_in1 : in std_logic;
        clk_out1: out std_logic
    );
end component;

signal loop_back : std_logic_vector(sample_size-1 downto 0);
signal clk_12megas_s : std_logic;
signal always_high : std_logic := '1';

begin

U_CLK: clk_12M port map(
           clk_in1 => clk_100Mhz,
           clk_out1 => clk_12megas_s
           );

U_AI: audio_interface port map(
           clk_12megas => clk_12megas_s,
           reset => reset,
           record_enable => always_high ,
           sample_out => loop_back,
           sample_out_ready => open,
           micro_clk => micro_clk,
           micro_data => micro_data,
           micro_LR => always_high,
           play_enable => always_high,
           sample_in => loop_back,
           sample_request => open,
           jack_sd => always_high,
           jack_pwm => jack_pwm
           ); 

end Behavioral;
