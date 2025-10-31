import 'package:carpool_frontend/logout/logout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardContent extends StatefulWidget {
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
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  bool isLoading = true;
  List rides = [];

  @override
  void initState() {
    super.initState();
    _fetchRecentRides();
  }

  // Fetch recent rides from backend
  Future<void> _fetchRecentRides() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8001/api/users/postRide/${widget.driverId}"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          rides = data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch rides: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error fetching rides: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const gradientStart = Color(0xFF56CCF2);
    const gradientEnd = Color(0xFF2F80ED);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Driver Dashboard",
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Logout",
            onPressed: () => logoutFunction(context),
          ),
        ],
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
                  _buildStatCard(Icons.monetization_on, "Earnings",
                      "Rs. ${rides.length * 500}", Colors.green),
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
                              "No recent rides found.",
                              style: GoogleFonts.poppins(
                                  color: Colors.grey[600], fontSize: 15),
                            ),
                          )
                        : ListView.builder(
                            itemCount: rides.length,
                            itemBuilder: (context, index) {
                              final ride = rides[index];
                              return _rideCard(
                                ride['pickupLocation'] ?? "Unknown",
                                ride['dropoffLocation'] ?? "Unknown",
                                ride['departureDate'] ?? "",
                                ride['availableSeats'] ?? 0,
                                ride['pricePerSeat'] ?? 0,
                              );
                            },
                          ),
              ),

              const SizedBox(height: 10),
              Text(
                "Driver ID: ${widget.driverId} • Role: ${widget.role}",
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
  Widget _rideCard(
    String from,
    String to,
    String dateTime,
    int seats,
    int price,
  ) {
    final departure = dateTime.isNotEmpty
        ? DateTime.tryParse(dateTime)
        : DateTime.now();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2F80ED),
          child: const Icon(Icons.directions_car, color: Colors.white),
        ),
        title: Text(
          "$from → $to",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2F80ED),
          ),
        ),
        subtitle: Text(
          "${departure != null ? departure.toString().substring(0, 16) : 'Unknown'} • Seats: $seats • Rs. $price",
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
        ),
      ),
    );
  }
}
