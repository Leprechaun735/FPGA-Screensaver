library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity vga_stripes is
    port (
        hc     : in std_logic_vector(9 downto 0);
        vc     : in std_logic_vector(9 downto 0);
        videon : in std_logic;
        red    : out std_logic_vector(3 downto 0);
        green  : out std_logic_vector(3 downto 0);
        blue   : out std_logic_vector(3 downto 0)
    );
end vga_stripes;

architecture behavioral of vga_stripes is
begin
    process(videon, vc)
    begin
        if (videon = '1') then
            case vc(5 downto 4) is
                when "00" =>
                    red <= "1111";   -- full red
                    green <= "0000"; -- no green
                    blue <= "0000";  -- no blue
                when "01" =>
                    red <= "0000";   -- no red
                    green <= "1111"; -- full green
                    blue <= "0000";  -- no blue
                when "10" =>
                    red <= "0000";   -- no red
                    green <= "0000"; -- no green
                    blue <= "1111";  -- full blue
                when "11" =>
                    red <= "0000";   -- no red
                    green <= "0000"; -- no green
                    blue <= "0000";  -- no blue (black stripe)
                when others =>
                    red <= "0000";   -- default off
                    green <= "0000";
                    blue <= "0000";
            end case;
        else
            red <= "0000";   -- turn off all colors if videon is off
            green <= "0000";
            blue <= "0000";
        end if;
    end process;
end behavioral;
