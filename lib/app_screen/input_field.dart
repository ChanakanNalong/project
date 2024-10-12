import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;

  InputField({required this.hintText, required this.icon, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.2), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.5), width: 2),
          ),
          suffixIcon: Icon(icon, color: Colors.white),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
