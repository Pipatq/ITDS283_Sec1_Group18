// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../config.dart';
// import 'profile.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   bool isLoading = false;

//   Future<void> _login() async {
//     final url = Uri.parse('${AppConfig.baseUrl}/login');
//     setState(() => isLoading = true);
//     final response = await http.post(url, body: {
//       'email': emailController.text,
//       'password': passwordController.text,
//     });

//     setState(() => isLoading = false);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setInt('user_id', data['user']['id']);
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => const Profile()));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Login failed")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: [
//             TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
//             TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
//             const SizedBox(height: 24),
//             isLoading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _login,
//                     child: const Text("Login"),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../config.dart';
// import 'profile.dart';
// import 'register.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   bool isLoading = false;

//   Future<void> _login() async {
//     final url = Uri.parse('${AppConfig.baseUrl}/login');
//     setState(() => isLoading = true);
//     final response = await http.post(url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': emailController.text,
//           'password': passwordController.text,
//         }));

//     setState(() => isLoading = false);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setInt('user_id', data['user']['id']);
//       await prefs.setString('username', data['user']['username']);
//       await prefs.setString('avatar', '${AppConfig.baseUrl}/images/${data['user']['avatar']}');
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => const Profile()));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Login failed")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: [
//             TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
//             TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
//             const SizedBox(height: 24),
//             isLoading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _login,
//                     child: const Text("Login"),
//                   ),
//             const SizedBox(height: 12),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
//               },
//               child: const Text("Don't have an account? Register"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../config.dart';
// import 'register.dart';
// import '../main.dart'; // ใช้ MainNavigation เพื่อกลับไปหน้า Profile

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   bool isLoading = false;

//   Future<void> _login() async {
//     final url = Uri.parse('${AppConfig.baseUrl}/login');
//     setState(() => isLoading = true);

//     final response = await http.post(url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': emailController.text,
//           'password': passwordController.text,
//         }));

//     setState(() => isLoading = false);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setInt('user_id', data['user']['id']);
//       await prefs.setString('username', data['user']['username']);
//       await prefs.setString('avatar', '${AppConfig.baseUrl}/images/${data['user']['avatar']}');

//       // ✅ กลับไป MainNavigation พร้อมแสดง Profile
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const MainNavigation(startIndex: 3),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Login failed")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: const InputDecoration(labelText: "Email"),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: "Password"),
//             ),
//             const SizedBox(height: 24),
//             isLoading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _login,
//                     child: const Text("Login"),
//                   ),
//             const SizedBox(height: 12),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const RegisterPage()),
//                 );
//               },
//               child: const Text("Don't have an account? Register"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import 'register.dart';
import '../main.dart'; // ใช้ MainNavigation เพื่อกลับไปหน้า Profile

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    final url = Uri.parse('${AppConfig.baseUrl}/login');
    setState(() => isLoading = true);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', data['user']['id']);
      await prefs.setString('username', data['user']['username']);
      await prefs.setString('avatar', '${AppConfig.baseUrl}/images/${data['user']['avatar']}');

      // ✅ กลับไป MainNavigation พร้อมแสดง Profile tab
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation(startIndex: 3)),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainNavigation()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text("Login"),
                  ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
