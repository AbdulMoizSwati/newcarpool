import 'package:carpool_frontend/Authentication/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final idCardController = TextEditingController();
  final carTypeController = TextEditingController();
  final carNumberController = TextEditingController();
  final licenseController = TextEditingController();

  String gender = "Male";
  String role = "Passenger";

  // Calling the Backend Api For Login

  Future<void> sendSignupData() async {
    const String apiUrl = "http://10.0.2.2:8001/api/users/signup";

    // Prepare user data
    Map<String, dynamic> userData = {
      "name": nameController.text,
      "email": emailController.text,
      "age": ageController.text,
      "gender": gender,
      "contact": phoneController.text,
      "idCard": idCardController.text,
      "password": passwordController.text,
      "role": role,
    };

    if (role == "Driver") {
      userData["carDetails"] = {
        "carType": carTypeController.text,
        "carNumber": carNumberController.text,
        "licenseNumber": licenseController.text,
      };
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // ✅ Show success message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("✅ ${responseData['message']}")));

        // Navigate to LoginScreen after a short delay
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
      } else {
        // ❌ Show failure message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Failed: ${response.body}")));
      }
    } catch (e) {
      // ⚠️ Handle network errors
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
          "Create Account",
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
              const SizedBox(height: 20),
              Icon(
                Icons.person_add_alt_1,
                size: 80,
                color: Colors.blueAccent.shade100,
              ),
              const SizedBox(height: 15),
              const Text(
                "Carpool Registration",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 30),

              // Name
              _buildTextField(
                controller: nameController,
                label: "Full Name",
                icon: Icons.person,
                color: primaryColor,
              ),
              const SizedBox(height: 15),

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
              const SizedBox(height: 15),

              // Age
              _buildTextField(
                controller: ageController,
                label: "Age",
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                color: primaryColor,
              ),
              const SizedBox(height: 15),

              // Gender
              _buildGenderSelection(primaryColor),
              const SizedBox(height: 15),

              // Contact
              _buildTextField(
                controller: phoneController,
                label: "Contact Number",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                color: primaryColor,
              ),
              const SizedBox(height: 15),

              // CNIC
              _buildTextField(
                controller: idCardController,
                label: "ID Card Number",
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
                color: primaryColor,
              ),
              const SizedBox(height: 15),

              // Role Selection
              _buildRoleSelection(primaryColor),
              const SizedBox(height: 10),

              // Driver fields
              if (role == "Driver") ...[
                _buildTextField(
                  controller: carTypeController,
                  label: "Car Type",
                  icon: Icons.directions_car,
                  color: primaryColor,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: carNumberController,
                  label: "Car Number",
                  icon: Icons.numbers,
                  color: primaryColor,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: licenseController,
                  label: "License Number",
                  icon: Icons.badge,
                  color: primaryColor,
                ),
              ],

              const SizedBox(height: 25),

              // Signup Button
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
                      // Call The Node Backend Api
                      sendSignupData();
                    }
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Already have an account? Log in",
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

  // 🔹 Gender Selection
  Widget _buildGenderSelection(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(
          children: [
            Radio<String>(
              value: "Male",
              groupValue: gender,
              onChanged: (val) => setState(() => gender = val!),
              activeColor: color,
            ),
            const Text("Male"),
            Radio<String>(
              value: "Female",
              groupValue: gender,
              onChanged: (val) => setState(() => gender = val!),
              activeColor: color,
            ),
            const Text("Female"),
          ],
        ),
      ],
    );
  }

  // 🔹 Role Selection
  Widget _buildRoleSelection(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Role",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(
          children: [
            Radio<String>(
              value: "Passenger",
              groupValue: role,
              onChanged: (val) => setState(() => role = val!),
              activeColor: color,
            ),
            const Text("Passenger"),
            Radio<String>(
              value: "Driver",
              groupValue: role,
              onChanged: (val) => setState(() => role = val!),
              activeColor: color,
            ),
            const Text("Driver"),
          ],
        ),
      ],
    );
  }
}
