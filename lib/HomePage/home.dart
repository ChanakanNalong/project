import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'ParkingPage/cam_detect.dart';
import 'yolo_service.dart';
import 'package:http/http.dart' as http;
import '../Graph/graph.dart'; // เปลี่ยนเป็น path ที่ถูกต้อง

Future<void> sendToDatabase(data) async {
  String url = "http://-your ip-/api/flutter_login/yolo_service.php";
  await http.post(
    Uri.parse(url),
      headers: {
        "Content-Type": "application/json"
      }, 
      body: json.encode(data));
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final yoloService = YoloWebSocketService();

    // เรียกใช้ใน initState หรือฟังก์ชัน setup อื่นๆ
    await yoloService.init('ws://172.16.10.249:81');

    // เรียกใช้งาน YoloWebSocket และส่งข้อมูลขึ้นฐานข้อมูล
    await yoloService.startDetection();

    // จำนวนรถที่ detect ได้
    int numberOfCars = yoloService.yoloResults.length;

    // ส่งข้อมูลไปยังฐานข้อมูล (สมมติว่ามีฟังก์ชัน sendToDatabase)
    await sendToDatabase(numberOfCars);

    // หยุดการตรวจจับ
    await yoloService.stopDetection();

    // ปิดบริการเมื่อไม่ใช้งานแล้ว
    await yoloService.dispose();

    return Future.value(true);
  });
}

// สร้างคลาสสำหรับที่จอดรถ
class ParkingSpot {
  final String name; // ชื่อที่จอดรถ
  final int available; // จำนวนที่จอดรถที่ว่าง
  final int total; // จำนวนที่จอดรถทั้งหมด

  ParkingSpot(this.name, this.available, this.total);
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  List<ParkingSpot> parkingSpots = [
    ParkingSpot('อาคาร 1', 20, 30),
    ParkingSpot('อาคาร 2', 15, 25),
    ParkingSpot('อาคาร 3', 5, 10),
    ParkingSpot('อาคาร 4', 10, 20),
  ]; // รายการที่จอดรถ
  List<ParkingSpot> filteredParkingSpots = [];

  @override
  void initState() {
    super.initState();
    filteredParkingSpots = parkingSpots; // แสดงทั้งหมดในตอนเริ่มต้น
    _searchController.addListener(_filterParkingSpots); // ฟังการเปลี่ยนแปลงใน TextField
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterParkingSpots() {
    final query = _searchController.text.toLowerCase(); 
    setState(() {
      filteredParkingSpots = parkingSpots
          .where((spot) => spot.name.toLowerCase().contains(query))
          .toList(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('     Smart spots parking'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    'Show parking status',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search your location...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
              SizedBox(height: 16),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredParkingSpots.length,
                itemBuilder: (context, index) {
                  return ParkingCard(index: index, parkingSpot: filteredParkingSpots[index]);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }
}

class ParkingCard extends StatelessWidget {
  final int index;
  final ParkingSpot parkingSpot;

  ParkingCard({required this.index, required this.parkingSpot});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.local_parking, size: 40, color: Colors.blue),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'ที่จอดรถ (${parkingSpot.name})', // ลบส่วน (${parkingSpot.available}/${parkingSpot.total}) ออก
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // ปุ่มที่มีอยู่แล้ว
            TextButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YoloWebSocket(), // ใช้ GraphPage ที่คุณสร้างไว้
                  ),
                );
              },
              child: Text('ดูเพิ่มเติม'),
            ),
            // ปุ่มแสดงกราฟ
            IconButton(
              icon: Icon(Icons.show_chart, color: Colors.blue),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChartPage(), // นำไปสู่หน้ากราฟที่คุณสร้างไว้
                  ),
                );
              },
            ),
            // ปุ่มใหม่ที่เพิ่มขึ้นมา
            IconButton(
              icon: Icon(Icons.info_outline),
              color: Colors.blue,
              onPressed: () {
                // แสดงข้อมูลที่จอดรถเพิ่มเติมใน Dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('ข้อมูลที่จอดรถ'),
                      content: Text('จอดรถได้ ${parkingSpot.available} จากทั้งหมด ${parkingSpot.total} ช่องจอด.'), // ข้อมูลยังคงมีอยู่
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('ปิด'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}