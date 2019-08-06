from sense_hat import SenseHat

sense = SenseHat()

B = (102, 51, 0)
b = (255, 255, 255)

steve_pixels = [
    B, B, B, B, B, b, B, B,
    B, B, B, B, b, b, B, B,
    b, b, b, b, b, b, B, B,
    B, b, b, B, B, b, B, B,
    B, B, b, B, B, b, b, B,
    B, B, b, b, b, b, b, b,
    B, B, b, b, B, B, B, B,
    B, B, b, B, B, B, B, B,
]

sense.set_pixels(steve_pixels)
