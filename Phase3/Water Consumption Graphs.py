import random
import time
import csv

# Initialize empty lists to store data
timestamps = []
water_consumption = []

# Create a function to simulate water consumption data
def simulate_water_consumption():
    return random.uniform(0.1, 2.0)

# Generate data for a specified number of data points
num_data_points = 100

for _ in range(num_data_points):
    # Simulate water consumption data
    consumption = simulate_water_consumption()

    # Add data to the lists
    timestamps.append(time.strftime("%Y-%m-%d %H:%M:%S"))
    water_consumption.append(consumption)

# Save the data to a CSV file
with open('water_consumption_data.csv', mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['Timestamp', 'Water Consumption (gallons)'])
    for timestamp, consumption in zip(timestamps, water_consumption):
        writer.writerow([timestamp, consumption])

print(f"Generated {num_data_points} data points and saved to 'water_consumption_data.csv'")
