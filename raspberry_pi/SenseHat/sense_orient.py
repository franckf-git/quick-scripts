from sense_hat import SenseHat

sense = SenseHat()

while True:
    pitch, roll, yaw = sense.get_orientation().values()
    print("Elevation/pitch=%s, Roulis/roll=%s, Embardee/yaw=%s" % (pitch,yaw,roll))
