import RPi.GPIO as GPIO
import time

# Set the GPIO mode and pins
GPIO.setmode(GPIO.BCM)
TRIG_PIN = 23
ECHO_PIN = 24

# Set up the GPIO pins
GPIO.setup(TRIG_PIN, GPIO.OUT)
GPIO.setup(ECHO_PIN, GPIO.IN)

def get_water_level():
    # Trigger the ultrasonic sensor
    GPIO.output(TRIG_PIN, True)
    time.sleep(0.00001)
    GPIO.output(TRIG_PIN, False)

    # Record the time when the ultrasonic pulse is transmitted
    while GPIO.input(ECHO_PIN) == 0:
        pulse_start = time.time()

    # Record the time when the echo is received
    while GPIO.input(ECHO_PIN) == 1:
        pulse_end = time.time()

    # Calculate the time difference between the start and end
    pulse_duration = pulse_end - pulse_start

    # The speed of sound in air (343 m/s)
    # Distance = time x speed of sound / 2 (since the sound travels to the object and back)
    distance = (pulse_duration * 34300) / 2

    # Water level is the total sensor height minus the distance measured
    sensor_height = 100  # Example sensor height in cm
    water_level = sensor_height - distance

    return water_level

try:
    while True:
        level = get_water_level()
        print(f"Water level: {level:.2f} cm")
        time.sleep(1)

except KeyboardInterrupt:
    GPIO.cleanup()
