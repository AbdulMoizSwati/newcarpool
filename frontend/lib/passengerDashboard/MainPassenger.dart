import 'package:carpool_frontend/Dashboard/updateProfile.dart';
import 'package:carpool_frontend/passengerDashboard/AvaliableRides.dart';
import 'package:carpool_frontend/passengerDashboard/dashboard.dart';
import 'package:carpool_frontend/passengerDashboard/passengersRides.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PassengerDashboard extends StatefulWidget {
  final String passengerId;
  final String name;

  const PassengerDashboard({
    super.key,
    required this.passengerId,
    required this.name,
  });

  @override
  State<PassengerDashboard> createState() => _PassengerDashboardState();
}

class _PassengerDashboardState extends State<PassengerDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    final List<Widget> _pages = [
      PassengerDashboardContent(
          passengerId: widget.passengerId, name: widget.name),
          AvailableRidesPage(passengerId: widget.passengerId, passengerName:widget.name),
          MyBookingsPage(passengerId: widget.passengerId),
          
         
      const Center(
          child: Text(
        "Alerts / Notifications Screen",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      )),
      ProfileUpdatePage(userId:widget.passengerId , role:"passenger"),
      
      
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.blue.shade50,
          labelTextStyle: MaterialStateProperty.all(
            GoogleFonts.poppins(fontSize: isSmallScreen ? 11 : 13, fontWeight: FontWeight.w500),
          ),
        ),
        child: NavigationBar(
          height: isSmallScreen ? 55 : 65,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, size: isSmallScreen ? 20 : 24),
              selectedIcon: Icon(Icons.dashboard, color: Colors.blueAccent, size: isSmallScreen ? 22 : 26),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.directions_car_outlined, size: isSmallScreen ? 20 : 24),
              selectedIcon: Icon(Icons.directions_car, color: Colors.blueAccent, size: isSmallScreen ? 22 : 26),
              label: "Available Rides",
            ),
            NavigationDestination(
              icon: Icon(Icons.event_seat_outlined, size: isSmallScreen ? 20 : 24),
              selectedIcon: Icon(Icons.event_seat, color: Colors.blueAccent, size: isSmallScreen ? 22 : 26),
              label: "My Bookings",
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_none, size: isSmallScreen ? 20 : 24),
              selectedIcon: Icon(Icons.notifications, color: Colors.blueAccent, size: isSmallScreen ? 22 : 26),
              label: "Alerts",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, size: isSmallScreen ? 20 : 24),
              selectedIcon: Icon(Icons.person, color: Colors.blueAccent, size: isSmallScreen ? 22 : 26),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
