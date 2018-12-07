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

type fsm_state_type is (idle, muestreo, cont1, cont2, restart);
signal state_reg, state_next: fsm_state_type;
signal dato1, dato2, dato1_reg, dato2_reg : std_logic_vector (7 downto 0);
signal primer_ciclo, primer_ciclo_reg: std_logic;
signal cuenta, cuenta_reg : std_logic_vector(8 downto 0);
signal  sample_out_ready_signal, sample_out_ready_reg : std_logic;
signal  sample_out_signal, sample_out_reg : std_logic_vector (sample_size-1 downto 0);


begin
    -- State and data registers 
    process (clk_12megas, reset)
        begin 
            if  (reset = '0') then
                cuenta_reg <= (others => '0');
                dato1_reg <= (others => '0');
                dato2_reg <= (others => '0');
                primer_ciclo_reg <= '0';
                sample_out_reg <= (others => '0');
                sample_out_ready_reg <= '0';
                state_reg <= idle;
            elsif (clk_12megas'event and clk_12megas = '1') then
                if (enable_4_cycles = '1') then
                    state_reg <= state_next;
                    dato1_reg <= dato1;
                    dato2_reg <= dato2;
                    cuenta_reg <= cuenta;
                    primer_ciclo_reg <= primer_ciclo;
                    sample_out_reg <= sample_out_signal;
                end if;

                sample_out_ready_reg <= sample_out_ready_signal;
            end if;
    end process;

-- next state logic/ouput logic and data path routing
    process (state_reg, cuenta_reg, dato1_reg, dato2_reg, primer_ciclo_reg, sample_out_reg, sample_out_ready_reg, enable_4_cycles, micro_data)
        begin
            -- Default values
            cuenta <= cuenta_reg;
            dato1 <= dato1_reg;
            dato2 <= dato2_reg;
            primer_ciclo <= primer_ciclo_reg;
            sample_out_ready_signal <= sample_out_ready_reg;
            sample_out_signal <= sample_out_reg;
                case state_reg is
                    when idle => 
                        cuenta <= (others => '0');
                        dato1 <= (others => '0');
                        dato2 <= (others => '0');
                        sample_out_ready_signal<= '0';
                        sample_out_signal <= (others => '0');
                        primer_ciclo <= '0';
                        state_next <= muestreo;
                    when muestreo =>
                        cuenta <= std_logic_vector(unsigned(cuenta_reg) + 1);
                         if (micro_data = '1') then
                           dato1 <= std_logic_vector(unsigned(dato1_reg) + 1);
                           dato2 <= std_logic_vector(unsigned(dato2_reg) + 1); 
                       end if;
                        if (std_logic_vector(to_unsigned(105,9)) <= cuenta and cuenta <= std_logic_vector(to_unsigned(149,9))) then
                            state_next <= cont2;
                        elsif (std_logic_vector(to_unsigned(255,9)) <= cuenta) then
                            state_next <= cont1;
                        else 
                            state_next <= muestreo;
                        end if;
                                
                    when cont2 =>
                        cuenta <= std_logic_vector(unsigned(cuenta_reg) + 1);
                       if (micro_data = '1') then
                           dato1 <= std_logic_vector(unsigned(dato1_reg) + 1);
                           end if;
                       if (primer_ciclo_reg = '1' and cuenta = std_logic_vector(to_unsigned(106,9)) ) then 
                           dato2 <= (others => '0');                       
                           sample_out_signal <= dato2_reg;
                           sample_out_ready_signal <= enable_4_cycles;
                       else 
                           sample_out_ready_signal <= '0';
                       end if; 
                        if (std_logic_vector(to_unsigned(149,9)) <= cuenta) then
                            state_next <= muestreo;
                        else
                            state_next <= cont2;
                        end if;
                    when cont1 =>
                        cuenta <= std_logic_vector(unsigned(cuenta_reg) + 1);
                        if (micro_data = '1') then
                             dato2 <= std_logic_vector(unsigned(dato2_reg) + 1);
                             end if;
                         if (cuenta = std_logic_vector(to_unsigned(256,9)) ) then 
                             dato1 <= (others => '0');
                             sample_out_signal <= dato1_reg;
                             sample_out_ready_signal <= enable_4_cycles;
                         else 
                             sample_out_ready_signal <= '0';
                         end if; 
                        if (std_logic_vector(to_unsigned(298,9)) <= cuenta) then
                            state_next <= restart;
                        else 
                            state_next <= cont1;
                        end if;
                    when restart =>
                            cuenta <= (others => '0');
                            primer_ciclo <= '1';
                            sample_out_ready_signal <= '0';
                            state_next <= muestreo;
                    end case;          
    end process;
           
-- Output
sample_out_ready<= sample_out_ready_signal;
sample_out <= sample_out_signal;

end Behavioral;
