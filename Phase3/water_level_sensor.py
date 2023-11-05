import RPi.GPIO as GPIO
import time

# Define the GPIO pin for the simulated water level sensor
sensor_pin = 2

# Set up the GPIO mode
GPIO.setmode(GPIO.BCM)
GPIO.setup(sensor_pin, GPIO.IN)

try:
    while True:
        water_level = GPIO.input(sensor_pin)
        if water_level:
            print("Water level is HIGH.")
        else:
            print("Water level is LOW.")
        time.sleep(1)
except KeyboardInterrupt:
    GPIO.cleanup()
