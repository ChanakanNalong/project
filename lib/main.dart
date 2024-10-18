import 'package:flutter/material.dart';
import 'package:flutter_application_1/HomePage/home.dart';
import 'login.dart';
import 'register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
      routes: {
        'register': (context) => register(),
        'home':(context) => Homepage(),
        'login':(context) => Login(),
      },
    );
  }
}
