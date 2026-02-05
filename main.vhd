----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2025 02:53:51 PM
-- Design Name: 
-- Module Name: main - Behavioral
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
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
     Port ( 
        MOUSE_DATA:inout std_logic;
        MOUSE_CLK:inout std_logic;
        ENABLE:in std_logic;
        REVERSE:in std_logic;
        CLK:in std_logic;
        RESET:in std_logic;
        IS_LEFT:out std_logic;
        SSD_OUT:out std_logic_vector(6 downto 0);
        AN:out std_logic_VECTOR(7 downto 0)
     );
end main;

architecture Behavioral of main is
    signal LB,RB:std_logic;
    signal count_out:std_logic_vector(7 downto 0);
    signal CUP,CDN:std_logic;
    
component MouseCtl is
generic
(
   SYSCLK_FREQUENCY_HZ : integer := 10000000;
   CHECK_PERIOD_MS     : integer := 500; -- Period in miliseconds to check if the mouse is present
   TIMEOUT_PERIOD_MS   : integer := 100 -- Timeout period in miliseconds when the mouse presence is checked
);
port(
   clk         : in std_logic;
   rst         : in std_logic;
   left        : out std_logic;
   right       : out std_logic;
   ps2_clk     : inout std_logic;
   ps2_data    : inout std_logic
   
);
end component;

component HexTo7Segm is
  Port ( 
    clk:in std_logic;
    din:in std_logic_vector(7 downto 0);
    dout:out std_logic_vector(6 downto 0);
    anod:out std_logic_vector(7 downto 0)
  );
end component;

component Counter4Bit is
    Port (
    RST:in std_logic;
    EN:in std_logic;
    CLK:in std_logic;
    CD:in std_logic;
    CU:in std_logic;
    DOUT:out std_logic_vector(7 downto 0)
     );
end component;  
 

begin

    C1: MouseCtl port map(rst=>RESET,ps2_clk=>MOUSE_CLK, ps2_data=>MOUSE_DATA,left=>LB,right=>RB,clk=>CLK);
    C2: Counter4Bit port map(RST=>RESET, EN=>ENABLE, CLK=>CLK,CD=>CDN,CU=>CUP,DOUT=>COUNT_OUT);
    C3: HexTo7Segm port map(CLK=>CLK,DIN=>COUNT_OUT, DOUT=>SSD_OUT, ANOD=>AN);
    
    process (REVERSE,LB,RB) begin
        if REVERSE='0' then
            CUP<=LB;
            CDN<=RB;
        else
            CUP<=RB;
            CDN<=LB;
        end if;
    end process;        
    IS_LEFT<=not REVERSE;
        
end Behavioral;
