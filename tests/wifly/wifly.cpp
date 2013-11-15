#include <mbed.h>
#include <wiflyif/WiflyInterface.h>
#include <lcd/C12832_lcd.h>

Serial serial(USBTX, USBRX);
DigitalOut led1(LED1);
C12832_LCD lcd;
WiflyInterface wifly(p9, p10, p30, p29, "Theo", "137marina137", WPA);

char UNKNOWN[] = "unknown";

int main() {
	led1 = 1;
	int count = 0;
	int connected = -1;
	char *address = UNKNOWN;
	lcd.setmode(NORMAL);
	lcd.cls();
	lcd.locate(0,0);
	lcd.printf("count : %d\n", count++);
	lcd.printf("status: %d\n", connected);
	lcd.printf("address: unknown\n");
	serial.printf("initializing\n");
	if (wifly.init() < 0) {
		serial.printf("initialization failed\n");
		lcd.locate(0,0);
		lcd.printf("failed to initialize");
		exit(0);
	}
	
	while (true) {
		lcd.cls();
		lcd.locate(0,0);
		lcd.printf("count : %d\n", count++);
		lcd.printf("status: %d\n", connected);

		if (connected < 0) {
			serial.printf("connecting\n");
			connected = wifly.connect();
			serial.printf("status: %d\n", connected);
		}

		if (connected) {
			address = wifly.getIPAddress();
		}
		else {
			address = UNKNOWN;
		}
		lcd.printf("address: %s\n", address);
		led1 = !led1;
		wait(0.5);
	}
}

