----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2018 13:03:44
-- Design Name: 
-- Module Name: en_4_cycles_tb - Behavioral
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

entity en_4_cycles_tb is
--  Port ( );
end en_4_cycles_tb;

architecture Behavioral of en_4_cycles_tb is

    component en_4_cycles
        port (
            clk_12megas : in STD_LOGIC;
            reset : in STD_LOGIC;
            clk_3megas: out STD_LOGIC;
            en_2_cycles: out STD_LOGIC;
            en_4_cycles : out STD_LOGIC);
     end component;
     
     signal clk_12megas_s, reset_s: std_logic;
     signal clk_3megas_s, en_2_cycles_s, en_4_cycles_s : std_logic;
     constant DELTA : time := 10 ns;
     constant clk_period: time:= 167 ns;
begin

    DUT: en_4_cycles port map (
        clk_12megas => clk_12megas_s,
        reset => reset_s,
        clk_3megas => clk_3megas_s,
        en_2_cycles => en_2_cycles_s,
        en_4_cycles => en_4_cycles_s
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
                    reset_s<='1';
                    wait for 15 ns;
                    reset_s<='0';
                    wait;
                
                end process;

end Behavioral;
