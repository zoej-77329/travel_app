import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LocationMapScreen extends StatefulWidget {
  const LocationMapScreen({super.key});

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  LatLng? currentLocation;
  final MapController _mapController = MapController();

  // Example destination: Paris
  final LatLng parisLocation = LatLng(48.8566, 2.3522);

  String locationText = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  // ================= GET USER LOCATION =================
  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => locationText = "GPS is OFF");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => locationText = "Permission denied");
        return;
      }
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentLocation = LatLng(pos.latitude, pos.longitude);
      locationText =
      "Lat: ${pos.latitude.toStringAsFixed(4)}, Lng: ${pos.longitude.toStringAsFixed(4)}";
    });

    _mapController.move(currentLocation!, 5);
  }

  // ================= DISTANCE CALC =================
  double _distanceInKm() {
    final Distance distance = Distance();
    return distance(currentLocation!, parisLocation) / 1000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Location"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: currentLocation == null
          ? Center(child: Text(locationText))
          : Column(
        children: [
          // ================= MAP =================
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentLocation!,
                initialZoom: 5,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  "https://tile.openstreetmap.de/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.travel_app',
                ),

                // ================= LINE (PATH) =================
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [currentLocation!, parisLocation],
                      strokeWidth: 4,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),

                // ================= MARKERS =================
                MarkerLayer(
                  markers: [
                    // User
                    Marker(
                      point: currentLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),

                    // Paris
                    Marker(
                      point: parisLocation,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.flag,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ================= INFO =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= MODERN HEADER =================
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Route Info",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  "From: Your Current Location",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800),
                ),
                Text(
                  "To: Paris, France",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800),
                ),
                const SizedBox(height: 8),
                Text(
                  "Distance: ${_distanceInKm().toStringAsFixed(1)} km",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "Estimated time: ~8–10 hours (flight)",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}