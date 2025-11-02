import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PassengerDashboardContent extends StatefulWidget {
  final String passengerId;
  final String name;

  const PassengerDashboardContent({
    super.key,
    required this.passengerId,
    required this.name,
  });

  @override
  State<PassengerDashboardContent> createState() =>
      _PassengerDashboardContentState();
}

class _PassengerDashboardContentState extends State<PassengerDashboardContent> {
  bool isLoading = false;

  // Dummy rides data
  List<Map<String, dynamic>> rides = [
    {
      "from": "City A",
      "to": "City B",
      "departureDate": "2025-11-05 09:00",
      "availableSeats": 3,
      "pricePerSeat": 500
    },
    {
      "from": "City C",
      "to": "City D",
      "departureDate": "2025-11-06 15:30",
      "availableSeats": 2,
      "pricePerSeat": 750
    },
  ];

  @override
  Widget build(BuildContext context) {
    const gradientStart = Color(0xFF56CCF2);
    const gradientEnd = Color(0xFF2F80ED);

    // Fix for fold error
    int totalSpend = rides.fold(0, (sum, r) {
      final price = r['pricePerSeat'];
      return sum + (price != null ? int.tryParse(price.toString()) ?? 0 : 0);
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Passenger Dashboard",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [gradientStart, gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFF7FAFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome back, ${widget.name} 👋",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: gradientEnd,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(Icons.directions_car, "Total Rides",
                      "${rides.length}", gradientEnd),
                  _buildStatCard(Icons.monetization_on, "Total Spend",
                      "Rs. $totalSpend", Colors.green),
                ],
              ),
              const SizedBox(height: 25),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Upcoming / Recent Rides",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: gradientEnd,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : rides.isEmpty
                        ? Center(
                            child: Text(
                              "No rides found.",
                              style: GoogleFonts.poppins(
                                  color: Colors.grey[600], fontSize: 15),
                            ),
                          )
                        : ListView.builder(
                            itemCount: rides.length,
                            itemBuilder: (context, index) {
                              final ride = rides[index];
                              return _rideCard(
                                ride['from'],
                                ride['to'],
                                ride['departureDate'],
                                ride['availableSeats'],
                                ride['pricePerSeat'],
                              );
                            },
                          ),
              ),

              const SizedBox(height: 10),
              Text(
                "Passenger ID: ${widget.passengerId}",
                style:
                    GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Stats Card
  Widget _buildStatCard(IconData icon, String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Ride Card
  Widget _rideCard(String from, String to, String dateTime, int seats, int price) {
    final departure = DateTime.tryParse(dateTime) ?? DateTime.now();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2F80ED),
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          "$from → $to",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2F80ED),
          ),
        ),
        subtitle: Text(
          "${departure.toString().substring(0, 16)} • Seats: $seats • Rs. $price",
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
        ),
      ),
    );
  }
}

