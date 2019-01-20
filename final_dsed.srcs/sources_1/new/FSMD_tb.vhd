----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2018 11:38:19
-- Design Name: 
-- Module Name: FSMD_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSMD_tb is
--  Port ( );
end FSMD_tb;

architecture Behavioral of FSMD_tb is

component FSMD_microphone Port (
        clk_12megas : in STD_LOGIC;
        reset : in STD_LOGIC;
        enable_4_cycles : in STD_LOGIC;
        micro_data : in STD_LOGIC;
        sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
        sample_out_ready : out STD_LOGIC);
end component;

component en_4_cycles Port (
        clk_12megas : in STD_LOGIC;
        reset : in STD_LOGIC;
        clk_3megas: out STD_LOGIC;
        en_2_cycles: out STD_LOGIC;
        en_4_cycles : out STD_LOGIC);
end component;


constant clk_period : time :=  83.33 ns;
signal clk_s, clk_3megas_s, reset_s, rst_cycles_s, micro_data_s : std_logic;
signal en_2_cycles_s, enable_4_cycles_s, sample_out_ready_s: std_logic;
signal sample_out_s : std_logic_vector(sample_size-1 downto 0);
signal a,b,c : std_logic := '0';

begin
DUT_EN: en_4_cycles port map(
           clk_12megas=> clk_s,
           reset => rst_cycles_s,
           clk_3megas=> clk_3megas_s,
           en_2_cycles=> en_2_cycles_s,
           en_4_cycles=> enable_4_cycles_s);
 
 DUT: FSMD_microphone port map(
           clk_12megas => clk_s,
           reset => reset_s,
           enable_4_cycles => enable_4_cycles_s,
           micro_data => micro_data_s,
           sample_out => sample_out_s,
           sample_out_ready => sample_out_ready_s);
           
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
        micro_data_s <= '1';
        reset_s <= '0';
        rst_cycles_s <= '1';
        wait for 400ns;
        reset_s <= '1';
        rst_cycles_s <= '0'; 
        
--        a <= not a after 2900 ns;
--        b <= not b after 3000 ns;
--        c <= not c after 3700 ns;
        
        
        wait for 1000 us;
        reset_s <= '0';
        rst_cycles_s <= '1';
        wait for 250 us;
        reset_s <= '0';
        rst_cycles_s <= '0';
        wait;
    end process;

-- micro_data_s <= a xor b xor c;
    
end Behavioral;
