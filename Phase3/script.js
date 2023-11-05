document.addEventListener("DOMContentLoaded", () => {
  // Simulated water consumption data (replace with real data)
  const consumptionData = [
    { date: "2023-10-01", value: 100 },
    { date: "2023-10-02", value: 120 },
    { date: "2023-10-03", value: 90 },
    // Add more data points
  ];

  // Extract data for analysis
  const totalConsumption = consumptionData.reduce((total, data) => total + data.value, 0);
  const averageConsumption = (totalConsumption / consumptionData.length).toFixed(2);

  // Display total and average consumption
  document.getElementById("total-consumption").textContent = totalConsumption;
  document.getElementById("average-consumption").textContent = averageConsumption;

  // Create a chart using Chart.js (replace with your chart library)
  const labels = consumptionData.map((data) => data.date);
  const values = consumptionData.map((data) => data.value);

  const ctx = document.getElementById("consumption-chart").getContext("2d");
  const consumptionChart = new Chart(ctx, {
    type: "line",
    data: {
      labels: labels,
      datasets: [
        {
          label: "Water Consumption (liters)",
          data: values,
          borderColor: "blue",
          borderWidth: 2,
          fill: false,
        },
      ],
    },
    options: {
      scales: {
        x: {
          type: "time",
          time: {
            unit: "day",
          },
        },
        y: {
          beginAtZero: true,
        },
      },
    },
  });
});
