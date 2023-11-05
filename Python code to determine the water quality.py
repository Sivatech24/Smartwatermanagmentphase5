import time
import board
import adafruit_ads1x15.ads1115 as ADS
from adafruit_ads1x15.analog_in import AnalogIn
# Initialize the ADC (Analog-to-Digital Converter)
i2c = board.I2C()
ads = ADS.ADS1115(i2c)
# Create an analog input object for the pH sensor channel (A0 on ADS1115)
ph_sensor = AnalogIn(ads, ADS.P0)
def read_ph():
# Read the voltage from the pH sensor
raw_voltage = ph_sensor.voltage
# Convert the voltage to pH (adjust conversion factor as needed)
conversion_factor = 3.0 # Adjust this factor based on sensor calibration
pH_value = raw_voltage * conversion_factor
return pH_value
try:
while True:
pH = read_ph()
print(f"pH value: {pH:.2f}")
time.sleep(1)
except KeyboardInterrupt:
pass
Python code to determine the water consumption:
import RPi.GPIO as GPIO
import time
# Set the GPIO mode and pin for the flow sensor
GPIO.setmode(GPIO.BCM)
FLOW_SENSOR_PIN = 17
# Initialize variables
total_water_consumed = 0
last_pulse_time = 0
# Setup the GPIO pin for the flow sensor
GPIO.setup(FLOW_SENSOR_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)
def count_pulses(channel):
global total_water_consumed
global last_pulse_time
current_time = time.time()
elapsed_time = current_time - last_pulse_time
last_pulse_time = current_time
# Assuming the flow sensor generates one pulse per liter of water
flow_rate = 1.0 / elapsed_time
total_water_consumed += flow_rate
# Add an event listener to the flow sensor
GPIO.add_event_detect(FLOW_SENSOR_PIN, GPIO.FALLING, callback=count_pulses)
try:
while True:
print(f"Total water consumed: {total_water_consumed:.2f} liters")
time.sleep(1)
except KeyboardInterrupt:
GPIO.cleanup()
