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
  bool isLoading = false;

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
      "vehiclePlate": widget.vehiclePlate.isEmpty ? "1234" : widget.vehiclePlate,
      "licenseNumber": widget.licenseNumber,
    };

    setState(() => isLoading = true);

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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error posting ride: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const gradientStart = Color(0xFF56CCF2);
    const gradientEnd = Color(0xFF2F80ED);
    const midColor = Color(0xFF3FA4EE);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Post a Ride",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 22,
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
        // 🌈 Full gradient background matching AppBar
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 110, 16, 20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.25),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: _selectLocation,
                    icon: const Icon(Icons.map_rounded, color: Colors.white),
                    label: Text(
                      "Select Pickup & Dropoff on Map",
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gradientEnd,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: pickupController,
                    label: "Pickup Location",
                    icon: Icons.my_location,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Enter pickup location" : null,
                  ),
                  const SizedBox(height: 14),

                  _buildTextField(
                    controller: dropoffController,
                    label: "Dropoff Location",
                    icon: Icons.location_on,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Enter dropoff location" : null,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "🪪 License: ${widget.licenseNumber}",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text("Available Seats",
                      style: GoogleFonts.poppins(fontSize: 15)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<int>(
                    value: availableSeats,
                    onChanged: (val) => setState(() => availableSeats = val!),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: midColor, width: 1.6),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: List.generate(6, (i) => i + 1)
                        .map((n) => DropdownMenuItem(
                              value: n,
                              child: Text("$n seat${n > 1 ? 's' : ''}"),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 14),

                  _buildTextField(
                    label: "Price per Seat (PKR)",
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => pricePerSeat = int.tryParse(v) ?? 100,
                  ),
                  const SizedBox(height: 14),

                  ListTile(
                    tileColor: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Text(
                      departureDate != null
                          ? "Departure: ${departureDate.toString().substring(0, 16)}"
                          : "Select Departure Date & Time",
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                    trailing:
                        const Icon(Icons.calendar_month, color: midColor),
                    onTap: _selectDateTime,
                  ),
                  const SizedBox(height: 30),

                  Center(
                    child: isLoading
                        ? const CircularProgressIndicator(color: midColor)
                        : ElevatedButton(
                            onPressed: _submitRide,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 14),
                              backgroundColor: gradientEnd,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 6,
                            ),
                            child: Text(
                              "Post Ride",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    IconData? icon,
    TextEditingController? controller,
    TextInputType? keyboardType,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    const midColor = Color(0xFF3FA4EE);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: midColor),
        labelStyle: const TextStyle(color: midColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: midColor, width: 1.6),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF56CCF2), width: 1.2),
        ),
      ),
    );
  }
}
