import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyRidesPage extends StatefulWidget {
  final String driverId;

  const MyRidesPage({super.key, required this.driverId});

  @override
  State<MyRidesPage> createState() => _MyRidesPageState();
}

class _MyRidesPageState extends State<MyRidesPage> {
  bool isLoading = true;
  List rides = [];

  @override
  void initState() {
    super.initState();
    _fetchRides();
  }

  // Fetch rides from backend
  Future<void> _fetchRides() async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8001/api/users/postRide/${widget.driverId}"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          rides = data; // List of rides
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to fetch rides: ${response.reasonPhrase}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching rides: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Delete ride by ID
  Future<void> _deleteRide(String rideId) async {
    try {
      final response = await http.delete(
        Uri.parse("http://10.0.2.2:8001/api/users/$rideId"),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ride deleted successfully")),
        );
        _fetchRides(); // Refresh list after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete ride: ${response.reasonPhrase}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error deleting ride: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Rides"),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : rides.isEmpty
          ? const Center(child: Text("You have not posted any rides yet."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rides.length,
              itemBuilder: (context, index) {
                final ride = rides[index];
                final departure = DateTime.parse(ride['departureDate']);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      "${ride['pickupLocation']} → ${ride['dropoffLocation']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(
                          "Departure: ${DateFormat('yyyy-MM-dd – kk:mm').format(departure)}",
                        ),
                        Text("Available Seats: ${ride['availableSeats']}"),
                        Text("Price per Seat: PKR ${ride['pricePerSeat']}"),
                        Text(
                          "Vehicle: ${ride['vehicleType']} (${ride['vehiclePlate']})",
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteRide(ride['_id']); // Use ride _id from backend
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
