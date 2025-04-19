import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../main.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  bool isLoading = false;
  bool isObscure = true;
  bool rememberPassword = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final url = Uri.parse('${AppConfig.baseUrl}/login');
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

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final url = Uri.parse('${AppConfig.baseUrl}/register');
    setState(() => isLoading = true);

    final response = await http.post(url, body: {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    });

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful! Please log in.")),
      );
      _tabController.animateTo(0); // กลับไปหน้า Login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response.body}")),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? isObscure : false,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        if (isEmail) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value)) {
            return 'Invalid email format';
          }
        }
        if (isPassword && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => isObscure = !isObscure),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // ✅ Back Button with safety pop logic
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MainNavigation()),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              const Text("Login", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text(
                "By signing in you are agreeing our",
                style: TextStyle(color: Colors.black54),
              ),
              GestureDetector(
                onTap: () {}, // TODO: term & privacy page
                child: const Text(
                  "Term and privacy policy",
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 20),
              TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                tabs: const [
                  Tab(text: "Login"),
                  Tab(text: "Register"),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // ✅ Login Tab
                      ListView(
                        children: [
                          _buildTextField(controller: emailController, label: "Email Address", isEmail: true),
                          const SizedBox(height: 12),
                          _buildTextField(controller: passwordController, label: "Password", isPassword: true),
                          // Row(
                          //   children: [
                          //     Checkbox(
                          //       value: rememberPassword,
                          //       onChanged: (val) => setState(() => rememberPassword = val ?? false),
                          //     ),
                          //     const Text("Remember password"),
                          //     const Spacer(),
                          //     TextButton(
                          //       onPressed: () {}, // TODO: Forgot password
                          //       child: const Text("Forget password", style: TextStyle(color: Colors.blue)),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(height: 12),
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 48),
                                  ),
                                  child: const Text("Login"),
                                ),
                          const SizedBox(height: 20),
                          // const Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Icon(Icons.facebook, size: 32),
                          //     SizedBox(width: 16),
                          //     Icon(Icons.sports_basketball, size: 32), // placeholder
                          //     SizedBox(width: 16),
                          //     Icon(Icons.linked_camera, size: 32), // placeholder
                          //   ],
                          // ),
                          const SizedBox(height: 20),
                        ],
                      ),

                      // ✅ Register Tab
                      ListView(
                        children: [
                          _buildTextField(controller: nameController, label: "Name"),
                          const SizedBox(height: 12),
                          _buildTextField(controller: emailController, label: "Email", isEmail: true),
                          const SizedBox(height: 12),
                          _buildTextField(controller: passwordController, label: "Password", isPassword: true),
                          const SizedBox(height: 20),
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: _register,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 48),
                                  ),
                                  child: const Text("Register"),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
