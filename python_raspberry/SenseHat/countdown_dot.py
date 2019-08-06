#!/bin/python3

from sense_hat import SenseHat
from time import sleep

sense = SenseHat()

#compte
for i in range(1,6):
	sense.show_letter( str(i) )
	sleep(1)

#decompte couleur
G = [0,255,0]
for i in range(5,-1,-1):
	sense.show_letter( str(i), G)
	sleep(1)

#decompte point avec flash
G = [0, 255, 0]
R = [255, 0, 0]
X = [0, 0, 0]

s = 20

timer = []

for i in range(64):
	if i < s:
		timer.append(G)
	else:
		timer.append(X)

sense.set_pixels(timer)

for i in range(0,s):
	sleep(1)
	timer[i] = R
	sense.set_pixels(timer)

for i in range(0,10):
	sense.clear()
	sleep(0.1)
	sense.set_pixels(timer)
	sleep(0.1)