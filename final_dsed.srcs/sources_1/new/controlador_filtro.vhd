----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.12.2018 16:38:40
-- Design Name: 
-- Module Name: controlador_filtro - Behavioral
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

entity controlador_filtro is
  Port (  clk_12megas : in STD_LOGIC;
          reset : in STD_LOGIC;
          filter_select : in STD_LOGIC;
          sample_in :  in signed(sample_size-1 downto 0);
          sample_in_ready : in  STD_LOGIC;
          control_in: out STD_LOGIC_VECTOR (2 DOWNTO 0);
          control_flow: out STD_LOGIC_VECTOR (1 downto 0);
          control_add: out STD_LOGIC;
          c0 : out signed (sample_size-1 downto 0);
          c1 : out signed (sample_size-1 downto 0);
          c2 : out signed (sample_size-1 downto 0);
          c3 : out signed (sample_size-1 downto 0);
          c4 : out signed (sample_size-1 downto 0);
          x0 : out signed (sample_size-1 downto 0);
          x1 : out signed (sample_size-1 downto 0);
          x2 : out signed (sample_size-1 downto 0);
          x3 : out signed (sample_size-1 downto 0);
          x4 : out signed (sample_size-1 downto 0);
          sample_out_ready : out  STD_LOGIC);
end controlador_filtro;

architecture Behavioral of controlador_filtro is

type fsm_state_type is (idle, t1, t2, t3, t4, t5, t6, t7);
signal state_reg, state_next: fsm_state_type;
signal x0_reg, x1_reg, x2_reg, x3_reg, x4_reg, x_hold_reg  : signed(sample_size-1 downto 0);
signal x0_next, x1_next, x2_next, x3_next, x4_next, x_hold_next: signed(sample_size-1 downto 0);
signal sample_out_ready_reg, sample_out_ready_next,filtering : std_logic;
begin

process (clk_12megas, reset, filtering, sample_in_ready)
    begin
    if (reset = '1') then 
        state_reg <= idle;
        sample_out_ready_reg <= '0';
        x_hold_reg <= (others => '0');
        x0_reg <= (others => '0');
        x1_reg <= (others => '0');
        x2_reg <= (others => '0');
        x3_reg <= (others => '0');
        x4_reg <= (others => '0');
    elsif (clk_12megas'event and clk_12megas = '1') then
            sample_out_ready_reg <= sample_out_ready_next;
            state_reg <= state_next;
            if (filtering = '1') then
                x_hold_reg <= x_hold_next;
                x0_reg <= x0_next;
                x1_reg <= x1_next;
                x2_reg <= x2_next;
                x3_reg <= x3_next;
                x4_reg <= x4_next;
             end if;
    end if;
end process;

-- next state logic/ouput logic and data path routing-
    process (state_reg,filter_select, sample_in_ready, sample_in, x_hold_reg,x0_reg,x1_reg,x2_reg,x3_reg, x4_reg)
        begin
                if (filter_select = '0') then
                    c0 <=  "00000101";
                    c1 <=  "00011111";
                    c2 <=  "00111001";
                    c3 <=  "00011111";
                    c4 <=  "00000101";
                else       
                    c0 <=  "11111111";
                    c1 <=  "11100110";
                    c2 <=  "01001101"; 
                    c3 <=  "11100110"; 
                    c4 <=  "11111111";
                end if;
                x_hold_next <= x_hold_reg;
                x0_next <=   x0_reg;
                x1_next <=   x1_reg;
                x2_next <=   x2_reg;
                x3_next <=   x3_reg;
                x4_next <=   x4_reg;
                filtering <= '0';
                sample_out_ready_next <= '0';
                case state_reg is
                    when idle => 
                        control_in <= "111";
                        control_flow <= "11";
                        control_add <= '1';
                        x0_next <= (others => '0');
                        x1_next <= (others => '0');
                        x2_next <= (others => '0');
                        x3_next <= (others => '0');
                        x4_next <= (others => '0');
                           sample_out_ready_next <= '0';
                           if (sample_in_ready = '1') then
                                x_hold_next <= sample_in;
                                x0_next <= x_hold_reg;
                                x1_next <= x0_reg;
                                x2_next <= x1_reg;
                                x3_next <= x2_reg;
                                x4_next <= x3_reg;
                                filtering <= '1';
                                state_next <= t1;
                            else
                                x_hold_next <= (others => '0');
                                x0_next <= (others => '0');
                                x1_next <= (others => '0');
                                x2_next <= (others => '0');
                                x3_next <= (others => '0');
                                x4_next <= (others => '0');
                                state_next <= idle;
                            end if;
                    when t1 =>
                         control_in <= "000";
                         control_flow <= "11"; 
                         control_add <= '1';
                         filtering <= '1';
                         state_next <= t2;
                    when t2 =>
                         control_in <= "001";
                         control_flow <= "11"; 
                         control_add <= '1';
                         filtering <= '1';
                         state_next <= t3;
                    when t3 =>
                         control_in <= "010";
                         control_flow <= "11";
                         control_add <= '1';  
                         filtering <= '1';
                         state_next <= t4;
                    when t4 =>
                         control_in <= "011";
                         control_flow <= "00";
                         control_add <= '0';
                         filtering <= '1';
                         state_next <= t5;
                    when t5 =>
                         control_in <= "100";
                         control_flow <= "01";
                         control_add <= '0'; 
                         filtering <= '1';
                         state_next <= t6;
                    when t6 =>
                         control_in <= "111";
                         control_flow <= "01";   
                         control_add <= '0';
                         filtering <= '1';
                         sample_out_ready_next <= '1';
                         state_next <= t7; 
                    when t7 =>
                         control_in <= "111";
                         control_flow <= "01";
                         control_add <= '0';
                         filtering <= '0';
                         sample_out_ready_next <= '0';
                         state_next <= idle;
                    end case;          
    end process;
x0 <= x0_reg;
x1 <= x1_reg;
x2 <= x2_reg;
x3 <= x3_reg;
x4 <= x4_reg;
sample_out_ready <= sample_out_ready_reg;

end Behavioral;
