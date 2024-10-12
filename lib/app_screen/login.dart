// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'sign_in.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // ตัวแปรสำหรับเก็บ Username และ Password
  String _username = '';
  String _password = '';

  // ฟังก์ชันสำหรับ login
  Future<void> login(String username, String password) async {
    final url = Uri.parse('https://10.5.50.15/rest_api/login_db.php'); // เปลี่ยนเป็น URL ของ API

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // ถ้า login สำเร็จ
        final data = jsonDecode(response.body);
        print('Login successful: $data');
        // ทำอะไรบางอย่างหลังจาก login สำเร็จ เช่น นำไปสู่หน้าอื่น
      } else {
        print('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: Container(
          width: 420,
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            border: Border.all(color: Colors.purple.withOpacity(0.2), width: 2),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Smart Spots Parking',
                  style: TextStyle(fontSize: 36, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                _buildInputField(
                  hintText: 'Username',
                  icon: Icons.person,
                  onChanged: (value) {
                    _username = value; // เก็บค่า Username
                  },
                ),
                _buildInputField(
                  hintText: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                  onChanged: (value) {
                    _password = value; // เก็บค่า Password
                  },
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    // เรียกฟังก์ชัน login พร้อมส่งค่า Username และ Password
                    await login(_username, _password);
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    shadowColor: Colors.black.withOpacity(0.1),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.white, fontSize: 14.5),
                ),
                TextButton(
                  onPressed: () {
                    // Register action
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    required Function(String) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              obscureText: obscureText,
              style: TextStyle(color: Colors.white),
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.white),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(icon, color: Colors.white),
          ),
        ],
      ),
    );
  }
}



Future<void> login(String username, String password) async {
  final url = Uri.parse('https://10.5.50.15/rest_api/login_db.php'); // URL ของ API ที่คุณต้องการเรียกใช้

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // ถ้าการล็อกอินสำเร็จ คุณสามารถจัดการข้อมูลที่ได้รับจาก API ที่นี่
      final data = jsonDecode(response.body);
      print('Login successful: $data');
      // อาจจะนำผู้ใช้ไปยังหน้าหลักหลังจากล็อกอินสำเร็จ
    } else {
      print('Login failed: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}


// ฟังก์ชั่นแปลงข้อมูล JSON String data เป็น เป็นข้อมูล List<Course>
// List<Course> parseCourses(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//   return parsed.map<Course>((json) => Course.fromJson(json)).toList();
// }
