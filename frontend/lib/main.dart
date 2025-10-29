import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Your imports
import 'package:carpool_frontend/LandingPage/LandingPage.dart';
import 'package:carpool_frontend/Dashboard/driverDashboard.dart';
// 🚀 Add your future PassengerDashboard when created
// import 'package:carpool_frontend/Dashboard/passengerDashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckSharedPreferences(),
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
  String? role;
  String? userId;
  String? name;
  String? vehicleType;
  String? vehiclePlate;
  String? licenseNumber;

  @override
  void initState() {
    super.initState();
    checkSharedPrefs();
  }

  Future<void> checkSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");
    final savedRole = prefs.getString("role");
    final savedId = prefs.getString("id");
    final savedName = prefs.getString("name");
    final savedVehicleType = prefs.getString("vehicleType");
    final savedVehiclePlate = prefs.getString("vehiclePlate");
    final savedLicenseNumber = prefs.getString("licenseNumber");

    print("🧩 Checking SharedPreferences...");
    print("Token: $token");
    print("Role: $savedRole");
    print("ID: $savedId");
    print("Name: $savedName");

    if (token != null && token.isNotEmpty && savedRole != null) {
      setState(() {
        role = savedRole;
        userId = savedId;
        name = savedName;
        vehicleType = savedVehicleType;
        vehiclePlate = savedVehiclePlate;
        licenseNumber = savedLicenseNumber;
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

    // ✅ Navigate by role
    if (role == "Driver") {
      return DriverDashboard(
        driverId: userId ?? "",
        role: role ?? "Driver",
        name: name ?? "",
        vehicleType: vehicleType ?? "",
        vehiclePlate: vehiclePlate ?? "",
        licenseNumber: licenseNumber ?? "",
      );
    } else if (role == "Passenger") {
      // 🚀 Add when PassengerDashboard exists
      // return PassengerDashboard(
      //   passengerId: userId ?? "",
      //   role: role ?? "Passenger",
      //   name: name ?? "",
      // );
      return const Landingpage(); // temporary placeholder
    }

    // ❌ If not logged in
    return const Landingpage();
  }
}
