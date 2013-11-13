#include <mbed.h>
#include <AnalogIn.h>
#include <lcd/C12832_lcd.h>

DigitalOut myled(LED1);
C12832_LCD lcd;
AnalogIn pot1(p19);
AnalogIn pot2(p20);

int main() {
	int count = 0;
	lcd.setmode(NORMAL);
	while(1) {
		lcd.locate(0,0);
		lcd.printf("count : %d\n", count++);
		lcd.printf("pot 1 : %f\n", pot1.read());
		lcd.printf("pot 2 : %f\n", pot2.read());
		myled = 1;
		wait(0.1);
		myled = 0;
		wait(0.1);
	}
}

