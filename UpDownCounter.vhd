----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2025 03:06:59 PM
-- Design Name: 
-- Module Name: UpDownCounter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Counter4Bit is
    Port (
    RST:in std_logic;
    EN:in std_logic;
    CLK:in std_logic;
    CD:in std_logic;
    CU:in std_logic;
    DOUT:out std_logic_vector(7 downto 0)
     );
end Counter4Bit;





architecture Behavioral of Counter4Bit is

component MPG is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

    signal temp:std_logic_vector(7 downto 0):="00000000";
    signal bcu,bcd,brst: std_logic;
begin

    C1: MPG port map (cu, clk, bcu);
    C3: MPG port map (rst, clk, brst);
    C4: MPG port map (cd, clk, bcd);
    
    process (clk,brst,bcu,bcd,en) begin
        if en='1' then    
            if brst='0' then
                    if rising_edge(clk) then
                        if bcu='1' AND bcd='0' then 
                            temp(7 downto 0)<=temp(7 downto 0)+1;
                        else if bcd='1' AND bcu='0' then
                            temp(7 downto 0)<=temp(7 downto 0)-1;
                        end if;
                        end if;
                    end if;
            else 
                temp<="00000000";
            end if;
        end if;
        
       
        
        
    end process;
   
   dout<=temp(7 downto 0);
end Behavioral;

