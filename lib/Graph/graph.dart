import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

Future<List<DataPoint>> fetchData() async {
  final response = await http.get(Uri.parse('http://172.16.10.250/api/flutter_login/graph.php'));

  print(response.body); // เพิ่มบรรทัดนี้เพื่อตรวจสอบข้อมูลที่ได้รับ

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => DataPoint.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}

class DataPoint {
  final DateTime timestamp; // แกน X เป็น DateTime
  final int value; // แกน Y เป็น value

  DataPoint({required this.timestamp, required this.value});

  factory DataPoint.fromJson(Map<String, dynamic> json) {
    return DataPoint(
      timestamp: DateTime.parse(json['timestamp']), // แปลงจาก string เป็น DateTime
      value: int.parse(json['value']), // แปลงจาก string เป็น int
    );
  }
}

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  late Future<List<DataPoint>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chart Example')),
      body: FutureBuilder<List<DataPoint>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            // คำนวณค่า maxY (ค่ามากสุดของแกน Y) จาก value
            double maxY = snapshot.data!.map((e) => e.value).reduce((a, b) => a > b ? a : b).toDouble();
            double minY = snapshot.data!.map((e) => e.value).reduce((a, b) => a < b ? a : b).toDouble();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 38,
                        getTitlesWidget: (value, meta) {
                          // แปลงค่า X (timestamp) เป็น DateTime
                          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                          return Text("${dateTime.month}/${dateTime.day}"); // แสดงเดือน/วันในแกน X
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          // แสดงค่า Y (value) เป็นตัวเลข
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  minX: snapshot.data!.first.timestamp.millisecondsSinceEpoch.toDouble(), // แกน X เริ่มจาก timestamp แรก
                  maxX: snapshot.data!.last.timestamp.millisecondsSinceEpoch.toDouble(), // แกน X สิ้นสุดที่ timestamp สุดท้าย
                  minY: minY, // ค่า Y ต่ำสุดเป็นค่า value ต่ำสุด
                  maxY: maxY, // ค่า Y สูงสุดเป็นค่า value สูงสุด
                  lineBarsData: [
                    LineChartBarData(
                      spots: snapshot.data!
                          .map((e) => FlSpot(e.timestamp.millisecondsSinceEpoch.toDouble(), e.value.toDouble()))
                          .toList(),
                      isCurved: true,
                      color: Colors.blue.shade900,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
