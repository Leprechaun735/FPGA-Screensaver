library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity vga_640x480 is
    port (
        clk   : in std_logic;
        rst   : in std_logic;
        hsync : out std_logic;
        vsync : out std_logic;
        videon: out std_logic;
        hc    : out std_logic_vector(9 downto 0);
        vc    : out std_logic_vector(9 downto 0)
    );
end vga_640x480;

architecture behavioral of vga_640x480 is
    constant hpixels : std_logic_vector(9 downto 0) := "1100100000"; -- 800
    constant vlines  : std_logic_vector(9 downto 0) := "1000001001"; -- 521
	 --constant vlines : std_logic_vector(9 downto 0) := "1000001101"; -- 525, testing
    constant hbp     : std_logic_vector(9 downto 0) := "0010010000"; -- 144
    constant hfp     : std_logic_vector(9 downto 0) := "1100010000"; -- 784
    constant vbp     : std_logic_vector(9 downto 0) := "0000011111"; -- 31
	 --constant vbp : std_logic_vector(9 downto 0) := "0000100011"; -- 35, testing
    constant vfp     : std_logic_vector(9 downto 0) := "0111111111"; -- 511
	 --constant vfp : std_logic_vector(9 downto 0) := "1000000011"; -- 515, for testing
    signal hcs, vcs  : std_logic_vector(9 downto 0); -- horizontal and vertical counters
    signal vsenable  : std_logic; -- enable for the vertical counter
begin
    -- Process for horizontal sync signal
    process(clk, rst)
    begin
        if (rst = '0') then
            hcs <= "0000000000";
				vsenable <= '0';
        elsif (clk'event and clk = '1') then
            if (hcs = hpixels - 1) then
                hcs <= "0000000000"; -- reset horizontal counter
                vsenable <= '1'; -- turn on vertical counter
            else
                hcs <= hcs + 1; -- increment horizontal counter
                vsenable <= '0'; -- turn off vertical enable
            end if;
        end if;
    end process;

    -- Generate horizontal sync pulse
    hsync <= '0' when hcs < "0000001100" else '1'; -- horizontal sync pulse

    -- Process for vertical sync signal
    process(clk, rst, vsenable)
    begin
        if (rst = '0') then
            vcs <= "0000000000";
        elsif (clk'event and clk = '1' and vsenable = '1') then
            if (vcs = vlines - 1) then
                vcs <= "0000000000"; -- reset vertical counter
            else
                vcs <= vcs + 1; -- increment vertical counter
            end if;
        end if;
    end process;

    -- Generate vertical sync pulse
    vsync <= '0' when vcs < "10" else '1';

    -- Enable video output within the porches
    videon <= '1' when (((hcs < hfp) and (hcs >= hbp)) and 
                        ((vcs < vfp) and (vcs >= vbp))) else '0';

    -- Output horizontal and vertical counter
    hc <= hcs;
    vc <= vcs;
end behavioral;
