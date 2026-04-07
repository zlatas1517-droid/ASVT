#include <8051.h>

void main(void) {
    unsigned char i;
    unsigned char *ptr;
    
  
    ptr = (unsigned char *)0x30;
    
    *ptr = 0x41; ptr++;  // A
    *ptr = 0x42; ptr++;  // B
    *ptr = 0x43; ptr++;  // C
    *ptr = 0x44; ptr++;  // D
    *ptr = 0x45; ptr++;  // E
    *ptr = 0x46; ptr++;  // F
    *ptr = 0x47; ptr++;  // G
    *ptr = 0x48; ptr++;  // H
    *ptr = 0x49; ptr++;  // I
    *ptr = 0x4A; ptr++;  // J
    *ptr = 0x4B; ptr++;  // K
    *ptr = 0x4C; ptr++;  // L
    *ptr = 0x4D; ptr++;  // M
    *ptr = 0x4E; ptr++;  // N
    *ptr = 0x4F; ptr++;  // O
    *ptr = 0x50; ptr++;  // P
    *ptr = 0x51; ptr++;  // Q
    *ptr = 0x52; ptr++;  // R
    *ptr = 0x53; ptr++;  // S
    *ptr = 0x54; ptr++;  // T
    
   
    PCON = 0x00;
    TMOD = 0x20;
    TH1 = 0xE6;
    TL1 = 0xE6;
    TR1 = 1;
    SCON = 0x40;
   
    ptr = (unsigned char *)0x30;
    
    for (i = 0; i < 20; i++) {
        SBUF = *ptr;
        while (!TI);
        TI = 0;
        ptr++;
    }
    
    while (1);
}


