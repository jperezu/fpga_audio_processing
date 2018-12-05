----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2018 17:48:25
-- Design Name: 
-- Module Name: pwm_tb - Behavioral
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

entity pwm_tb is
--  Port ( );
end pwm_tb;

architecture Behavioral of pwm_tb is

component pwm Port(
        clk_12megas: in std_logic;
        reset: in std_logic;
        en_2_cycles: in std_logic;
        sample_in: in std_logic_vector(sample_size-1 downto 0);
        sample_request: out std_logic;
        pwm_pulse: out std_logic);
end component;

component en_4_cycles Port (
        clk_12megas : in STD_LOGIC;
        reset : in STD_LOGIC;
        clk_3megas: out STD_LOGIC;
        en_2_cycles: out STD_LOGIC;
        en_4_cycles : out STD_LOGIC);
end component;


constant clk_period : time := 167 ns;
signal sample_in_s: std_logic_vector (sample_size-1 downto 0);
signal clk_s, clk_3megas_s, rst_cycles_s, rst_pwm_s : std_logic;
signal en_2_cycles_s, enable_4_cycles_s: std_logic;
signal sample_request_s, pwm_s : std_logic;

begin
DUT_EN: en_4_cycles port map(
           clk_12megas=> clk_s,
           reset => rst_cycles_s,
           clk_3megas=> clk_3megas_s,
           en_2_cycles=> en_2_cycles_s,
           en_4_cycles=> enable_4_cycles_s);
 
 DUT: pwm port map(
            clk_12megas => clk_s,
            reset => rst_pwm_s,
            en_2_cycles => en_2_cycles_s,
            sample_in => sample_in_s,
            sample_request => sample_request_s,
            pwm_pulse => pwm_s);
           
-- Clock process definitions( clock with 50% duty cycle)
    clk_process :process
        begin
        clk_s <= '0';
        wait for clk_period/2;
        clk_s <= '1';
        wait for clk_period/2;
    end process;
    

    stim_process : process
        begin
        rst_cycles_s <= '1';
        rst_pwm_s <= '0';
        sample_in_s <= "00000000";
        wait for 100ns;
        rst_cycles_s <= '0';
        rst_pwm_s <= '1';
        wait for 120us;
        rst_cycles_s <= '1';
        rst_pwm_s <= '0';
        sample_in_s <= "10101010";
        wait for 300us;
        rst_cycles_s <= '0';
        rst_pwm_s <= '1';
        sample_in_s <= "11111111";
        wait for 600us;
        rst_cycles_s <= '0';
        rst_pwm_s <= '1';
        sample_in_s <= "10101010";
        wait for 2000us;
        rst_cycles_s <= '0';
        rst_pwm_s <= '1';
        sample_in_s <= "01010101";
        wait for 5000us;
        rst_cycles_s <= '1';
        rst_pwm_s <= '0';
        sample_in_s <= "11111111";
        wait;
    end process;
    


end Behavioral;
