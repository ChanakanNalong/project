import 'package:flutter/material.dart';
import '../ParkingPage/esp32cam.dart';
import '../Graph/graph.dart'; // เปลี่ยนเป็น path ที่ถูกต้อง

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
                'ที่จอดรถ (${parkingSpot.name}) (${parkingSpot.available}/${parkingSpot.total})',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChartPage(), // ใช้ GraphPage ที่คุณสร้างไว้
                  ),
                );
              },
              child: Text('ดูเพิ่มเติม'),
            ),
          ],
        ),
      ),
    );
  }
}
