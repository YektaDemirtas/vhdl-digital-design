-- M-bit x N-bit read-only memory
-- M-bit address locations, N-bit wide
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity read_only_mem is
generic(
    M : integer := 4;
    N : integer := 8
);
port(
    clk  : in  std_logic;
    addr : in  std_logic_vector(M - 1 downto 0);
    dout : out std_logic_vector(N - 1 downto 0)
);
end read_only_mem;

architecture rtl of read_only_mem is

    type rom_type is array(0 to 2**M - 1) of std_logic_vector(N - 1 downto 0);

    --         76543210  -> N-bit wide, N is 8 bits
    --         --------
    --   000 | xxxxxxxx
    --   001 | xxxxxxxx
    --   010 | xxxxxxxx
    --   ... |   ....
    --   ... |   ....
    --   110 | xxxxxxxx
    --   111 | xxxxxxxx
    --    ^
    --    M-bit long, M is 3, 2**3 = 8 address lines

    signal ROM : rom_type := (
        x"00", x"04", x"0C", x"0E",
        x"41", x"43", x"49", x"4D",
        x"80", x"84", x"8A", x"8E",
        x"F0", x"F4", x"FA", x"FF"
    );

    -- set attribute to block RAM
    attribute rom_style : string;
    attribute rom_style of ROM : signal is "block";

begin

    process(clk) is
    begin
        if rising_edge(clk) then
            dout <= ROM(to_integer(unsigned(addr)));
        end if;
    end process;

end rtl;
