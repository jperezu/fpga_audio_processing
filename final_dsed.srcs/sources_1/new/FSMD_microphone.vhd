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
signal micro_reg, micro_reg_next : std_logic;
signal dato1, dato2 : std_logic_vector (7 downto 0);
signal primer_ciclo: std_logic;
signal cuenta : std_logic_vector(8 downto 0);
signal  sample_out_ready_signal : std_logic;
signal  sample_out_signal : std_logic_vector (sample_size-1 downto 0);


begin
    -- State and data registers 
    process (clk_12megas, reset, micro_data)
        begin 
            
            if (clk_12megas'event and clk_12megas = '1') then
                state_reg <= state_next;
                micro_reg_next <= micro_reg;
            end if;
    end process;


    process (state_reg, cuenta, reset)
        begin
            micro_reg <= micro_data;
            if  (reset = '0') then
                 state_next <= idle;
            else
                case state_reg is
                    when idle => 
                        state_next <= muestreo;
                    when muestreo =>
                        if (std_logic_vector(to_unsigned(105,9)) <= cuenta and cuenta <= std_logic_vector(to_unsigned(149,9))) then
                            state_next <= cont2;
                        elsif (std_logic_vector(to_unsigned(255,9)) <= cuenta) then
                            state_next <= cont1;
                        end if;
                                
                    when cont2 =>
                        if (std_logic_vector(to_unsigned(149,9)) <= cuenta) then
                            state_next <= muestreo;
                        end if;
                    when cont1 =>
                        if (std_logic_vector(to_unsigned(298,9)) <= cuenta) then
                            state_next <= restart;
                        end if;
                    when restart =>
                            state_next <= muestreo;
                    end case;          
          end if;
    end process;
    
    --- Output logic
        process (state_reg, micro_reg, primer_ciclo, enable_4_cycles)
            begin

                if (cuenta < std_logic_vector(to_unsigned(299,9))) then
                    cuenta <= std_logic_vector(unsigned(cuenta) + 1);
                end if;
                
                case (state_reg) is
                    when idle =>
                        cuenta <= (others => '0');
                        dato1 <= (others => '0');
                        dato2 <= (others => '0');
                        primer_ciclo <= '0';
                        sample_out_ready_signal <= '0';
                        sample_out_signal <= (others => '0');
                    when muestreo =>
                        if (micro_reg = '1') then
                            dato1 <= std_logic_vector(unsigned(dato1) + 1);
                            dato2 <= std_logic_vector(unsigned(dato2) + 1); 
                        end if;
                    when cont2 =>
                        if (micro_reg = '1') then
                            dato1 <= std_logic_vector(unsigned(dato1) + 1);
                            end if;
                        if (primer_ciclo = '1' and cuenta = std_logic_vector(to_unsigned(106,9)) ) then 
                            sample_out_signal <= dato2;
                            dato2 <= (others => '0');
                            sample_out_ready_signal <= enable_4_cycles;
                        else 
                            sample_out_ready_signal <= '0';
                        end if; 
                     when cont1 =>
                        if (micro_reg = '1') then
                             dato2 <= std_logic_vector(unsigned(dato2) + 1);
                             end if;
                         if (cuenta = std_logic_vector(to_unsigned(256,9)) ) then 
                             sample_out_signal <= dato1;
                             dato1 <= (others => '0');
                             sample_out_ready_signal <= enable_4_cycles;
                         else 
                             sample_out_ready_signal <= '0';
                         end if; 
                    when others =>
                        cuenta <= (others => '0');
                        primer_ciclo <= '1';
                 end case;
        end process;         

sample_out_ready<= sample_out_ready_signal;
sample_out <= sample_out_signal;

end Behavioral;
