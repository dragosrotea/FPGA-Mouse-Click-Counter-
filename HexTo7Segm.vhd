----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2025 05:02:05 PM
-- Design Name: 
-- Module Name: HexTo7Segm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--   Multiplexed 3-digit 7-segment display with minimal changes
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.03 - Added clock divider to reduce multiplex frequency
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity HexTo7Segm is
  Port ( 
    clk : in std_logic;                      
    din : in std_logic_vector(7 downto 0);
    dout: out std_logic_vector(6 downto 0);
    anod: out std_logic_vector(7 downto 0)
  );
end HexTo7Segm;

architecture Behavioral of HexTo7Segm is
  signal data : integer;
  signal d1, d2, d3 : integer;
  signal sel : integer range 0 to 2 := 0;         
  signal seg1, seg2, seg3 : std_logic_vector(6 downto 0);
  constant REFRESH_CNT : integer := 50000;        
  signal refresh_counter : integer range 0 to REFRESH_CNT := 0;
  signal refresh_tick : std_logic := '0';
begin
  -- Convert input and extract decimal digits
  data <= to_integer(unsigned(din));
  d1   <= data mod 10;
  d2   <= (data mod 100) / 10;
  d3   <= (data mod 1000) / 100;

  -- Decode each digit to segment patterns
  with d1 select
    seg1 <= "1111001" when 1,
            "0100100" when 2,
            "0110000" when 3,
            "0011001" when 4,
            "0010010" when 5,
            "0000010" when 6,
            "1111000" when 7,
            "0000000" when 8,
            "0010000" when 9,
            "1000000" when others;

  with d2 select
    seg2 <= "1111001" when 1,
            "0100100" when 2,
            "0110000" when 3,
            "0011001" when 4,
            "0010010" when 5,
            "0000010" when 6,
            "1111000" when 7,
            "0000000" when 8,
            "0010000" when 9,
            "1000000" when others;

  with d3 select
    seg3 <= "1111001" when 1,
            "0100100" when 2,
            "0110000" when 3,
            "0011001" when 4,
            "0010010" when 5,
            "0000010" when 6,
            "1111000" when 7,
            "0000000" when 8,
            "0010000" when 9,
            "1000000" when others;

  process(clk)
  begin
    if rising_edge(clk) then
      if refresh_counter = REFRESH_CNT then
        refresh_counter <= 0;
        refresh_tick    <= '1';
      else
        refresh_counter <= refresh_counter + 1;
        refresh_tick    <= '0';
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) and refresh_tick = '1' then
      sel <= (sel + 1) mod 3;
    end if;
  end process;

  -- Single driver assignments for outputs based on sel
  dout <= seg1 when sel = 0 else
          seg2 when sel = 1 else
          seg3;

  anod <= "11111110" when sel = 0 else
          "11111101" when sel = 1 else
          "11111011";

end Behavioral;
