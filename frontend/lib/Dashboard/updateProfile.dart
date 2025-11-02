import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// =======================
// ✅ Add your Base URL here
// =======================
const String baseUrl = "http://10.0.2.2:8001/api/users";

class ProfileUpdatePage extends StatefulWidget {
  final String userId;
  final String role;

  const ProfileUpdatePage({
    super.key,
    required this.userId,
    required this.role,
  });

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

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

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // =======================
  // Fetch user profile data
  // =======================
  Future<void> _fetchUserProfile() async {
    final url = Uri.parse("$baseUrl/${widget.userId}");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final user = jsonDecode(response.body);
        print(response.body);

        setState(() {
          nameController.text = user['name'] ?? '';
          emailController.text = user['email'] ?? '';
          passwordController.text = user['password'] ?? '';
          ageController.text = user['age']?.toString() ?? '';
          gender = user['gender'] ?? 'Male';
          phoneController.text = user['contact'] ?? '';
          idCardController.text = user['idCard'] ?? '';

          if (widget.role == "Driver" && user['carDetails'] != null) {
            carTypeController.text = user['carDetails']['carType'] ?? '';
            carNumberController.text = user['carDetails']['carNumber'] ?? '';
            licenseController.text = user['carDetails']['licenseNumber'] ?? '';
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to fetch profile data Samaj AIy hay"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // =======================
  // Update profile API call
  // =======================
  Future<void> _updateProfile() async {
    final url = Uri.parse("$baseUrl/${widget.userId}");

    Map<String, dynamic> body = {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "age": ageController.text,
      "gender": gender,
      "contact": phoneController.text,
      "idCard": idCardController.text,
      "role": widget.role,
    };

    if (widget.role == "Driver") {
      body["carDetails"] = {
        "carType": carTypeController.text,
        "carNumber": carNumberController.text,
        "licenseNumber": licenseController.text,
      };
    }

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("✅ ${data['message']}")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Update failed: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("⚠️ Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blueAccent;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField("Full Name", nameController, Icons.person),
                    _buildField("Email", emailController, Icons.email),
                    _buildField(
                      "Password",
                      passwordController,
                      Icons.lock,
                      obscure: true,
                    ),
                    _buildField("Age", ageController, Icons.calendar_today),
                    _buildField("Contact", phoneController, Icons.phone),
                    _buildField("ID Card", idCardController, Icons.credit_card),
                    const SizedBox(height: 15),
                    _buildGenderSelection(),
                    if (widget.role == "Driver") ...[
                      const Divider(height: 30, color: Colors.grey),
                      const Text(
                        "Car Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildField(
                        "Car Type",
                        carTypeController,
                        Icons.directions_car,
                      ),
                      _buildField(
                        "Car Number",
                        carNumberController,
                        Icons.numbers,
                      ),
                      _buildField(
                        "License Number",
                        licenseController,
                        Icons.badge,
                      ),
                    ],
                    const SizedBox(height: 30),
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
                            _updateProfile();
                          }
                        },
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: (val) => val!.isEmpty ? "Enter $label" : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.blue[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      children: [
        const Text("Gender: "),
        Radio<String>(
          value: "Male",
          groupValue: gender,
          onChanged: (val) => setState(() => gender = val!),
          activeColor: Colors.blueAccent,
        ),
        const Text("Male"),
        Radio<String>(
          value: "Female",
          groupValue: gender,
          onChanged: (val) => setState(() => gender = val!),
          activeColor: Colors.blueAccent,
        ),
        const Text("Female"),
      ],
    );
  }
}
