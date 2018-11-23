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
--use UNISIM.VComponents.all;

entity FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
    reset : in STD_LOGIC;
    enable_4_cycles : in STD_LOGIC;
    micro_data : in STD_LOGIC;
    sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
    sample_out_ready : out STD_LOGIC);
end FSMD_microphone;


architecture Behavioral of FSMD_microphone is

type fsm_state_type is (idle, contador);
signal state_reg, state_next: fsm_state_type;
signal micro_reg, micro_reg_next : std_logic;
signal dato1, dato2 : std_logic_vector (7 downto 0);
signal primer_ciclo: std_logic;
signal cuenta : std_logic_vector(8 downto 0);
signal  sample_out_ready_signal : std_logic;
signal  sample_out_signal : std_logic;


begin
    -- State and data registers 
    process (clk_12megas, reset)
        begin 
            if  (reset = '1') then
                state_reg <= idle;
            elsif (clk_12megas'event and clk_12megas = '1') then
                state_reg <= state_next;
                micro_reg_next <= micro_reg;
            end if;
    end process;


    process (state_reg, micro_reg)
        begin
            case state_reg is
                when idle => 
                    cuenta <= (others => '0') ;
                    dato1 <= (others => '0');
                    dato2 <= (others => '0');
                    primer_ciclo <= '0';
                    micro_reg <= micro_data;
                    state_next <= contador;
                when contador =>
                    if ((std_logic_vector(to_unsigned(0,9)) <= cuenta and cuenta <= std_logic_vector(to_unsigned(105,9))) or
                         (std_logic_vector(to_unsigned(150,9)) <= cuenta and cuenta <= std_logic_vector(to_unsigned(255,9)))) then
                        cuenta <= std_logic_vector(unsigned(cuenta) + 1);
                        if (micro_reg = '1') then
                            dato1 <= std_logic_vector(unsigned(dato1) + 1);
                            dato2 <= std_logic_vector(unsigned(dato2) + 1);  
                        end if;          
                    else
                        if (std_logic_vector(to_unsigned(106,9)) <= cuenta and cuenta <= std_logic_vector(to_unsigned(149,9))) then
                        
                        else 
                            if (cuenta = std_logic_vector(to_unsigned(299,9))) then
                                cuenta <= (others => '0');
                                primer_ciclo <= '1';     
                            else
                                cuenta <= std_logic_vector(unsigned(cuenta) + 1);
                                if (micro_reg = '1') then
                                    dato2 <= std_logic_vector(unsigned(dato2) + 1); 
                                else
                                    if (cuenta = std_logic_vector(to_unsigned(256,9))) then
                                        sample_out_signal <= '1';
                                        dato1 <= (others => '0');
                                        sample_out_ready_signal <= enable_4_cycles;
                                    else
                                        sample_out_ready_signal <= '0';
                                    end if;    
                                end if;
                            end if;                       
                        end if;
                    end if;
            end case;       
    end process;
    
    --- Output logic
        process (dato1, dato2)
            begin
                     
        end process;
    
end Behavioral;
