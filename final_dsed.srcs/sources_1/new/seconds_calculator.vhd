----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2019 17:22:53
-- Design Name: 
-- Module Name: seconds_calculator - Behavioral
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

entity seconds_calculator is
  Port (last_dir : in std_logic_vector (18 downto 0);
        current_dir : in std_logic_vector (18 downto 0);
        playing : in STD_LOGIC;
        BTNL : in STD_LOGIC;
        up_dwn : in STD_LOGIC;
        seconds : out  std_logic_vector (4 downto 0));
end seconds_calculator;

architecture Behavioral of seconds_calculator is

signal dir_up_dwn : unsigned (18 downto 0);
signal dirs_remaining : unsigned (18 downto 0);
signal dir_recording: unsigned (18 downto 0);
signal zero : std_logic_vector (18 downto 0) := (others => '0');
signal fixed_point : std_logic_vector (25 downto 0);
signal factor : std_logic_vector (6 downto 0) := "1101000";

begin

dir_up_dwn <= unsigned(current_dir) when (up_dwn = '1') else
              unsigned(last_dir) - unsigned(current_dir);

dir_recording <= unsigned(current_dir) when (BTNL = '1') else
                  unsigned(zero);

dirs_remaining <= dir_up_dwn when (playing = '1') else
                  dir_recording;

fixed_point <= std_logic_vector(dirs_remaining * unsigned(factor));
seconds <= fixed_point (25 downto 21);

end Behavioral;
