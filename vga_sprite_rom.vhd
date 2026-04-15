-- Add needed libraries and packages
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga_sprite_rom is
    -- Add generics and inputs and outputs
    generic (
        W : integer := 90;  -- Width of the sprite (in pixels)
		  H : integer := 60
    );

    port (
        hc      : in std_logic_vector(9 downto 0);  -- Horizontal counter
        vc      : in std_logic_vector(9 downto 0);  -- Vertical counter
        videon  : in std_logic;                      -- Video signal (enabled or not)
        red     : out std_logic_vector(3 downto 0);  -- Red VGA color output
        green   : out std_logic_vector(3 downto 0);  -- Green VGA color output
        blue    : out std_logic_vector(3 downto 0);  -- Blue VGA color output
        --sw		 : in std_logic_vector(7 downto 0)    -- Signal indicating if sprite is on
		  xpos : in std_logic_vector(9 downto 0);
		  ypos : in std_logic_vector(8 downto 0);
		  spritenum : in std_logic_vector(1 downto 0)
    );
end vga_sprite_rom;

architecture behavioral of vga_sprite_rom is
    constant hbp : std_logic_vector(9 downto 0) := "0010010000"; -- Horizontal back porch
    constant vbp : std_logic_vector(9 downto 0) := "0000011111"; -- Vertical back porch, 31
	 --constant vbp : std_logic_vector(9 downto 0) := "0000100011"; -- 35, testing
    signal C1, R1 : std_logic_vector(9 downto 0); -- Left upper corner of sprite
    signal x_pix, y_pix : std_logic_vector(9 downto 0); -- Coordinates for sprite positioning
    signal spriteon : std_logic;  -- Signal to indicate if sprite is on
    signal rom_data : std_logic_vector(7 downto 0); -- ROM data bus (8-bit for color)
    signal rom_ptr : integer;  -- ROM pointer index
	 signal rom_ptr1 : integer;  -- ROM pointer index
	 signal rom_ptr2 : integer;  -- ROM pointer index
    type memory is array (0 to W*H-1) of std_logic_vector(7 downto 0); -- Memory type for ROM (256x8-bit)
    signal rom : memory;  -- ROM memory array

    -- Initialize ROM with .mif file (assume this is handled in the environment)
    attribute romstyle : STRING;
    attribute romstyle OF rom: SIGNAL IS "M4K";
	 attribute ram_init_file: STRING;
	 attribute ram_init_file OF rom: SIGNAL IS "john.mif";
	 
	 signal rom1 : memory;  -- ROM1 memory array

    -- Initialize ROM with .mif file (assume this is handled in the environment)
    --attribute romstyle : STRING;
    attribute romstyle OF rom1: SIGNAL IS "M4K";
	 --attribute ram_init_file: STRING;
	 attribute ram_init_file OF rom1: SIGNAL IS "matt.mif";
	 
	 signal rom2 : memory;  -- ROM2 memory array

    -- Initialize ROM with .mif file (assume this is handled in the environment)
    --attribute romstyle : STRING;
    attribute romstyle OF rom2: SIGNAL IS "M4K";
	 --attribute ram_init_file: STRING;
	 attribute ram_init_file OF rom2: SIGNAL IS "patrick.mif";
	 
	 signal rom3 : memory;  -- ROM2 memory array

    -- Initialize ROM with .mif file (assume this is handled in the environment)
    --attribute romstyle : STRING;
    attribute romstyle OF rom3: SIGNAL IS "M4K";
	 --attribute ram_init_file: STRING;
	 attribute ram_init_file OF rom3: SIGNAL IS "professor.mif";

begin
    -- Assign the upper-left corner of the sprite
    --C1 <= "0" & sw(3 downto 0) & "00001";  -- Example value for horizontal starting position
    --R1 <= "0" & sw(7 downto 4) & "00001";  -- Example value for vertical starting position
	 C1 <= xpos;
	 R1 <= "0" & ypos;
	 
    -- Calculate the relative sprite coordinates based on video counters
    y_pix <= vc - vbp - R1;  -- Relative vertical coordinate
    x_pix <= hc - hbp - C1;  -- Relative horizontal coordinate

    -- Check if the pixel is inside the sprite bounds
    spriteon <= '1' when (((hc >= hbp + C1) and (hc < hbp + C1 + W)) and ((vc >= vbp + R1) and (vc < vbp + R1 + H))) else '0';
	
    -- ROM pointer calculation based on pixel coordinates
    rom_ptr <= conv_integer(y_pix) * W + conv_integer(x_pix);
	 --rom_ptr1 <= conv_integer(y_pix) * W + conv_integer(x_pix);
	 --rom_ptr2 <= conv_integer(y_pix) * W + conv_integer(x_pix);
	 --rom_ptr3 <= conv_integer(y_pix) * W + conv_integer(x_pix);
    --rom_data <= rom(rom_ptr);  -- Get the ROM data for the current sprite pixel
	 
	 process(spritenum, rom_data, rom_ptr)
	 begin
		if spritenum = "00" then
			rom_data <= rom(rom_ptr);
		elsif spritenum = "01" then
			rom_data <= rom1(rom_ptr);
		elsif spritenum = "10" then
			rom_data <= rom2(rom_ptr);
		else
			rom_data <= rom3(rom_ptr);
		end if;
	 end process;
		
    process(spriteon, videon, rom_data)
    begin
        -- Default colors (black)
        red <= "0000";
        green <= "0000";
        blue <= "0000";

        -- If sprite is on and video is enabled, decode the color from ROM
        if spriteon = '1' and videon = '1' then
            red <= rom_data(7 downto 5) & '0';   -- Red color from ROM (2 MSB bits)
            green <= rom_data(4 downto 2) & '0'; -- Green color from ROM (2 next MSB bits)
            blue <= rom_data(1 downto 0) & "00";  -- Blue color from ROM (2 LSB bits)
        end if;
    end process;
end behavioral;
