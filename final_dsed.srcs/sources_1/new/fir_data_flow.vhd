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
        control_in: in STD_LOGIC_VECTOR (2 DOWNTO 0);
        control_flow: in STD_LOGIC_VECTOR (1 downto 0);
        control_add: in STD_LOGIC;
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
           ctrl : in STD_LOGIC_VECTOR (2 downto 0);
           b : out signed (sample_size-1 downto 0));
end component;

component multiplexor_2 
    Port ( a0 : in signed (sample_size-1 downto 0);
           a1 : in signed (sample_size-1 downto 0);
           ctrl : in STD_LOGIC_VECTOR (1 downto 0);
           b : out signed (sample_size-1 downto 0));
end component;

component multiplexor_1
    Port ( a0 : in signed (sample_size-1 downto 0);
           ctrl : in STD_LOGIC;
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

signal s_0, s_1, s_2, s_3, s_4, s_5, s_6, s_7, s_8, s_sum : signed (sample_size-1 downto 0);

begin

MUX1: multiplexor port map (  
         a0 => c0,
         a1 => c1,
         a2 => c2,
         a3 => c3,
         a4 => c4,
         ctrl => control_in,
         b  => s_0
         );
         
MUX2: multiplexor port map (
        a0 => x0,
        a1 => x1,
        a2 => x2,
        a3 => x3,
        a4 => x4,
        ctrl => control_in,
        b  => s_1
        );
        
H_M: multiplicador port map(
        a => s_0,
        b => s_1,
        c => s_2
        );
        
R1: registro port map (
        clk  => clk_12megas,
        rst  => reset,
        d    => s_2,
        q    => s_3
        );

R2: registro port map (
        clk  => clk_12megas,
        rst  => reset,
        d    => s_3,
        q    => s_4
        );
        
R3: registro port map (
        clk  => clk_12megas,
        rst  => reset,
        d    => s_4,
        q    => s_5
        );
        
MUX3: multiplexor_2 port map (
       a0 => s_5,
       a1 => s_8, 
       ctrl => control_flow,
       b  => s_6
       );
       
ADD: sumador port map(
        a => s_4,
        b => s_6,
        c => s_sum
        );
        
MUX4: multiplexor_1 port map (
       a0 => s_sum, 
       ctrl => control_add,
       b  => s_7
       );
                       
R4: registro port map (
        clk  => clk_12megas,
        rst  => reset,
        d    => s_7,
        q    => s_8
        );
 y <= s_8;       
end Behavioral;
