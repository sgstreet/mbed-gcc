#include <mbed.h>
#include <lcd/C12832_lcd.h>

DigitalOut myled(LED1);
C12832_LCD lcd;

int main() {
	int count = 0;
	lcd.setmode(NORMAL);
	while(1) {
		lcd.locate(0,0);
		lcd.printf("count : %d", count++);
		myled = 1;
		wait(0.2);
		myled = 0;
		wait(0.2);
	}
}

