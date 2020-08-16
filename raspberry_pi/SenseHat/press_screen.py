from sense_hat import SenseHat

sense = SenseHat()
sense.clear()

ratio = 255 / 100.0

while True:
    pressure = sense.get_pressure()
    pressure = round(pressure, 1) - 1000
    blue = int(ratio * pressure)
    if blue > 255:
        blue = 255
    sense.clear((0, 0, blue))
