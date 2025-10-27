import 'package:carpool_frontend/Dashboard/driverDashboard.dart';
import 'package:carpool_frontend/LandingPage/LandingPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DriverDashboard(driverId: "1234", role: "driver", name: "Moiz"),
    );
  }
}
