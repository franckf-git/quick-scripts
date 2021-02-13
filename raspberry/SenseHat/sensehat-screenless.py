#!/usr/bin/python3
import pygame
import time
import os

from pygame.locals import *
from sense_hat import SenseHat

pygame.init()
pygame.display.set_mode((640, 480))
sense = SenseHat()
sense.clear()


while True:

    t = sense.get_temperature()
    p = sense.get_pressure()
    h = sense.get_humidity()

    t = round(t, 1)
    p = round(p, 1)
    h = round(h, 1)

    t = "temp {0}".format(t)
    p = "pres {0}".format(p)
    h = "humi {0}".format(h)

    for event in pygame.event.get():
        print(event)
        if event.type == KEYUP:

            if event.key == K_DOWN:
                sense.show_message(t)

            elif event.key == K_UP:
                sense.show_message(p)

            elif event.key == K_LEFT:
                sense.show_message(h)

            elif event.key == K_RIGHT:
                sense.show_message(time.strftime("%H:%M"))

            elif event.key == K_RETURN:
                os.system("sudo poweroff")


