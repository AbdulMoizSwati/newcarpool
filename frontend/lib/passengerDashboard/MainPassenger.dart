import 'package:carpool_frontend/passengerDashboard/dashboard.dart';
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
    // Dummy pages for now
    final List<Widget> _pages = [
      PassengerDashboardContent(passengerId: widget.passengerId, name: widget.name),
      
      const Center(child: Text("Available Rides Screen", textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
      const Center(child: Text("My Bookings Screen", textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
      const Center(child: Text("Alerts / Notifications Screen", textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
      Center(child: Text("Profile Screen\nPassenger: ${widget.name}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 18))),
    ];

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
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.directions_car_outlined),
              selectedIcon: Icon(Icons.directions_car, color: Colors.blueAccent),
              label: "Available Rides",
            ),
            NavigationDestination(
              icon: Icon(Icons.event_seat_outlined),
              selectedIcon: Icon(Icons.event_seat, color: Colors.blueAccent),
              label: "My Bookings",
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
