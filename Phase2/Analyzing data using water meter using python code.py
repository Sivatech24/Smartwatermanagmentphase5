# Import necessary libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load the water meter data (replace 'data.csv' with your file path)
data = pd.read_csv('data.csv')

# Explore the dataset
print(data.head())  # Display the first few rows of data
print(data.info())  # Get information about the dataset

# Data Preprocessing
# Assuming your data has columns like 'timestamp' and 'consumption'
# Convert the 'timestamp' column to a datetime format
data['timestamp'] = pd.to_datetime(data['timestamp'])

# Sort the data by timestamp (if not already sorted)
data = data.sort_values(by='timestamp')

# Calculate daily water consumption by aggregating hourly data (you can adjust the frequency)
daily_consumption = data.resample('D', on='timestamp').sum()

# Data Analysis and Visualization
# Plot daily water consumption over time
plt.figure(figsize=(12, 6))
sns.lineplot(x=daily_consumption.index, y='consumption', data=daily_consumption)
plt.title('Daily Water Consumption Over Time')
plt.xlabel('Date')
plt.ylabel('Water Consumption (gallons)')
plt.grid(True)
plt.show()

# Calculate statistics and insights
mean_daily_consumption = daily_consumption['consumption'].mean()
max_daily_consumption = daily_consumption['consumption'].max()
min_daily_consumption = daily_consumption['consumption'].min()

print(f"Mean Daily Consumption: {mean_daily_consumption} gallons")
print(f"Maximum Daily Consumption: {max_daily_consumption} gallons")
print(f"Minimum Daily Consumption: {min_daily_consumption} gallons")
