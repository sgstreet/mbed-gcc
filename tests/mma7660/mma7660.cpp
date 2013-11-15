#include <mbed.h>
#include <rtos.h>
#include <wiflyif/WiflyInterface.h>
#include <wiflyif/Socket/UDPSocket.h>
#include <wiflyif/Socket/Endpoint.h>
#include <mma7660/MMA7660.h>
#include <lcd/C12832_lcd.h>

DigitalOut LEDs[4] = {
	DigitalOut(LED1), 
	DigitalOut(LED2), 
	DigitalOut(LED3), 
	DigitalOut(LED4)
};

const char *orientation_strings[] = { "Up", "Down", "Right" , "Left" , "Back", "Front", "Unknown" };

MMA7660 mma7660(p28, p27);
C12832_LCD lcd;

float data[3] = {0.0, 0.0, 0.0};
MMA7660::Orientation orientation;

WiflyInterface wifly(p9, p10, p30, p29, "Theo", "137marina137", WPA);
UDPSocket socket = UDPSocket();
Endpoint remote = Endpoint();

void blink(void const *arg) {
	LEDs[(int)arg] = !LEDs[(int)arg];
}

void accelerate(void const *arg) {
	mma7660.readData(data);
	orientation = mma7660.getOrientation();
}

void display(void const *arg) {
	lcd.cls();
	lcd.locate(0,0);
	lcd.printf("xyz: %4.2f %4.2f %4.2f\n", data[0]*100, data[1]*100, data[2]*100);
	lcd.printf("o: %s\n", orientation_strings[orientation]);
}

void post(void const *arg) {
	char buffer[1024];

	sprintf(buffer, "x: %4.2f y: %4.2f z: %4.2f o: %s\n", data[0]*100, data[1]*100, data[2]*100, orientation_strings[orientation]);
	socket.sendTo(remote, buffer, strlen(buffer));
}

int main() {
	RtosTimer led_1_timer(blink, osTimerPeriodic, 0);
	RtosTimer mma7660_timer(accelerate, osTimerPeriodic, 0);
	RtosTimer display_timer(display, osTimerPeriodic, 0);
	RtosTimer post_timer(post, osTimerPeriodic, 0);
	
	lcd.setmode(NORMAL);
	lcd.cls();

	wifly.init();
	wifly.connect();
	socket.init();
	remote.set_address("192.168.137.83", 20000);

	led_1_timer.start(500);
	display_timer.start(100);
	mma7660_timer.start(2);
    	post_timer.start(100);

	Thread::wait(osWaitForever);
}

