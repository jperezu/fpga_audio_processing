----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2018 22:55:43
-- Design Name: 
-- Module Name: dsed_audio - Behavioral
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

entity dsed_audio is
    Port (
        clk_100Mhz : in std_logic;
        reset: in std_logic;
        --Control ports
        BTNL: in STD_LOGIC; -- Record audio (last place)
        BTNC: in STD_LOGIC; -- Erase memory
        BTNR: in STD_LOGIC; -- play options (SW0, SW1) ==> (X,X) 
        SW0: in STD_LOGIC;  -- play audio (0,0), play backwards (1,0), 
        SW1: in STD_LOGIC;  -- play low pass (0,1), play high pass (1,1)
        --To/From the microphone
        micro_clk : out STD_LOGIC;
        micro_data : in STD_LOGIC;
        micro_LR : out STD_LOGIC;
        --To/From the mini-jack
        jack_sd : out STD_LOGIC;
        jack_pwm : out STD_LOGIC
    );
end dsed_audio;

architecture Behavioral of dsed_audio is

component audio_interface 
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
    --Recording ports
    --To/From the controller
           record_enable: in STD_LOGIC;
           sample_out: out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready: out STD_LOGIC;
    --To/From the microphone
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC := '1';
    --Playing ports
    --To/From the controller
           play_enable: in STD_LOGIC;
           sample_in: in std_logic_vector(sample_size-1 downto 0);
           sample_request: out std_logic;
    --To/From the mini-jack
           jack_sd : out STD_LOGIC := '1';
           jack_pwm : out STD_LOGIC);
end component;

component clk_12M 
    Port (
        clk_in1 : in std_logic;
        clk_out1: out std_logic
    );
end component;


component RAM
     port (
      addra : in std_logic_vector ( 18 downto 0 );
      clka : in std_logic;
      dina : in std_logic_vector (sample_size-1 downto 0);
      ena : in std_logic;
      wea : in std_logic_vector (0 downto 0);
      douta : out std_logic_vector (sample_size-1 downto 0)
    );
end component;

component address_manager
    Port ( clk_12megas : in STD_LOGIC;
          reset : in STD_LOGIC;
          sample_ready : in STD_LOGIC;
          sample_request : in STD_LOGIC;
          BTNC : in STD_LOGIC;
          BTNR : in STD_LOGIC;
          up_dwn : in STD_LOGIC;
          playing : out STD_LOGIC;
          address : out STD_LOGIC_VECTOR (18 downto 0));
end component;

component or_2
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component and_2_not
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           c : out STD_LOGIC);
end component;

component and3_not 
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           c : in STD_LOGIC;
           d : out STD_LOGIC);
end component;

component ca2
    Port ( bin : in std_logic_vector (sample_size-1 downto 0);
           comp  : out std_logic_vector (sample_size-1 downto 0)); 
end component;

component cambio_valor
Port ( clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       d : in std_logic_vector ( 18 downto 0 );
       sample_play_enable : out STD_LOGIC);
end component;

component fir_filter
    Port ( clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Sample_In : in signed (sample_size-1 downto 0);
           Sample_In_enable : in STD_LOGIC;
           filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
           Sample_Out : out signed (sample_size-1 downto 0);
           Sample_Out_ready : out STD_LOGIC);
end component;

component multiplexor_2 
    Port ( a0 : in signed (sample_size-1 downto 0);
           a1 : in signed (sample_size-1 downto 0);
           ctrl : in STD_LOGIC_VECTOR (1 downto 0);
           b : out signed (sample_size-1 downto 0));
end component;

component mux_0_1
    Port ( a0 : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           a1 : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           ctrl : in STD_LOGIC;
           b : out STD_LOGIC_VECTOR (sample_size-1 downto 0));
end component;

component hold
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en: in STD_LOGIC;
           d : in signed (sample_size-1 downto 0);
           q : out signed (sample_size-1 downto 0));
end component;

signal clk_12megas_s : std_logic;
signal data_ca2_inv, data_filtered : signed (sample_size-1 downto 0);
signal data_to_mem, data_to_filter, data_to_amp, filt_not_filt, data_ca2 : std_logic_vector (sample_size-1 downto 0);
signal ready, request, sample_ready_filter, or_en, up_dwn_s, sample_to_play, sample_enable_s : std_logic;
signal address_s : std_logic_vector (18 downto 0);
signal playing_s: std_logic;
signal always_high : std_logic := '1';
signal always_down : std_logic := '0';
begin

U_CLK: clk_12M port map(
           clk_in1 => clk_100Mhz,
           clk_out1 => clk_12megas_s
           );

U_AI: audio_interface port map(
           clk_12megas => clk_12megas_s,
           reset => reset,
           record_enable => BTNL,
           sample_out => data_to_mem,
           sample_out_ready => ready,
           micro_clk => micro_clk,
           micro_data => micro_data,
           micro_LR => micro_LR,
           play_enable => playing_s,
           sample_in => filt_not_filt,
           sample_request => request,
           jack_sd => jack_sd,
           jack_pwm => jack_pwm
           ); 
           
MEM: RAM port map (
           addra => address_s,
           clka => clk_12megas_s,
           dina => data_to_mem,
           douta => data_to_filter,
           wea(0) => ready,
           ena => or_en
           );
OR2: or_2 port map (
          a => BTNL,
          b => playing_s,
          y => or_en
          );
AND2: and_2_not port map (
          a => SW1,
          b => SW0,
          c => up_dwn_s
          );                  
ADDR: address_manager port map (
          clk_12megas => clk_12megas_s,
          reset => reset,
          sample_ready => ready, 
          sample_request => request,
          BTNC => BTNC,
          BTNR => BTNR,
          up_dwn => up_dwn_s,
          playing => playing_s,
          address => address_s
          );
          
CHNG: cambio_valor port map (
          clk => clk_12megas_s,
          rst => reset,
          d => address_s,
          sample_play_enable => sample_enable_s
        );
                                      
FILTR: fir_filter port map (
         clk => clk_12megas_s,
         Reset => reset,
         Sample_In => signed(data_ca2),
         Sample_In_enable => request,
         filter_select => SW0,
         Sample_Out => data_filtered,
         Sample_Out_ready => sample_ready_filter
          );     
               
CA2_1: ca2 port map (
        bin => data_to_filter,
        comp => data_ca2
        );  
        
CA2_INV: ca2 port map (
        bin => std_logic_vector(data_ca2_inv),
        comp => data_to_amp
        );  
        
MUX: mux_0_1 port map (
        a0 => data_to_filter,
        a1 => data_to_amp,
        ctrl => SW1,
        b => filt_not_filt
        );   
        
HLD: hold port map (
        clk => clk_12megas_s,
        rst => reset,
        en => sample_ready_filter,
        d  => data_filtered,
        q  => data_ca2_inv
        );
end Behavioral;
