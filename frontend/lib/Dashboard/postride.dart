import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carpool_frontend/Maps/map.dart';

class PostRidePage extends StatefulWidget {
  final String driverId;
  final String driverName;
  final String vehicleType;
  final String vehiclePlate;
  final String licenseNumber;

  const PostRidePage({
    super.key,
    required this.driverId,
    required this.driverName,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.licenseNumber,
  });

  @override
  State<PostRidePage> createState() => _PostRidePageState();
}

class _PostRidePageState extends State<PostRidePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();

  int availableSeats = 1;
  int pricePerSeat = 100;
  DateTime? departureDate;
  bool isLoading = false; // ✅ loading indicator

  Future<void> _selectLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RideLocationPicker()),
    );

    if (result != null) {
      setState(() {
        pickupController.text = result['pickup']['address'];
        dropoffController.text = result['dropoff']['address'];
      });
    }
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          departureDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _submitRide() async {
    debugPrint("🚀 Post Ride button pressed");

    if (!_formKey.currentState!.validate()) return;

    if (departureDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select departure date & time")),
      );
      return;
    }

    final rideData = {
      "driverId": widget.driverId,
      "driverName": widget.driverName,
      "pickupLocation": pickupController.text.trim(),
      "dropoffLocation": dropoffController.text.trim(),
      "availableSeats": availableSeats,
      "totalSeats": availableSeats,
      "departureDate": departureDate!.toIso8601String(),
      "pricePerSeat": pricePerSeat,
      "vehicleType": widget.vehicleType.isNotEmpty ? widget.vehicleType : "Car",
      "vehiclePlate": widget.vehiclePlate.isEmpty
          ? "1234"
          : widget.vehiclePlate,
      "licenseNumber": widget.licenseNumber,
    };

    setState(() => isLoading = true); // start loading

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8001/api/users/postRide"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(rideData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ride posted successfully!")),
        );
        debugPrint("🚗 Ride Posted: ${response.body}");
        // Clear fields after successful post
        pickupController.clear();
        dropoffController.clear();
        setState(() {
          departureDate = null;
          availableSeats = 1;
          pricePerSeat = 100;
        });
      } else {
        final resBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed: ${resBody['error'] ?? response.reasonPhrase}",
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error posting ride: $e")));
    } finally {
      setState(() => isLoading = false); // stop loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post a Ride"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map picker
              ElevatedButton.icon(
                onPressed: _selectLocation,
                icon: const Icon(Icons.map),
                label: const Text("Select Pickup & Dropoff on Map"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Manual pickup address
              TextFormField(
                controller: pickupController,
                decoration: const InputDecoration(
                  labelText: "Pickup Location (or type manually)",
                  prefixIcon: Icon(Icons.my_location),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter pickup location" : null,
              ),
              const SizedBox(height: 12),

              // Manual dropoff address
              TextFormField(
                controller: dropoffController,
                decoration: const InputDecoration(
                  labelText: "Dropoff Location (or type manually)",
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter dropoff location" : null,
              ),
              const SizedBox(height: 16),

              // License number display
              Text(
                "📝 License Number: ${widget.licenseNumber}",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Seats
              Text("Available Seats", style: GoogleFonts.poppins()),
              DropdownButton<int>(
                value: availableSeats,
                onChanged: (val) => setState(() => availableSeats = val!),
                items: List.generate(6, (i) => i + 1)
                    .map(
                      (n) =>
                          DropdownMenuItem(value: n, child: Text(n.toString())),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),

              // Price
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Price Per Seat (PKR)",
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => pricePerSeat = int.tryParse(v) ?? 100,
              ),
              const SizedBox(height: 10),

              // Departure
              ListTile(
                title: Text(
                  departureDate != null
                      ? "Departure: ${departureDate.toString().substring(0, 16)}"
                      : "Select Departure Date & Time",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDateTime,
              ),
              const SizedBox(height: 20),

              // Submit button
              Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submitRide,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Post Ride"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
