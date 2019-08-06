#Orange > resistance > port GPIO 4 (pin 7)
#Rouge > + > bande blanche
#Marron > - > bande noire > GND 

#p = GPIO.PWM(channel, frequence)
#p.start(rapport_cyclique) #ici, rapport_cyclique vaut entre 0.0 et 100.0
#p.ChangeFrequency(nouvelle_frequence)
#p.ChangeDutyCycle(nouveau_rapport_cyclique)
#p.stop()
#GPIO.cleanup()

import RPi.GPIO as GPIO
import time
GPIO.setmode(GPIO.BOARD)
servopin=11
GPIO.setup(servopin,GPIO.OUT)
pwm=GPIO.PWM(servopin,50)
pwm.start(7)
while(1):
		for i in range(0,180):
			DC=1./18.*(i)+2
			pwm.ChangeDutyCycle(DC)
			time.sleep(.02)
		for i in range(180,0,-1):
			DC=1/18.*i+2
			pwm.ChangeDutyCycle(DC)
			time.sleep(.02)
pwm.stop
GPIO.cleanup