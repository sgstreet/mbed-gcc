#include "mbed.h"
 
Serial pc(USBTX, USBRX);
Serial wifi(p9,p10);
 
 
int main() {
    
    pc.printf("Test Wifly!\r\n");
 
    while (1) 
    {
        while(pc.readable())
            wifi.putc(pc.getc());
        while(wifi.readable())
            pc.putc(wifi.getc());
    }
}
