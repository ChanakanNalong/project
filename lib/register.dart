// ignore_for_file: prefer_const_constructors, override_on_non_overriding_member, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'HomePage/home.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();

  Future<void> sign_up() async {
  String url = "http://172.16.10.252/api/flutter_login/register.php";
  
  // Create a map for the request body
  final Map<String, String> requestBody = {
    'name': name.text,
    'password': pass.text, // Use password controller
    'email': email.text,
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json", // Set the content type to application/json
      },
      body: json.encode(requestBody), // Encode the body as JSON
    );

    var data = json.decode(response.body);

    if (data == "Error" || data == "Email already exists") {
      // If there's an error, stay on the register page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${data}')),
      );
    } else {
      // If registration is successful, navigate to the login page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  } catch (e) {
    // Show message when there's an error connecting
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: Could not connect to the server.')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Please complete your',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Text(
                    'biodata correctly',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Your name',
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                      controller: name,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Your E-Mail',
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                      controller: email,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Create your Password',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Empty';
                        }
                        return null;
                      },
                      controller: pass,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Re-Type your Password',
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Empty';
                        } else if (val != pass.text) {
                          return 'password not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F60A0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        // Navigator.pushNamed(context, 'home');
                        bool pass = formKey.currentState!.validate();

                        if (pass) {
                          sign_up();
                        }
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // เปลี่ยนสีของข้อความเป็นสีขาว
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
