from sense_hat import SenseHat

sense = SenseHat()
sense.clear()

while True:
        humidity = sense.get_humidity()
        humidity = round(humidity, 1)
        print(humidity)
