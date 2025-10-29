import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:carpool_frontend/Maps/map.dart';

class BookRidePage extends StatefulWidget {
  const BookRidePage({super.key});

  @override
  State<BookRidePage> createState() => _BookRidePageState();
}

class _BookRidePageState extends State<BookRidePage> {
  LatLng? pickupLocation;
  LatLng? dropoffLocation;
  String? pickupAddress;
  String? dropoffAddress;

  Future<void> _openLocationPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RideLocationPicker()),
    );

    if (result != null) {
      setState(() {
        pickupLocation = LatLng(
          result["pickup"]["lat"],
          result["pickup"]["lng"],
        );
        dropoffLocation = LatLng(
          result["dropoff"]["lat"],
          result["dropoff"]["lng"],
        );
        pickupAddress = result["pickup"]["address"];
        dropoffAddress = result["dropoff"]["address"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book a Ride")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: _openLocationPicker,
              icon: const Icon(Icons.map),
              label: const Text("Select Pickup & Drop-off"),
            ),
            const SizedBox(height: 20),
            if (pickupLocation != null)
              Text(
                "📍 Pickup: $pickupAddress\n(${pickupLocation!.latitude.toStringAsFixed(4)}, ${pickupLocation!.longitude.toStringAsFixed(4)})",
              ),
            const SizedBox(height: 10),
            if (dropoffLocation != null)
              Text(
                "🎯 Drop-off: $dropoffAddress\n(${dropoffLocation!.latitude.toStringAsFixed(4)}, ${dropoffLocation!.longitude.toStringAsFixed(4)})",
              ),
          ],
        ),
      ),
    );
  }
}
