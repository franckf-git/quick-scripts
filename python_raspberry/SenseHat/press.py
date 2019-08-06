from sense_hat import SenseHat

sense = SenseHat()
sense.clear()

while True:
    pressure = sense.get_pressure()
    pressure = round(pressure, 1)
    print(pressure)
