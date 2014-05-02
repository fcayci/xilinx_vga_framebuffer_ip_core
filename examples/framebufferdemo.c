#include <stdio.h>
#include <stdlib.h>
#include "xparameters.h"
#include "xbasic_types.h"
#include "xbram.h"

int main()
{
  Xuint32 i;
  // Make sure XPAR_BRAM_0_BASEADDR is the extra BRAM that you added

  // Writing 32-bits at a time for each address.
  //volatile Xuint32 *video_bram = (Xuint32 *) XPAR_BRAM_0_BASEADDR;
  //for(i=0; i < 160; i++) video_bram[i] = 0x1CE01C03+0x20*i;

  // Writing 8-bits at a time for each address
  volatile Xuint8 *video_bram = (Xuint8 *) XPAR_BRAM_0_BASEADDR;
  for(i=0; i < 640; i++) video_bram[i] = (Xuint8)(03+i);

  return 0;
}
