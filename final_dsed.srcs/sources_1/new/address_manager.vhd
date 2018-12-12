----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2018 23:33:01
-- Design Name: 
-- Module Name: address_manager - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity address_manager is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_ready : in STD_LOGIC;
           sample_request : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           up_dwn : in STD_LOGIC;
           playing : out STD_LOGIC;
           address : out STD_LOGIC_VECTOR (18 downto 0));
end address_manager;

architecture Behavioral of address_manager is

signal last_address_reg : std_logic_vector (18 downto 0);
signal last_address_next : std_logic_vector (18 downto 0);

signal last_record_reg : std_logic_vector (18 downto 0);
signal last_record_next : std_logic_vector (18 downto 0);

signal selection : std_logic_vector (18 downto 0);
signal address_reg, address_standby : std_logic_vector (18 downto 0);

signal btnr_pressed_reg, btnr_pressed_next : std_logic;

begin

--Register
    process(clk_12megas, reset, BTNC, BTNR, btnr_pressed_reg, sample_ready,sample_request)
        begin
            if (reset = '1' or BTNC = '1') then
                last_address_reg <= (others => '0');
                last_record_reg <= (others => '0');
                address_standby <= (others => '0');
                btnr_pressed_reg <= '0';
             elsif (clk_12megas'event and clk_12megas = '1') then 
                if (btnr_pressed_reg = '0') then
                    last_record_reg <= selection; -- vuelve la reproduccion al origen
                end if;             
                if (sample_ready = '1') then
                    last_address_reg <= last_address_next;
                elsif (sample_request = '1' and btnr_pressed_reg = '1') then 
                    last_record_reg <= last_record_next;
                end if;
                address_standby <= address_reg;
                btnr_pressed_reg <= btnr_pressed_next;
             end if; 
    end process;
--next-state logic
last_address_next <= (others => '0') when (last_address_reg = std_logic_vector(to_unsigned(524287,19))) else
                      std_logic_vector(unsigned(last_address_reg) + 1);
                      
selection <= last_address_reg when (up_dwn = '1') else
             (others => '0');
             
--last_record_next <= selection when ((last_record_reg >= last_address_reg and up_dwn = '0') or
--                     (last_record_reg = std_logic_vector(to_unsigned(0,19))  and up_dwn = '1')) else
--                     std_logic_vector(unsigned(last_record_reg) - 1) when (up_dwn = '1') else
--                     std_logic_vector(unsigned(last_record_reg) + 1);

btnr_pressed_next <= '0' when ((last_record_reg >= last_address_reg and up_dwn = '0') or
                                 (last_record_reg = std_logic_vector(to_unsigned(0,19))  and up_dwn = '1')) else
                      '1' when (BTNR = '1') else
                      btnr_pressed_reg;


last_record_next <=  std_logic_vector(unsigned(last_record_reg) - 1) when (up_dwn = '1') else
                     std_logic_vector(unsigned(last_record_reg) + 1);

address_reg <= last_record_reg when (sample_request = '1' and sample_ready = '0') else
           address_standby when (sample_request = '0' and sample_ready = '0') else
           last_address_reg;

-- Output
playing <= btnr_pressed_reg;
address <= address_reg;

end Behavioral;
