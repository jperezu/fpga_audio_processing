----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2018 08:32:01
-- Design Name: 
-- Module Name: address_manager_tb - Behavioral
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

entity address_manager_tb is
--  Port ( );
end address_manager_tb;

architecture Behavioral of address_manager_tb is

component address_manager
       Port ( 
           clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_ready : in STD_LOGIC;
           sample_request : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           up_dwn : in STD_LOGIC;
           address : out STD_LOGIC_VECTOR (18 downto 0));
     end component;
     
     signal clk_12megas_s, reset_s: std_logic;
     signal ready, request, btnc_s, btnr_s, up_dwn_s : std_logic;
     signal address_s : STD_LOGIC_VECTOR (18 downto 0);
     constant clk_period: time:= 83.33 ns;
begin

    DUT: address_manager port map (
        clk_12megas => clk_12megas_s,
        reset =>reset_s,
        sample_ready => ready,
        sample_request => request,
        btnc => btnc_s,
        btnr => btnr_s,
        up_dwn => up_dwn_s,
        address => address_s
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
                    wait for clk_period/2;
                    btnr_s <= '0';
                    btnc_s <= '0';
                    up_dwn_s <= '0';
                    
                    reset_s<='1';
                    
                    request <= '0';
                    ready <= '0';
                    wait for 10 * clk_period;
                    reset_s<='0';
                    wait for clk_period;
                    ready <= '1';
                    wait for clk_period;
                    ready <= '0';
                    wait for 10 * clk_period;
                    ready <= '1';
                    wait for 10 * clk_period;
                    ready <= '0';
                    btnc_s <= '1';
                    wait for clk_period;
                    ready <= '1';
                    wait for clk_period;
                    ready <= '0';
                    btnc_s  <= '0';
                    wait for 10 * clk_period;
                    ready <= '1';
                    wait for clk_period;
                    ready <= '0';
                     wait for 10 * clk_period;
                    ready <= '1';
                    wait for clk_period;
                    ready <= '0';
                    wait for 10 * clk_period;
                    up_dwn_s <= '1';
                    btnr_s <= '1';
                    request <= '1';
                    wait for clk_period;
                    request <= '0';  
                    wait for 2 * clk_period;
                    request <= '1';
                    wait for clk_period;
                    request <= '0';  
                    wait for 2 * clk_period;
                    request <= '1';
                    wait for clk_period;
                    request <= '0';  
                    wait for 2 * clk_period; 
                    request <= '1';
                    wait for clk_period;
                    request <= '0';  
                    wait for 2 * clk_period;
                    request <= '1';
                    wait for clk_period;
                    request <= '0';  
                    wait for 2 * clk_period;                  
                    btnr_s <= '0';
                    wait for 10 * clk_period;
                    btnr_s <= '1';
                    btnc_s <= '1';
                    up_dwn_s <= '0';
                    
                    reset_s<='1';
                    wait for 10 * clk_period;
                    ready <= '1';
                    request <= '1';
                    wait for clk_period;
                    reset_s <= '0';
                    request <= '0';  
                    wait for 2 * clk_period;
                    ready <= '1';
                    btnc_s <= '0';
                    request <= '1';
                    wait for clk_period;
                    ready <= '0';
                    request <= '0'; 
                    wait for clk_period;
                    ready <= '1';
                    request <= '1';
                    wait for clk_period;
                    ready <= '0';
                    request <= '0'; 
                    wait for clk_period; 
                    ready <= '1';
                    request <= '1';
                    wait for clk_period;
                    ready <= '0';
                    request <= '0';  
                    btnr_s <= '0'; 
                    wait;
                
                end process;


end Behavioral;
