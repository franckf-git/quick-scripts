from sense_hat import SenseHat

sense = SenseHat()
sense.clear()

temp = sense.get_temperature()
#temp = sense.get_temperature_from_pressure()
#temp = sense.get_temperature_from_humidity()
temp = round(temp, 1)
print(temp)

#while True:
#  temp = sense.get_temperature()
#  temp = round(temp, 1)
#  print(temp)
