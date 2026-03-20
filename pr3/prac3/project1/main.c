#include <8051.h>

void delay()
{
    unsigned int i,j;
    for(i=0;i<10;i++)
        for(j=0;j<5;j++);
}

void cmd(unsigned char c)
{
    P0 = c;

    P2 = 0x00;   
    P2 = 0x01;  
    P2 = 0x00;   

    delay();
}

void data_lcd(unsigned char d)
{
    P0 = d;

    P2 = 0x02;   
    P2 = 0x03;   
    P2 = 0x02;  

    delay();
}

void print(unsigned char *s)
{
    while(*s)
    {
        data_lcd(*s);
        s++;
    }
}

void lcd_init()
{
    delay();
    cmd(0x38);   
    cmd(0x0E);  
    cmd(0x01);  
}

void main()
{
    
    unsigned char word[] = {0xA8,0xAC,0xA0,0xB3,0xA0,0};

    lcd_init();

    while(1)
    {
        cmd(0x80);   
        print(word);
        delay();

        cmd(0x01);

        cmd(0x83);   
        print(word);
        delay();

        cmd(0x01);

        cmd(0xC0);   
        print(word);
        delay();

        cmd(0x01);

        cmd(0xC3);   
        print(word);
        delay();

        cmd(0x01);
    }
}
