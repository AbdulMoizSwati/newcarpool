import 'package:carpool_frontend/passengerDashboard/MainPassenger.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carpool_frontend/LandingPage/LandingPage.dart';
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
      home: CheckLogin(),
    );
  }
}

class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
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
    _checkSharedPreferences();
  }

  Future<void> _checkSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");
    final savedRole = prefs.getString("role");
    final savedId = prefs.getString("id");
    final savedName = prefs.getString("name");
    final savedVehicleType = prefs.getString("carType");
    final savedVehiclePlate = prefs.getString("carNumber");
    final savedLicenseNumber = prefs.getString("licenseNumber");

    if (token != null && token.isNotEmpty && savedRole != null) {
      role = savedRole;
      userId = savedId;
      name = savedName;
      vehicleType = savedVehicleType;
      vehiclePlate = savedVehiclePlate;
      licenseNumber = savedLicenseNumber;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Navigate based on role
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
      return PassengerDashboard(
        passengerId: userId ?? "",
        name: name ?? "",
      );
    } else {
      // If not logged in
      return const Landingpage();
    }
  }
}
