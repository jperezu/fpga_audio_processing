----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2018 19:43:36
-- Design Name: 
-- Module Name: rw_file_tb - Behavioral
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
use ieee.numeric_std.all;
use std.textio.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rw_file_tb is
--  Port ( );
end rw_file_tb;

architecture Behavioral of rw_file_tb is

-- Clock signal declaration
signal clk : std_logic := '1';
-- Declaration of the reading signal
signal Sample_In : signed(7 downto 0) := (others => '0');
-- Clock period definitions
constant clk_period : time := 10 ns;

-- Declaration of the signal to write
signal signed_number : signed (7 downto 0):= (others => '0');
signal sample_out : integer;    
BEGIN
-- Clock statement
clk <= not clk after clk_period/2;

rw_process : PROCESS (clk)
    FILE in_file : text OPEN read_mode IS "C:/Users/Jorge/Desktop/Ingenieria Teleco/DSED/sample_in.dat";
    
    VARIABLE in_line : line;
    VARIABLE in_int : integer;
    VARIABLE in_read_ok : BOOLEAN;
    
    FILE out_file : text OPEN write_mode IS "C:/Users/Jorge/Desktop/Ingenieria Teleco/DSED/sample_out.dat";
    VARIABLE out_line : line;
    
    BEGIN
    if (clk'event and clk = '1') then
        if NOT endfile(in_file) then
            ReadLine(in_file,in_line);
            Read(in_line, in_int, in_read_ok);
            sample_in <= to_signed(in_int, 8); -- 8 = the bit width
            
            signed_number <= "01000000";
            sample_out <= to_integer(sample_in);
            Write(out_line, sample_out);
            WriteLine(out_file,out_line);
        else
            assert false report "Simulation Finished" severity failure;
        end if;
    end if;
end process;


end Behavioral;