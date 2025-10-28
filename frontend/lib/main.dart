import 'package:carpool_frontend/LandingPage/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carpool_frontend/Dashboard/driverDashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckSharedPreferences(), // 👈 start from here
    );
  }
}

class CheckSharedPreferences extends StatefulWidget {
  const CheckSharedPreferences({super.key});

  @override
  State<CheckSharedPreferences> createState() => _CheckSharedPreferencesState();
}

class _CheckSharedPreferencesState extends State<CheckSharedPreferences> {
  bool isLoading = true;
  bool isValid = false;

  String? driverId;
  String? role;
  String? name;

  @override
  void initState() {
    super.initState();
    checkSharedPrefs();
  }

  // ✅ Function to check shared preferences
  Future<void> checkSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");
    final savedRole = prefs.getString("role");
    final savedId = prefs.getString("id");
    final savedName = prefs.getString("name");

    // Debug prints (optional)
    print("🧩 Checking SharedPreferences...");
    print("Token: $token");
    print("Role: $savedRole");
    print("ID: $savedId");
    print("Name: $savedName");

    if (token != null &&
        token.isNotEmpty &&
        savedRole != null &&
        savedRole.isNotEmpty &&
        savedId != null &&
        savedId.isNotEmpty &&
        savedName != null &&
        savedName.isNotEmpty) {
      setState(() {
        isValid = true;
        driverId = savedId;
        role = savedRole;
        name = savedName;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ✅ If SharedPreferences data is valid
    if (isValid) {
      return DriverDashboard(
        driverId: driverId ?? "",
        role: role ?? "",
        name: name ?? "",
      );
    }

    // ❌ If SharedPreferences is not valid
    return const Landingpage();
  }
}
