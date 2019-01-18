----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2018 22:49:02
-- Design Name: 
-- Module Name: filtered_to_matlab - Behavioral
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
use ieee.numeric_std.all;
use std.textio.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity filtered_to_matlab is
--  Port ( );
end filtered_to_matlab;

architecture Behavioral of filtered_to_matlab is

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


signal clk_12megas_s : std_logic := '1';
signal reset_s, enable, ready: std_logic;
constant clk_period: time:= 83.33 ns;
signal smplout,out_hold : signed (sample_size-1 downto 0);
signal sample: signed(7 downto 0) := (others => '0');
signal sample_out : integer;    
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

stim_process : process
    begin
    reset_s <= '1';
    wait for clk_period;
    reset_s <= '0';
    wait for clk_period;
    wait;
end process;

-- Clock statement
clk_12megas_s <= not clk_12megas_s after clk_period/2;

rw_process : PROCESS
    FILE in_file : text OPEN read_mode IS "C:/Users/Jorge/Desktop/Ingenieria Teleco/DSED/sample_in.dat";
    
    VARIABLE in_line : line;
    VARIABLE in_int : integer;
    VARIABLE in_read_ok : BOOLEAN;
    
    FILE out_file : text OPEN write_mode IS "C:/Users/Jorge/Desktop/Ingenieria Teleco/DSED/sample_out_low.dat";
    VARIABLE out_line : line;
    
    BEGIN
        if NOT endfile(in_file) then
            ReadLine(in_file,in_line);
            Read(in_line, in_int, in_read_ok);
            sample <= to_signed(in_int, 8); 
            enable <= '1';
            wait for clk_period;
            enable <= '0';
            wait for 50 us;
            sample_out <= to_integer(out_hold);
            Write(out_line, sample_out);
            WriteLine(out_file,out_line);
        else
            assert false report "Simulation Finished" severity failure;
        end if;
end process;

end Behavioral;
