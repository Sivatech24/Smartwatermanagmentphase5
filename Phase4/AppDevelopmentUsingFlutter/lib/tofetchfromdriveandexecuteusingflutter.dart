  /* # To fetch From Drive and execute*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('JSON Data Display'),
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

  Future<void> downloadCSV() async {
    final googleDriveCsvUrl = 'YOUR_GOOGLE_DRIVE_CSV_URL_HERE';

    final response = await http.get(Uri.parse(googleDriveCsvUrl));

    if (response.statusCode == 200) {
      // Handle the downloaded CSV data, you can save it to a file or process it as needed.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: toggleChartView,
          child: Text(showChart ? 'Show Data' : 'Show Chart'),
        ),
        ElevatedButton(
          onPressed: downloadCSV,
          child: Text('Download CSV'),
        ),
        if (showChart)
          Center(
            child: Container(
              width: 300.0,
              height: 300.0,
              child: SquareChartWidget(data: data),
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

  SquareChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(300.0, 300.0),
      painter: SquareChartPainter(data),
    );
  }
}

class SquareChartPainter extends CustomPainter {
  final List<dynamic> data;

  SquareChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    // Custom painting logic to create the chart here.
    // You can use the previous example's SquareChartPainter logic.
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
