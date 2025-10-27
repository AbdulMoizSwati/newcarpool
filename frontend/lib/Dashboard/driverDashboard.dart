import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverDashboard extends StatefulWidget {
  final String driverId;
  final String role;
  final String name;

  const DriverDashboard({
    super.key,
    required this.driverId,
    required this.role,
    required this.name,
  });

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  int _selectedIndex = 0;

  // Screens list for bottom navigation
  final List<Widget> _screens = [
    const DashboardHomeScreen(),
    const PostRideScreen(),
    const MyRidesScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.blue.shade50,
          labelTextStyle: MaterialStateProperty.all(
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

//
// --------------- Dashboard Home ---------------
class DashboardHomeScreen extends StatelessWidget {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar("Driver Dashboard"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Greeting
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Welcome back 👋",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Stats Cards
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

            // Recent Ride Placeholder
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
          ],
        ),
      ),
    );
  }

  AppBar _appBar(String title) => AppBar(
    backgroundColor: Colors.blueAccent,
    centerTitle: true,
    title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
  );

  Widget _buildStatCard(
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

  Widget _rideCard(
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

//
// --------------- Post Ride ---------------
class PostRideScreen extends StatelessWidget {
  const PostRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController fromCtrl = TextEditingController();
    final TextEditingController toCtrl = TextEditingController();
    final TextEditingController dateCtrl = TextEditingController();
    final TextEditingController timeCtrl = TextEditingController();
    final TextEditingController priceCtrl = TextEditingController();
    final TextEditingController seatsCtrl = TextEditingController();

    return Scaffold(
      appBar: _appBar("Post a Ride"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _field(fromCtrl, "From"),
              _field(toCtrl, "To"),
              _field(dateCtrl, "Date (e.g., 28 Oct 2025)"),
              _field(timeCtrl, "Time (e.g., 10:00 AM)"),
              _field(seatsCtrl, "Seats Available", type: TextInputType.number),
              _field(priceCtrl, "Price (Rs.)", type: TextInputType.number),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Later you will call your Node.js API here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Ride posted successfully! (API will come later)",
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text("Post Ride"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(String title) => AppBar(
    backgroundColor: Colors.blueAccent,
    centerTitle: true,
    title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
  );

  Widget _field(
    TextEditingController c,
    String label, {
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: c,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

//
// --------------- My Rides ---------------
class MyRidesScreen extends StatelessWidget {
  const MyRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar("My Rides"),
      body: Center(
        child: Text(
          "Your posted rides will appear here once connected with backend.",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ),
    );
  }

  AppBar _appBar(String title) => AppBar(
    backgroundColor: Colors.blueAccent,
    centerTitle: true,
    title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
  );
}

//
// --------------- Notifications ---------------
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar("Notifications"),
      body: Center(
        child: Text(
          "No notifications yet.",
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ),
    );
  }

  AppBar _appBar(String title) => AppBar(
    backgroundColor: Colors.blueAccent,
    centerTitle: true,
    title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
  );
}

//
// --------------- Profile ---------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar("Profile"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 15),
            Text(
              "Driver Name",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "driver@example.com",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Account Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text("Logout"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(String title) => AppBar(
    backgroundColor: Colors.blueAccent,
    centerTitle: true,
    title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
  );
}
