----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2018 12:31:09
-- Design Name: 
-- Module Name: fir_data_flow - Behavioral
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

entity fir_data_flow is
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
end fir_data_flow;

architecture Behavioral of fir_data_flow is

component multiplexor
    Port ( a0 : in signed (sample_size-1 downto 0);
           a1 : in signed (sample_size-1 downto 0);
           a2 : in signed (sample_size-1 downto 0);
           a3 : in signed (sample_size-1 downto 0);
           a4 : in signed (sample_size-1 downto 0);
           a5 : in signed (sample_size-1 downto 0);
           a6 : in signed (sample_size-1 downto 0);
           ctrl : in STD_LOGIC_VECTOR (2 downto 0);
           b : out signed (sample_size-1 downto 0));
end component;



component registro
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           d : in signed (sample_size-1 downto 0);
           q : out signed (sample_size-1 downto 0));
end component;

component sumador
    Port ( a : in signed (sample_size-1 downto 0);
           b : in signed (sample_size-1 downto 0);
           c : out signed (sample_size-1 downto 0));
end component;

component multiplicador
    Port ( a : in signed (sample_size-1 downto 0);
           b : in signed (sample_size-1 downto 0);
           c : out signed (sample_size-1 downto 0));
end component;

signal s_0, s_1, s_2, s_3, s_4, s_5, s_6, s_7, s_8, s_9, s_sum, s_mult: signed (sample_size-1 downto 0);

begin

MUX1: multiplexor port map (
          a0 => c0,
          a1 => c1,
          a2 => c2,
          a3 => c3,
          a4 => c4,
          a5 => to_signed(0, sample_size),
          a6 => to_signed(0, sample_size),
          ctrl => control,
          b => s_0
);

MUX2: multiplexor port map (
          a0 => x0,
          a1 => x1,
          a2 => x2,
          a3 => x3,
          a4 => x4,
          a5 => to_signed(0, sample_size),
          a6 => to_signed(0, sample_size),
          ctrl => control,
          b => s_1
);

MUX3: multiplexor port map (
          a0 => to_signed(0, sample_size),
          a1 => s_2,
          a2 => s_4,
          a3 => s_sum,
          a4 => s_sum,
          a5 => s_sum,
          a6 => s_sum,
          ctrl => control,
          b => s_3
);


H_M: multiplicador port map(
        a => s_0,
        b => s_1,
        c => s_mult
        );
R_MULT: registro port map (
        clk  => clk_12megas,
        rst  => reset,
        d    => s_mult,
        q    => s_2
        );  
R1: registro port map (
        clk  => clk_12megas,
        rst  => reset,
        d    => s_3,
        q    => s_4
        );

R2: registro port map (
        clk  => clk_12megas,
        rst  => reset,
        d    => s_2,
        q    => s_5
        );
        
ADD: sumador port map(
        a => s_4,
        b => s_5,
        c => s_sum
        );
        

 y <= s_sum;       
end Behavioral;
