import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AvailableRidesPage extends StatefulWidget {
  final String passengerId;
  final String passengerName; // Add passengerName too
  const AvailableRidesPage({
    super.key,
    required this.passengerId,
    required this.passengerName,
  });

  @override
  State<AvailableRidesPage> createState() => _AvailableRidesPageState();
}

class _AvailableRidesPageState extends State<AvailableRidesPage> {
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  List rides = [];

  @override
  void initState() {
    super.initState();
    _fetchAvailableRides();
  }

  Future<void> _fetchAvailableRides() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8001/api/availabeRides"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          rides = data;
          isLoading = false;
          hasError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = "Failed to fetch rides: ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = "Error fetching rides: $e";
      });
    }
  }

  Future<void> _bookRide(String rideId, int seatsBooked) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8001/api/BookRide"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "rideId": rideId,
          "passengerId": widget.passengerId,
          "passengerName": widget.passengerName,
          "seatsBooked": seatsBooked,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ride booked successfully!")),
        );
        _fetchAvailableRides(); // refresh rides
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to book ride: ${data['error']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error booking ride: $e")),
      );
    }
  }

  void _showSeatSelectorDialog(Map ride) {
    int selectedSeats = 1;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Seats"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Available Seats: ${ride['availableSeats']}"),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: selectedSeats > 1
                          ? () => setState(() => selectedSeats--)
                          : null,
                    ),
                    Text(
                      selectedSeats.toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: selectedSeats < ride['availableSeats']
                          ? () => setState(() => selectedSeats++)
                          : null,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _bookRide(ride['_id'], selectedSeats);
            },
            child: const Text("Book"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Rides"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text(errorMessage))
              : RefreshIndicator(
                  onRefresh: _fetchAvailableRides,
                  child: rides.isEmpty
                      ? const Center(child: Text("No rides available currently."))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: rides.length,
                          itemBuilder: (context, index) {
                            final ride = rides[index];
                            final departure = DateTime.parse(ride['departureDate']);

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          ride['driverName'] ?? "Unknown Driver",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Seats: ${ride['availableSeats']}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "${ride['pickupLocation']} → ${ride['dropoffLocation']}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Price: Rs ${ride['pricePerSeat']}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Departure: ${DateFormat('EEE, MMM d • hh:mm a').format(departure)}",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () =>
                                            _showSeatSelectorDialog(ride),
                                        child: const Text("Book Ride"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}
