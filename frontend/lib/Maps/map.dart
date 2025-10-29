import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class RideLocationPicker extends StatefulWidget {
  const RideLocationPicker({super.key});

  @override
  State<RideLocationPicker> createState() => _RideLocationPickerState();
}

class _RideLocationPickerState extends State<RideLocationPicker> {
  LatLng? pickupLocation;
  LatLng? dropoffLocation;
  String? pickupAddress;
  String? dropoffAddress;

  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        return "${p.street}, ${p.locality}";
      }
    } catch (e) {
      debugPrint("Error fetching address: $e");
    }
    return "Unknown location";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Pickup & Drop-off")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(31.582045, 74.329376), // Lahore
          initialZoom: 13.0,
          onTap: (tapPos, point) async {
            if (pickupLocation == null) {
              pickupLocation = point;
              pickupAddress = await _getAddressFromLatLng(point);
            } else if (dropoffLocation == null) {
              dropoffLocation = point;
              dropoffAddress = await _getAddressFromLatLng(point);
            } else {
              // reset both if user taps third time
              pickupLocation = point;
              dropoffLocation = null;
              pickupAddress = await _getAddressFromLatLng(point);
              dropoffAddress = null;
            }
            setState(() {});
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              if (pickupLocation != null)
                Marker(
                  point: pickupLocation!,
                  width: 50,
                  height: 50,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              if (dropoffLocation != null)
                Marker(
                  point: dropoffLocation!,
                  width: 50,
                  height: 50,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pickupAddress != null
                  ? "📍 Pickup: $pickupAddress"
                  : "Tap map to select pickup",
            ),
            const SizedBox(height: 4),
            Text(
              dropoffAddress != null
                  ? "🎯 Drop-off: $dropoffAddress"
                  : (pickupLocation != null
                        ? "Tap again to select drop-off"
                        : ""),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text("Confirm Locations"),
              onPressed: (pickupLocation != null && dropoffLocation != null)
                  ? () {
                      Navigator.pop(context, {
                        "pickup": {
                          "lat": pickupLocation!.latitude,
                          "lng": pickupLocation!.longitude,
                          "address": pickupAddress,
                        },
                        "dropoff": {
                          "lat": dropoffLocation!.latitude,
                          "lng": dropoffLocation!.longitude,
                          "address": dropoffAddress,
                        },
                      });
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
