import time
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient

# AWS IoT Core endpoint and your Thing name
endpoint = "your-iot-endpoint.amazonaws.com"
thing_name = "your-thing-name"

# Path to your Thing's certificate and private key
cert_path = "path-to-your-certificate.pem.crt"
private_key_path = "path-to-your-private-key.pem.key"

# Create an AWS IoT MQTT Client
client = AWSIoTMQTTClient(thing_name)
client.configureEndpoint(endpoint, 8883)
client.configureCredentials(cert_path, private_key_path, "path-to-your-root-CA.pem")

# Connect to AWS IoT Core
client.connect()

try:
    while True:
        # Read data from your sensor (e.g., temperature sensor)
        sensor_data = "23.5"  # Replace with actual sensor data

        # Publish the sensor data to a topic
        client.publish("sensors/temperature", sensor_data, 1)
        print("Published: " + sensor_data)
        time.sleep(5)  # Adjust as needed
except KeyboardInterrupt:
    pass

# Disconnect from AWS IoT Core
client.disconnect()
