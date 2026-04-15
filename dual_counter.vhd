library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dual_counter is
    Port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        count1  : out INTEGER range 0 to 520;
        count2  : out INTEGER range 0 to 400;
		  hitside : out INTEGER range 0 to 2
    );
end dual_counter;

architecture Behavioral of dual_counter is
    signal count1_reg, count2_reg : INTEGER range 0 to 520;
	 signal hitside_reg : INTEGER range 0 to 2;
    signal direction1, direction2 : STD_LOGIC := '1'; -- '1' for up, '0' for down
begin

    process(clk, reset)
    begin
        if reset = '0' then
            count1_reg <= 0;
            count2_reg <= 0;
            direction1 <= '1';
            direction2 <= '1';
				hitside_reg <= 0;
        elsif rising_edge(clk) then
            -- Counter 1 logic
            if direction1 = '1' then
                if count1_reg < 520 then
                    count1_reg <= count1_reg + 1;
                else
						  hitside_reg <= hitside_reg + 1;
                    direction1 <= '0';
                    count1_reg <= count1_reg - 1; -- Start decreasing
                end if;
            else
                if count1_reg > 0 then
                    count1_reg <= count1_reg - 1;
                else
						  hitside_reg <= hitside_reg + 1;
                    direction1 <= '1';
                    count1_reg <= count1_reg + 1; -- Start increasing
                end if;
            end if;

            -- Counter 2 logic
            if direction2 = '1' then
                if count2_reg < 400 then
                    count2_reg <= count2_reg + 1;
                else
						  hitside_reg <= hitside_reg + 1;
                    direction2 <= '0';
                    count2_reg <= count2_reg - 1; -- Start decreasing
                end if;
            else
                if count2_reg > 0 then
                    count2_reg <= count2_reg - 1;
                else
						  hitside_reg <= hitside_reg + 1;
                    direction2 <= '1';
                    count2_reg <= count2_reg + 1; -- Start increasing
                end if;
            end if;
        end if;
    end process;

    -- Output assignments
    count1 <= count1_reg;
    count2 <= count2_reg;
	 hitside <= hitside_reg;
end Behavioral;
