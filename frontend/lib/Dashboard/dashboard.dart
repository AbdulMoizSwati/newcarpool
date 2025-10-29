import 'package:carpool_frontend/logout/logout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardContent extends StatelessWidget {
  final String driverId;
  final String name;
  final String role;

  const DashboardContent({
    super.key,
    required this.driverId,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          "Driver Dashboard",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Logout",
            onPressed: () {
              logoutFunction(context); // ✅ Calls your existing logout function
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Welcome back, $name 👋",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  Icons.directions_car,
                  "Total Rides",
                  "12",
                  Colors.blue,
                ),
                _buildStatCard(
                  Icons.monetization_on,
                  "Earnings",
                  "Rs. 3,200",
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Rides",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _rideCard("Downtown", "Airport", "10:00 AM", "Today", 3, 500),
                  _rideCard(
                    "University",
                    "Mall Road",
                    "5:30 PM",
                    "Tomorrow",
                    2,
                    250,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Driver ID: $driverId | Role: $role",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatCard(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(title, style: GoogleFonts.poppins(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  static Widget _rideCard(
    String from,
    String to,
    String time,
    String date,
    int seats,
    int price,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.directions_car, color: Colors.white),
        ),
        title: Text(
          "$from → $to",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "$date • $time • Seats: $seats • Rs. $price",
          style: GoogleFonts.poppins(fontSize: 13),
        ),
      ),
    );
  }
}
