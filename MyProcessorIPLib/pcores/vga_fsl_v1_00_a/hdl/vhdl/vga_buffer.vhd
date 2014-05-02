-- Display buffer for VGA screen for 2 object game

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_buffer is
  generic (OBJECT_SIZE : natural := 10);
  port(
    video_on            : in std_logic;
    pixel_x, pixel_y    : in std_logic_vector(0 to OBJECT_SIZE-1);
    object1x, object1y  : in std_logic_vector(0 to OBJECT_SIZE-1);
    object2x, object2y  : in std_logic_vector(0 to OBJECT_SIZE-1);
    bram_enb            : out std_logic;
    -- BRAM Ports
    bram_addrb          : out std_logic_vector(0 to 31);
    bram_doutb          : in  std_logic_vector(0 to 31);
		bram_wenb           : out std_logic_vector(0 to 3);
		bram_dinb           : out std_logic_vector(0 to 31);
		bram_rstb           : out std_logic;
		-- RGB out
    graph_rgb           : out std_logic_vector(7 downto 0)
   );
end vga_buffer;

architecture arch of vga_buffer is
	signal bram_data_buffer : std_logic_vector(0 to 31);
	signal bram_addr_buffer : std_logic_vector(0 to 31);
begin

  bram_wenb <= (others => '0');  -- Always disable writing, only c can write to the bram
  bram_rstb <= '0';              -- Always disable reset
  bram_dinb <= (others => '0');  -- Nothing to write from here

  -- Enable bram when in the active area
  bram_enb <= '1' when video_on = '1' else '0';

  -- Active bram addresses : BRAM_Addr(16:29) for 16KB BRAM (DS444)
  bram_addr_buffer <= x"00000" & "00" & pixel_x(0 to 9);

  -- Increment address every four pixel
  bram_addrb <= bram_addr_buffer and x"FFFFFFFC";

  -- Get the data, 
  bram_data_buffer <= bram_doutb when video_on = '1' else (others => '0');

  process(video_on, bram_data_buffer)
  begin
    if bram_addr_buffer(30 to 31) = "00" and video_on = '1' then
      graph_rgb <= bram_data_buffer(0 to 7);
    elsif bram_addr_buffer(30 to 31) = "01" and video_on = '1' then
      graph_rgb <= bram_data_buffer(8 to 15);
    elsif bram_addr_buffer(30 to 31) = "10" and video_on = '1' then
      graph_rgb <= bram_data_buffer(16 to 23);
    elsif bram_addr_buffer(30 to 31) = "11" and video_on = '1' then
      graph_rgb <= bram_data_buffer(24 to 31);
    else
	  graph_rgb <= x"00";
    end if;
  end process;
end arch;
