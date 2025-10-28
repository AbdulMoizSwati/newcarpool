import 'package:carpool_frontend/Authentication/Signupage.dart';
import 'package:carpool_frontend/Dashboard/driverDashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Added to store token/user info

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> sendLoginData() async {
    const String apiUrl =
        "http://10.0.2.2:8001/api/users/login"; // ✅ Your backend endpoint

    final Map<String, dynamic> loginData = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loginData),
      );

      setState(() {
        isLoading = false;
      });

      final responseData = jsonDecode(response.body);
      print(responseData["token"]);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // ✅ Save token & user info for later use
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", responseData['token']);
        await prefs.setString("role", responseData['user']['role']);
        await prefs.setString("name", responseData['user']['name']);
        await prefs.setString("id", responseData['user']['id']);

        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("✅ ${responseData['message']}")));

        // ✅ Navigate based on user role
        final role = responseData['user']['role'];
        if (role == "Driver") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DriverDashboard(
                driverId: responseData['user']['id'],
                role: role,
                name: responseData['user']['name'],
              ),
            ),
          );
        } else {
          // TODO: Navigate to PassengerDashboard or Admin if needed
        }
      } else {
        // ❌ Backend error handling
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "❌ ${responseData['message'] ?? 'Login failed, try again!'}",
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("⚠️ Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blueAccent;
    final Color lightColor = Colors.blue[50]!;

    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              Icon(Icons.login, size: 80, color: Colors.blueAccent.shade100),
              const SizedBox(height: 15),
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 30),

              // Email
              _buildTextField(
                controller: emailController,
                label: "Email",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                color: primaryColor,
              ),
              const SizedBox(height: 15),

              // Password
              _buildTextField(
                controller: passwordController,
                label: "Password",
                icon: Icons.lock,
                obscureText: true,
                color: primaryColor,
              ),
              const SizedBox(height: 25),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      sendLoginData();
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Go to Signup
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable Input Field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? "Please enter $label" : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: color),
        labelText: label,
        filled: true,
        fillColor: Colors.blue[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color, width: 1.5),
        ),
      ),
    );
  }
}
