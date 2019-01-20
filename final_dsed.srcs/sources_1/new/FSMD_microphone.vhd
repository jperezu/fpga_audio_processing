----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.11.2018 09:53:47
-- Design Name: 
-- Module Name: FSMD_microphone - Behavioral
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
--use UNISIM.VComponents.all;5

entity FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
    reset : in STD_LOGIC;
    enable_4_cycles : in STD_LOGIC;
    micro_data : in STD_LOGIC;
    sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
    sample_out_ready : out STD_LOGIC);
end FSMD_microphone;


architecture Behavioral of FSMD_microphone is

type fsm_state_type is (muestreo, cont1, cont2);
signal state_reg, state_next: fsm_state_type;
signal dato1, dato2, dato1_next, dato2_next : std_logic_vector (7 downto 0);
signal primer_ciclo, primer_ciclo_reg: std_logic;
signal cuenta_next, cuenta_reg : std_logic_vector(8 downto 0);
signal  sample_out_ready_signal,sample_out_ready_reg : std_logic;
signal  sample_out_signal, sample_out_reg : std_logic_vector (sample_size-1 downto 0);


begin
    -- State and data registers 
    process (clk_12megas, reset, enable_4_cycles)
        begin 
            if  (reset = '0') then
                cuenta_reg <= (others => '0');
                dato1 <= (others => '0');
                dato2 <= (others => '0');
                primer_ciclo_reg <= '0';
                sample_out_reg <= (others => '0');
                sample_out_ready_reg<= '0';
                state_reg <= muestreo;
            elsif (clk_12megas'event and clk_12megas = '1') then
                   
               dato1 <= dato1_next;
              dato2 <= dato2_next;
              cuenta_reg <= cuenta_next;
              state_reg <= state_next;
              primer_ciclo_reg <= primer_ciclo;
              sample_out_ready_reg <= sample_out_ready_signal;
              sample_out_reg <= sample_out_signal;
               
            end if;
    end process;

-- next state logic/ouput logic and data path routing
    process (state_reg, cuenta_reg, primer_ciclo_reg, dato1, dato2,sample_out_ready_reg, sample_out_reg, micro_data, enable_4_cycles)
        begin
               dato1_next <= dato1;
               dato2_next <= dato2;
               cuenta_next <= cuenta_reg;
               primer_ciclo <= primer_ciclo_reg;
               sample_out_ready_signal <= '0';
               sample_out_signal <= sample_out_reg;
               state_next <= state_reg;
               
                    case state_reg is
                        when muestreo =>
                            if (enable_4_cycles ='1') then
                                cuenta_next <= std_logic_vector(unsigned(cuenta_reg) + 1);
                                if ((std_logic_vector(to_unsigned(0,9)) <= cuenta_reg and cuenta_reg < std_logic_vector(to_unsigned(105,9))) 
                                    or (std_logic_vector(to_unsigned(149,9)) <= cuenta_reg and cuenta_reg < std_logic_vector(to_unsigned(255,9)))) then   
                                    if (micro_data = '1') then
                                        dato1_next <= std_logic_vector(unsigned(dato1) + 1);
                                        dato2_next <= std_logic_vector(unsigned(dato2) + 1); 
                                    end if;
                                    state_next <= muestreo;
                                elsif (std_logic_vector(to_unsigned(105,9)) <= cuenta_reg and cuenta_reg < std_logic_vector(to_unsigned(149,9))) then
                                    state_next <= cont2;
                                elsif (std_logic_vector(to_unsigned(299,9)) <= cuenta_reg) then
                                    cuenta_next <= (others => '0');
                                    primer_ciclo <= '1';
                                else
                                    state_next <= cont1;
                                end if;
                            end if;
                        when cont2 =>    
                            if (enable_4_cycles ='1') then                 
                                cuenta_next <= std_logic_vector(unsigned(cuenta_reg) + 1);
                                if (micro_data = '1') then
                                    dato1_next <= std_logic_vector(unsigned(dato1) + 1);
                                end if;
                                if (primer_ciclo_reg = '1' and cuenta_reg = std_logic_vector(to_unsigned(106,9))) then
                                    dato2_next <= (others => '0');
                                    sample_out_ready_signal <= '1';
                                    sample_out_signal <= dato2;
                                else
                                    sample_out_ready_signal <= '0';
                                end if;
                                
                                if (cuenta_reg < std_logic_vector(to_unsigned(149,9))) then   
                                    state_next <= cont2;
                                else
                                    dato2_next <= std_logic_vector(unsigned(dato2) + 1);
                                    state_next <= muestreo;
                                end if;
                            end if;
                        when cont1 =>
                            if (enable_4_cycles ='1') then
                                cuenta_next <= std_logic_vector(unsigned(cuenta_reg) + 1);
                                if (micro_data = '1') then
                                    dato2_next <= std_logic_vector(unsigned(dato2) + 1);
                                end if;
                                if (cuenta_reg = std_logic_vector(to_unsigned(256,9))) then
                                    dato1_next <= (others => '0');
                                    sample_out_ready_signal <= '1';
                                    sample_out_signal <= dato1;
                                else
                                    sample_out_ready_signal <= '0';
                                end if;
                                
                                if (cuenta_reg < std_logic_vector(to_unsigned(298,9))) then   
                                    state_next <= cont1;
                                else
                                    dato1_next <= std_logic_vector(unsigned(dato1) + 1);
                                    state_next <= muestreo;
                                end if;
                            end if;
                        end case;       
    end process;
           
-- Output
sample_out_ready<= sample_out_ready_signal;
sample_out <= sample_out_signal;

end Behavioral;
