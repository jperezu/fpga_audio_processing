----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2018 18:37:39
-- Design Name: 
-- Module Name: RAM - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is
     port (
       addra : in std_logic_vector ( 18 downto 0 );
       clka : in std_logic;
       dina : in std_logic_vector (7 downto 0);
       ena : in std_logic;
       wea : in std_logic_vector (0 downto 0);
       douta : out std_logic_vector (7 downto 0)
     );
end RAM;

architecture Behavioral of RAM is

component blk_mem_gen_0 is
      port (
        addra : in std_logic_vector ( 18 downto 0 );
        clka : in std_logic;
        dina : in std_logic_vector (7 downto 0);
        ena : in std_logic;
        wea : in std_logic_vector (0 downto 0);
        douta : out std_logic_vector (7 downto 0)
      );
end component; 


begin

MEM: blk_mem_gen_0 port map (
     addra => addra,
     clka => clka,
     dina => dina,
     douta => douta,
     wea => wea,
     ena => ena
);

end Behavioral;
