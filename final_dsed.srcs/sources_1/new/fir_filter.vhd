----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2018 10:46:35
-- Design Name: 
-- Module Name: fir_filter - Behavioral
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

entity fir_filter is
Port (  clk : in STD_LOGIC;
        Reset : in STD_LOGIC;
        Sample_In : in signed (sample_size-1 downto 0);
        Sample_In_enable : in STD_LOGIC;
        filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
        Sample_Out : out signed (sample_size-1 downto 0);
        Sample_Out_ready : out STD_LOGIC);
end fir_filter;


architecture Behavioral of fir_filter is

component fir_data_flow
  Port (clk_12megas : in STD_LOGIC;
        reset : in STD_LOGIC;
        control: in STD_LOGIC_VECTOR (2 DOWNTO 0);
        c0 : in signed (sample_size-1 downto 0);
        c1 : in signed (sample_size-1 downto 0);
        c2 : in signed (sample_size-1 downto 0);
        c3 : in signed (sample_size-1 downto 0);
        c4 : in signed (sample_size-1 downto 0);
        x0 : in signed (sample_size-1 downto 0);
        x1 : in signed (sample_size-1 downto 0);
        x2 : in signed (sample_size-1 downto 0);
        x3 : in signed (sample_size-1 downto 0);
        x4 : in signed (sample_size-1 downto 0);
        y : out signed (sample_size-1 downto 0)
   );
end component;

component controlador_filtro
  Port (  clk_12megas : in STD_LOGIC;
          reset : in STD_LOGIC;
          filter_select : in STD_LOGIC;
          sample_in :  in signed(sample_size-1 downto 0);
          sample_in_ready : in  STD_LOGIC;
          control: out STD_LOGIC_VECTOR (2 DOWNTO 0);
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
end component;

signal c_0, c_1, c_2, c_3, c_4, x_0, x_1, x_2, x_3, x_4 : signed (sample_size-1 downto 0);
signal control_s : std_logic_vector (2 downto 0);
begin

FIR: fir_data_flow port map (
        clk_12megas => clk,
        reset => reset,
        control => control_s,
        c0 => c_0,
        c1 => c_1,
        c2 => c_2,
        c3 => c_3,
        c4 => c_4,
        x0 => x_0,
        x1 => x_1,
        x2 => x_2,
        x3 => x_3,
        x4 => x_4,
        y => sample_out
        );
        
CTRL: controlador_filtro port map (
          clk_12megas => clk,
          reset => reset,
          filter_select => filter_select,
          sample_in => Sample_In,
          sample_in_ready => Sample_In_enable,
          control => control_s,
          c0 => c_0,
          c1 => c_1,
          c2 => c_2,
          c3 => c_3,
          c4 => c_4,
          x0 => x_0,
          x1 => x_1,
          x2 => x_2,
          x3 => x_3,
          x4 => x_4,
          sample_out_ready => sample_out_ready
          );

end Behavioral;
