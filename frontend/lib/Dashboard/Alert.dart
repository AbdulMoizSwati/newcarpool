import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AlertPage extends StatefulWidget {
  final String driverId;

  const AlertPage({super.key, required this.driverId});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  bool isLoading = true;
  List bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchPendingBookings();
  }

  Future<void> _fetchPendingBookings() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(
          "http://10.0.2.2:8001/api/users/pendingrides/${widget.driverId}",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          if (data is Map && data.containsKey('bookings')) {
            bookings = List.from(data['bookings']);
          } else if (data is List) {
            bookings = data;
          } else {
            bookings = [];
          }
        });
      } else {
        _showSnack("Failed to fetch bookings: ${response.reasonPhrase}");
      }
    } catch (e) {
      _showSnack("Error fetching bookings: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateBookingStatus(String bookingId, String action) async {
    try {
      final response = await http.put(
        Uri.parse("http://10.0.2.2:8001/api/bookings/$bookingId"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': action}),
      );

      if (response.statusCode == 200) {
        _showSnack("Booking ${action}ed successfully");
        _fetchPendingBookings(); // refresh list
      } else {
        _showSnack("Failed to update: ${response.reasonPhrase}");
      }
    } catch (e) {
      _showSnack("Error updating booking: $e");
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Booking Alerts",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFF5F9FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              )
            : bookings.isEmpty
            ? const Center(
                child: Text(
                  "No pending booking requests.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : RefreshIndicator(
                onRefresh: _fetchPendingBookings,
                color: Colors.blueAccent,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    final ride = booking['rideId'];

                    // ✅ Safe access for populated data
                    if (ride == null || ride is! Map) {
                      return const SizedBox.shrink(); // skip invalid entries
                    }

                    final departureDate = ride['departureDate'];
                    DateTime? departure;
                    try {
                      if (departureDate != null) {
                        departure = DateTime.parse(departureDate);
                      }
                    } catch (_) {}

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Passenger: ${booking['passengerName'] ?? 'Unknown'}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _detailRow(
                              Icons.route,
                              "${ride['pickupLocation'] ?? 'N/A'} → ${ride['dropoffLocation'] ?? 'N/A'}",
                            ),
                            _detailRow(
                              Icons.event_seat,
                              "Seats: ${booking['seatsBooked'] ?? 0}",
                            ),
                            if (departure != null)
                              _detailRow(
                                Icons.calendar_month,
                                "Departure: ${DateFormat('EEE, MMM d • hh:mm a').format(departure)}",
                              ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade600,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => _updateBookingStatus(
                                    booking['_id'],
                                    'accept',
                                  ),
                                  icon: const Icon(Icons.check_circle_outline),
                                  label: const Text("Accept"),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade600,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => _updateBookingStatus(
                                    booking['_id'],
                                    'reject',
                                  ),
                                  icon: const Icon(Icons.cancel_outlined),
                                  label: const Text("Reject"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white.withOpacity(0.95)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
