import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign In',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins', // ใช้ฟอนต์ Poppins
      ),
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img.jpg'), // ใส่ภาพพื้นหลัง
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Center(
          child: Container(
            width: 420,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // สีพื้นหลังโปร่งใส
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withOpacity(0.2), // ขอบโปร่งใส
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // เงา
                  blurRadius: 10,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold, // ขนาดตัวหนา
                  ),
                ),
                SizedBox(height: 30),
                _buildInputBox(
                  context,
                  hintText: 'First name',
                  icon: Icons.person,
                ),
                _buildInputBox(
                  context,
                  hintText: 'Last name',
                  icon: Icons.person_outline,
                ),
                _buildInputBox(
                  context,
                  hintText: 'Email',
                  icon: Icons.email,
                ),
                _buildInputBox(
                  context,
                  hintText: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                _buildInputBox(
                  context,
                  hintText: 'Confirm Password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                SizedBox(height: 20),
                _buildSignInButton(),
                SizedBox(height: 20),
                _buildRegisterLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBox(BuildContext context, {required String hintText, required IconData icon, bool obscureText = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent, // ไม่มีสีพื้นหลังใน input
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white), // สีตัวอักษรใน placeholder
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40), // ขอบมน 40px
            borderSide: BorderSide(
              color: Colors.purple.withOpacity(0.2), // สีขอบโปร่งใส
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.purple.withOpacity(0.5), // สีขอบเมื่อ focused
              width: 2,
            ),
          ),
          suffixIcon: Icon(icon, color: Colors.white), // ไอคอนใน input
        ),
        style: TextStyle(color: Colors.white), // สีข้อความใน input
      ),
    );
  }

  Widget _buildSignInButton() {
    return Container(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          // Sign in logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // สีพื้นหลังของปุ่ม
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40), // ขอบมนของปุ่ม
          ),
          shadowColor: Colors.black.withOpacity(0.1), // เงาใต้ปุ่ม
          elevation: 10,
        ),
        child: Text(
          'Sign In',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold, // ข้อความหนาในปุ่ม
            color: Colors.black, // สีข้อความในปุ่ม
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white),
        ),
        TextButton(
          onPressed: () {
            // Navigate to the register page
          },
          child: Text(
            'Register',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline, // ขีดเส้นใต้ข้อความลิงก์
            ),
          ),
        ),
      ],
    );
  }
}
