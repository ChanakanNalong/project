import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'course_screen.dart';
// import 'exam_result_screen.dart';
// import 'student_screen.dart';

import '../model/course.dart';
import 'package:http/http.dart' as http;

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
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
                  ),
                  _buildInputField(
                    hintText: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: false,
                            onChanged: (value) {},
                            activeColor: Colors.white,
                            checkColor: Colors.black,
                          ),
                          Text(
                            'Remember me',
                            style: TextStyle(color: Colors.white, fontSize: 14.5),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Forgot password action
                        },
                        child: Text(
                          'Forgot password',
                          style: TextStyle(color: Colors.white, fontSize: 14.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      // Login action
                    },
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.white,
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
                      'Register',
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
      ),
    );
  }

  Widget _buildInputField({required String hintText, required IconData icon, bool obscureText = false}) {
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
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.white),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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

// สรัางฟังก์ชั่นดึงข้อมูล คืนค่ากลับมาเป็นข้อมูล Future ประเภท List ของ Course
Future<List<Course>> fetchCourses() async {
  // ทำการดึงข้อมูลจาก server ตาม url ที่กำหนด
  final response =
      await http.get(Uri.parse('http://10.5.50.47/api/course.php'));

  // เมื่อมีข้อมูลกลับมา
  if (response.statusCode == 200) {
    // ส่งข้อมูลที่เป็น JSON String data ไปทำการแปลง เป็นข้อมูล List<Course
    // โดยใช้คำสั่ง compute ทำงานเบื้องหลัง เรียกใช้ฟังก์ชั่นชื่อ parsecourses
    // ส่งข้อมูล JSON String data ผ่านตัวแปร response.body
    return compute(parseCourses, response.body);
  } else {
    // กรณี error
    throw Exception('Failed to load Course');
  }
}

// ฟังก์ชั่นแปลงข้อมูล JSON String data เป็น เป็นข้อมูล List<Course>
List<Course> parseCourses(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Course>((json) => Course.fromJson(json)).toList();
}