library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Clock_Divider is
  generic (
    operand_width : positive := 8 -- default value
  );
  port (
    clock      : in bit;
    reset      : in bit;
    multiplier : in unsigned(operand_width-1 downto 0) := to_unsigned(45, operand_width);
    divisor    : in unsigned(operand_width-1 downto 0) := to_unsigned(100, operand_width);
    out_enable : buffer bit;
    out_clock  : buffer bit
  );
end entity;

architecture behavior of Clock_Divider is
  signal enable_2x : bit;
begin

  proc_enable : process
    variable phase : unsigned(operand_width downto 0);
  begin
    wait until clock'event and clock = '1';
    phase := phase + unsigned(multiplier);
    if phase >= unsigned(divisor) then
      phase := phase - unsigned(divisor);
      out_enable <= '1';
    else
      out_enable <= '0';
    end if;
    if reset = '0' then
      phase := (others => '0');
      out_enable <= '0';
    end if;
  end process;

  proc_enable2 : process
    variable phase : unsigned(operand_width downto 0);
  begin
    wait until clock'event and clock = '1';
    phase := phase + (unsigned(multiplier) & '0');
    if phase >= unsigned(divisor) then
      phase := phase - unsigned(divisor);
      enable_2x <= '1';
    else
      enable_2x <= '0';
    end if;
    if reset = '0' then
      phase := (others => '0');
      enable_2x <= '0';
    end if;
  end process;

  proc_out_clock : process
  begin
    wait until clock'event and clock = '1';
    if enable_2x = '1' then
      out_clock <= not out_clock;
    end if;
  end process;

end architecture;
