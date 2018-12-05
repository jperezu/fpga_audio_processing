----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2018 17:15:33
-- Design Name: 
-- Module Name: pwm - Behavioral
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

entity pwm is
 
    port(
        clk_12megas: in std_logic;
        reset: in std_logic;
        en_2_cycles: in std_logic;
        sample_in: in std_logic_vector(sample_size-1 downto 0);
        sample_request: out std_logic;
        pwm_pulse: out std_logic
    );
end pwm;


architecture Behavioral of pwm is

signal r_reg : unsigned (sample_size downto 0) ;
signal r_next : unsigned (sample_size downto 0) ;
signal buf_next : std_logic ;
signal buf_reg : std_logic ;

begin
-- register & output buffer
    process (clk_12megas, reset)
        begin
        if (reset = '0') then
            r_reg <= (others=>'0');
            buf_reg <= '0';
        elsif (clk_12megas'event and clk_12megas = '1') then  
            sample_request <= '0'; 
            if (en_2_cycles = '1') then
                r_reg <= r_next;
                buf_reg <= buf_next ;
                if (r_next = to_unsigned(299,9)) then 
                    sample_request <= '1';
                end if;
            end if;
        end if;
    end process;
    -- next-state logic
    r_next <= (r_reg + 1) when (r_reg < to_unsigned(299,9)) else
              (others => '0'); 
    -- output logic
    buf_next <=
    '1' when (r_reg<unsigned(sample_in)) or (sample_in="00000000") else
    '0';
    pwm_pulse <= buf_reg ; 
end Behavioral;
