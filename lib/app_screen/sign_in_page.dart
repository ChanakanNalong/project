// import 'package:flutter/material.dart';
// import 'input_field.dart';
// import 'sign_in_button.dart';

// class SignInPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/img.jpg'),
//             fit: BoxFit.cover,
//             alignment: Alignment.center,
//           ),
//         ),
//         child: Center(
//           child: Container(
//             width: 420,
//             padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 10,
//                   offset: Offset(0, 0),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Sign In',
//                   style: TextStyle(
//                     fontSize: 36,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 InputField(hintText: 'First name', icon: Icons.person),
//                 InputField(hintText: 'Last name', icon: Icons.person_outline),
//                 InputField(hintText: 'Email', icon: Icons.email),
//                 InputField(hintText: 'Password', icon: Icons.lock, obscureText: true),
//                 InputField(hintText: 'Confirm Password', icon: Icons.lock_outline, obscureText: true),
//                 SizedBox(height: 20),
//                 SignInButton(),
//                 SizedBox(height: 20),
//                 _buildRegisterLink(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRegisterLink() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           "Don't have an account?",
//           style: TextStyle(color: Colors.white),
//         ),
//         TextButton(
//           onPressed: () {},
//           child: Text(
//             'Register',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               decoration: TextDecoration.underline,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
