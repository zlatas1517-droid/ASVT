#include <8051.h>


unsigned char code seg_digits[10] = {
    0xC0, // 0
    0xF9, // 1
    0xA4, // 2
    0xB0, // 3
    0x99, // 4
    0x92, // 5
    0x82, // 6
    0xF8, // 7
    0x80, // 8
    0x90  // 9
};

void delay(unsigned int count) {
    unsigned int i;
    for(i = 0; i < count; i++);
}

void main(void) {
    unsigned int number = 0;
    unsigned char digit = 0;
    unsigned char step = 1;
    
    unsigned char running = 1;
    
  
    unsigned char last_btn1 = 1;
    unsigned char btn1_pressed = 0;
    
 
    unsigned char last_btn2 = 1;
    unsigned char btn2_pressed = 0;
    
    unsigned int i;
    
    
    SCON = 0x00;
    P3 = 0xFF;       
    P1 = 0xFF;       
    
    P2 = seg_digits[0];
    
    while(1) {
        
        if((P3 & 0x01) == 0) {
            if(last_btn1 == 1) {
                btn1_pressed = 1;
            }
            last_btn1 = 0;
        } else {
            last_btn1 = 1;
        }
        
        if(btn1_pressed) {
            delay(100);
            if((P3 & 0x01) == 0) {
                step++;
                if(step > 9) step = 1;
            }
            btn1_pressed = 0;
        }
        
        
        if((P1 & 0x01) == 0) {           
            if(last_btn2 == 1) {
                btn2_pressed = 1;
            }
            last_btn2 = 0;
        } else {
            last_btn2 = 1;
        }
        
        if(btn2_pressed) {
            delay(100);
            
            if((P1 & 0x01) == 0) {      
                
                number = 0;
                step = 1;
                running = 1;
                P2 = seg_digits[0];      
            }
            
            btn2_pressed = 0;
        }
        
       
        if(running == 1) {
            number = number + step;
            digit = number % 10;
            P2 = seg_digits[digit];
        }
        
        delay(300);
    }
}