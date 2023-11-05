import paho.mqtt.client as mqtt
import time
import random

# Define MQTT parameters
mqtt_broker = "your_mqtt_broker_address"
mqtt_port = 1883
mqtt_topic = "water_consumption"

# Create a unique client ID
client_id = f"water_sensor_{random.randint(1, 1000)}"

# Create an MQTT client
client = mqtt.Client(client_id)

# Callback when the client successfully connects to the broker
def on_connect(client, userdata, flags, rc):
    print("Connected to MQTT broker with result code " + str(rc))

# Callback when a message is published
def on_publish(client, userdata, mid):
    print(f"Message {mid} published")

# Connect to the MQTT broker
client.on_connect = on_connect
client.on_publish = on_publish
client.connect(mqtt_broker, mqtt_port)

# Simulated water consumption data (replace with actual data)
def simulate_water_consumption():
    return random.uniform(0.1, 2.0)

try:
    client.loop_start()  # Start the MQTT client in the background

    while True:
        # Simulate water consumption data
        water_consumption = simulate_water_consumption()

        # Send the data to the MQTT broker
        client.publish(mqtt_topic, f"Water consumption: {water_consumption} gallons")

        # Print the sent data
        print(f"Sent: Water consumption - {water_consumption} gallons")

        time.sleep(60)  # Send data every 60 seconds (adjust as needed)
except KeyboardInterrupt:
    client.disconnect()
    print("Disconnected from MQTT broker")
