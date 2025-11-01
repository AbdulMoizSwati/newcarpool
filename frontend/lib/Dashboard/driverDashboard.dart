import 'package:carpool_frontend/Dashboard/Alert.dart';
import 'package:carpool_frontend/Dashboard/MyRides.dart';
import 'package:carpool_frontend/Dashboard/dashboard.dart';
import 'package:carpool_frontend/Dashboard/postride.dart';
import 'package:carpool_frontend/Dashboard/updateProfile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverDashboard extends StatefulWidget {
  final String driverId;
  final String role;
  final String name;
  final String vehicleType;
  final String vehiclePlate;
  final String licenseNumber;

  const DriverDashboard({
    super.key,
    required this.driverId,
    required this.role,
    required this.name,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.licenseNumber,
  });

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize dashboard tabs with driver info
    _pages = [
      DashboardContent(
        driverId: widget.driverId,
        name: widget.name,
        role: widget.role,
      ),
      PostRidePage(
        driverId: widget.driverId,
        driverName: widget.name,
        vehicleType: widget.vehicleType,
        vehiclePlate: widget.vehiclePlate,
        licenseNumber: widget.licenseNumber, // ✅ fixed & valid
      ),
      MyRidesPage(driverId: widget.driverId),

      AlertPage(driverId: widget.driverId),
      ProfileUpdatePage(userId: widget.driverId, role: widget.role),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.blue.shade50,
          labelTextStyle: WidgetStateProperty.all(
            GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        child: NavigationBar(
          height: 65,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard, color: Colors.blueAccent),
              label: "Dashboard",
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline),
              selectedIcon: Icon(Icons.add_circle, color: Colors.blueAccent),
              label: "Post Ride",
            ),
            NavigationDestination(
              icon: Icon(Icons.directions_car_outlined),
              selectedIcon: Icon(
                Icons.directions_car,
                color: Colors.blueAccent,
              ),
              label: "My Rides",
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_none),
              selectedIcon: Icon(Icons.notifications, color: Colors.blueAccent),
              label: "Alerts",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: Colors.blueAccent),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
