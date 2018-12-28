----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.12.2018 11:27:26
-- Design Name: 
-- Module Name: impulso_tb - Behavioral
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

entity impulso_tb is
--  Port ( );
end impulso_tb;

architecture Behavioral of impulso_tb is

component fir_filter
Port (  clk : in STD_LOGIC;
        Reset : in STD_LOGIC;
        Sample_In : in signed (sample_size-1 downto 0);
        Sample_In_enable : in STD_LOGIC;
        filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
        Sample_Out : out signed (sample_size-1 downto 0);
        Sample_Out_ready : out STD_LOGIC);
end component;

component hold
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en: in STD_LOGIC;
           d : in signed (sample_size-1 downto 0);
           q : out signed (sample_size-1 downto 0));
end component;

signal clk_12megas_s, reset_s, enable, ready: std_logic;
constant clk_period: time:= 83.33 ns;
signal sample, smplout,out_hold : signed (sample_size-1 downto 0);
 
begin

FIR: fir_filter port map (
        clk => clk_12megas_s,
        Reset => reset_s,
        Sample_In => sample,
        Sample_In_enable => enable,
        filter_select => '0',
        Sample_Out => smplout,
        Sample_Out_ready => ready
        );
HLD: hold port map (
        clk => clk_12megas_s,
        rst => reset_s,
        en => ready,
        d  => smplout,
        q  => out_hold
        );
        
clk_process :process
    begin
    clk_12megas_s <= '0';
    wait for clk_period/2;
    clk_12megas_s <= '1';
    wait for clk_period/2;
end process;
                
stim_process : process
    begin
    reset_s <= '1';
    wait for 2*clk_period;
    reset_s <= '0';
    sample <= "00000000";
    enable <= '1';
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    sample <= "01000000";--"00000000";
    enable <= '1';
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    sample <= "00000000";
    enable <= '1';
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    sample <= "00010000"; --"00000000";
    enable <= '1';
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    sample <= "00000000"; --"01000000";
    enable <= '1';
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    sample <= "00000000";
    enable <= '1';
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    sample <= "00000000";
    enable <= '1';
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    sample <= "00000000";
    enable <= '1';
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    sample <= "00000000";
    enable <= '1';
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    enable <= '1';  
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    enable <= '1';  
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    enable <= '1';  
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    enable <= '1';  
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    enable <= '1';  
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    enable <= '1';  
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    enable <= '1';  
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    enable <= '1';  
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    enable <= '1';  
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    enable <= '1';  
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    enable <= '1';  
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    enable <= '1';  
    wait for clk_period;
    enable <= '0';
    wait for 50 us;
    enable <= '1';  
    wait for clk_period;
    enable <= '0';
                                        
    wait;
end process;
                
end Behavioral;
