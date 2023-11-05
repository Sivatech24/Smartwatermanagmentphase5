import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Water Consumption Display'),
        ),
        body: JsonDataView(),
      ),
    );
  }
}

class JsonDataView extends StatefulWidget {
  @override
  _JsonDataViewState createState() => _JsonDataViewState();
}

class _JsonDataViewState extends State<JsonDataView> {
  List<dynamic> data = [];
  bool showChart = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final jsonContent = await rootBundle.loadString('assets/data.json');
    final jsonData = json.decode(jsonContent);

    if (jsonData is List) {
      setState(() {
        data = jsonData;
      });
    }
  }

  void toggleChartView() {
    setState(() {
      showChart = !showChart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: toggleChartView,
          child: Text(showChart ? 'Show Data' : 'Show Chart'),
        ),
        if (showChart)
          Center(
            child: SquareChartWidget(
              data: data,
              chartSize: 300.0,
            ),
          )
        else
          DataListWidget(data: data),
      ],
    );
  }
}

class SquareChartWidget extends StatelessWidget {
  final List<dynamic> data;
  final double chartSize;

  SquareChartWidget({
    required this.data,
    required this.chartSize,
  });

  @override
  Widget build(BuildContext context) {
    final List<Offset> dataPoints = data
        .asMap()
        .entries
        .map((entry) {
          final x = entry.key.toDouble();
          final y = double.tryParse(entry.value['Hourly Consumption'].toString()) ?? 0.0;
          return Offset(x, y);
        })
        .toList();

    return Container(
      width: chartSize,
      height: chartSize,
      child: CustomPaint(
        size: Size(chartSize, chartSize),
        painter: SquareChartPainter(dataPoints, chartSize),
      ),
    );
  }
}

class SquareChartPainter extends CustomPainter {
  final List<Offset> dataPoints;
  final double chartSize;

  SquareChartPainter(this.dataPoints, this.chartSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0;

    // Define the chart boundaries
    final double minX = 0;
    final double maxX = dataPoints.length - 1.0;
    final double minY = 0;
    final double maxY = dataPoints.map((point) => point.dy).reduce((a, b) => a > b ? a : b);

    // Calculate scaling factors for the x and y axes
    final double xScale = chartSize / (maxX - minX);
    final double yScale = chartSize / (maxY - minY);

    final path = Path();

    for (int i = 0; i < dataPoints.length; i++) {
      final x = (dataPoints[i].dx - minX) * xScale;
      final y = chartSize - (dataPoints[i].dy - minY) * yScale;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw the x-axis and y-axis
    canvas.drawLine(Offset(0, chartSize), Offset(chartSize, chartSize), paint); // x-axis
    canvas.drawLine(Offset(0, chartSize), Offset(0, 0), paint); // y-axis

    // Label the x-axis and y-axis with values
    final textStyle = TextStyle(color: Colors.black, fontSize: 12);
    final axisTextStyle = TextStyle(color: Colors.black, fontSize: 16);

    for (int i = 1; i <= 5; i++) {
      final xLabel = (maxX * i / 5).toStringAsFixed(1);
      final yLabel = (maxY * i / 5).toStringAsFixed(1);

      final xPosition = i * (chartSize / 5);
      final yPosition = chartSize - i * (chartSize / 5);

      TextPainter(
        text: TextSpan(text: xLabel, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: chartSize)
        ..paint(canvas, Offset(xPosition, chartSize + 8));

      TextPainter(
        text: TextSpan(text: yLabel, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: chartSize)
        ..paint(canvas, Offset(-20, yPosition - 8));
    }

    // Label the axes
    TextPainter(
      text: TextSpan(text: 'Time', style: axisTextStyle),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: chartSize)
      ..paint(canvas, Offset(chartSize / 2 - 20, chartSize + 30));

    TextPainter(
      text: TextSpan(text: 'Consumption', style: axisTextStyle),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: chartSize)
      ..paint(canvas, Offset(-120, chartSize / 2 - 20));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DataListWidget extends StatelessWidget {
  final List<dynamic> data;

  DataListWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time: ${item["Time"]}'),
                  Text('Hourly Consumption: ${item["Hourly Consumption"]}'),
                  Text('Daily Consumption: ${item["Daily Consumption"]}'),
                  Text('Weekly Consumption: ${item["Weekly Consumption"]}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
