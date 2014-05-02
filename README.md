## VGA IP Core using a dual-port BRAM as a frame buffer
* **This is an example core to show how to access BRAM from both c and vhdl**
* 640x480 Resolution
* Tested with 14.6 ISE Design Suite
* Supports hard-coded 4 x 10-byte objects. Check `vga_fsl.vhd` to change it
* PORT B of a dual port BRAM is connected as the frame buffer, so that C code in SDK can write through PORTA and VHDL side from the ip reads from PORTB

### Using the VGA fsl framebuffer ip core in the EDK project
* Checkout the project and add it to project repository so that it shows up under peripherals tab in EDK
* Drag and drop `AXI BRAM Controller` from IP Catalog to the project
* From the configuration, under `AXI` choose `AXI4LITE` for the `AXI4 Protocol` option, and check `Slave Single Port BRAM` option, then hit OK
* Hit `Hardware -> Configure Coprocessor`
* `vga_fsl` should show up under `Available Coprocessors`. Hit it and hit `<< Add` then hit Ok
* Under `Bus Interfaces` tab expand both the newly generated `axi_bram_block` and `vga_fsl_0` and connect PORTB's together
* Go to `Ports` tab and expand `vga_fsl_0` choose `hsync`, `vsync`, and `rgb`, right click and hit `Make External`
* Generate a 25 MHz clock from `clock_generator`, and hook it up to `vga_clk` port
* If it doesn't automatically, connect `FSL_Clk` to the bus clock, and `SYS_Rst` to the bus reset under `microblaze_to_vga_fsl_0`
* Check `Defaults` under `Port Filters` on the right, and under `Ports` tab expand the `axi_bram_block` and connect `BRAM_Clk_B` to the bus clock
* Add the external pins to the `ucf` file. Following is for `Digilent Nexys3 board`:

```
## VGA Pins for Digilent Nexys3 Board
NET vga_fsl_0_rgb_pin<7> LOC = "N7"  |  IOSTANDARD = "LVCMOS33"; # RED 2
NET vga_fsl_0_rgb_pin<6> LOC = "V7"  |  IOSTANDARD = "LVCMOS33"; # RED 1
NET vga_fsl_0_rgb_pin<5> LOC = "U7"  |  IOSTANDARD = "LVCMOS33"; # RED 0
NET vga_fsl_0_rgb_pin<4> LOC = "V6"  |  IOSTANDARD = "LVCMOS33"; # GREEN 2
NET vga_fsl_0_rgb_pin<3> LOC = "T6"  |  IOSTANDARD = "LVCMOS33"; # GREEN 1
NET vga_fsl_0_rgb_pin<2> LOC = "P8"  |  IOSTANDARD = "LVCMOS33"; # GREEN 0
NET vga_fsl_0_rgb_pin<1> LOC = "T7"  |  IOSTANDARD = "LVCMOS33"; # BLUE 1
NET vga_fsl_0_rgb_pin<0> LOC = "R7"  |  IOSTANDARD = "LVCMOS33"; # BLUE 0
NET vga_fsl_0_hsync_pin  LOC = "N6"  |  IOSTANDARD = "LVCMOS33"; # HSYNC
NET vga_fsl_0_vsync_pin  LOC = "P7"  |  IOSTANDARD = "LVCMOS33"; # VSYNC
```

* Generate bitstream and you should see the stuff in the bram on your monitor. (Well partial, and well black by default probably)
* Head into SDK to write some stuff to the BRAM to display it

### Examples
* Check out `examples/framebufferdemo.c` to see an example on how to write to BRAM from SDK
* Check out `examples/system.mhs` to see an example design
* Download `examples/nexys3_vga_fsl_shared_bram_demo.bit` to your Nexys3 board for the demo that displays bram content on the monitor connected through VGA

