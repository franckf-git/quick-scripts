from sense_hat import SenseHat

sense = SenseHat()
sense.clear()

on_pixel = [255, 0, 0] # Pixel/Point allumé
off_pixel = [0, 0, 0]  # Pixel/Point éteint

while True:
    humidity = sense.get_humidity()
    humidity = round(humidity, 1)

    if humidity > 100:
        humidity = 100.0

    pixels = []
    # Nombre de pixels allumés
    on_count = int((64 / 100.0) * humidity)
    # Nombre de pixels éteint
    off_count = 64 - on_count

    # ajouter X fois le Pixel allumé dans la liste
    pixels.extend([on_pixel] * on_count)
    # puis Y fois le Pixel éteint dans la liste
    pixels.extend([off_pixel] * off_count)

    # Appliquer la liste des pixels éteint/allumés sur la matrice
    sense.set_pixels(pixels)

