import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
GPIO.setup(14, GPIO.OUT)
GPIO.setup(15, GPIO.OUT)
GPIO.setup(18, GPIO.OUT)
GPIO.setup(23, GPIO.OUT)

while (True):
	GPIO.output(18, True)
	time.sleep(0.1)
	GPIO.output(18, False)
	time.sleep(0.1)

	GPIO.output(15, True)
	time.sleep(0.1)
	GPIO.output(15, False)
	time.sleep(0.1)

	GPIO.output(14, True)
	time.sleep(0.1)
	GPIO.output(14, False)
	time.sleep(0.1)

	GPIO.output(23, True)
	time.sleep(0.1)
	GPIO.output(23, False)
	time.sleep(0.1)

