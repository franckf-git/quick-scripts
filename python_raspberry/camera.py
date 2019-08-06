from picamera import PiCamera
from time import sleep

camera=PiCamera()
camera.rotation = 180
camera.start_preview()
sleep(10)
#camera.capture('~/Desktop/image.jpg')
camera.stop_preview()
