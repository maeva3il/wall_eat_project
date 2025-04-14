import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  final double storeLat;
  final double storeLng;
  final String storeName;

  const MapScreen({
    required this.storeLat,
    required this.storeLng,
    required this.storeName,
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _userPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _userPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final storeLatLng = LatLng(widget.storeLat, widget.storeLng);
    final userLatLng = LatLng(_userPosition!.latitude, _userPosition!.longitude);

    return Scaffold(
      appBar: AppBar(title: Text("Carte vers ${widget.storeName}")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: userLatLng,
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('user'),
            position: userLatLng,
            infoWindow: const InfoWindow(title: 'Vous'),
          ),
          Marker(
            markerId: const MarkerId('store'),
            position: storeLatLng,
            infoWindow: InfoWindow(title: widget.storeName),
          ),
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId('route'),
            points: [userLatLng, storeLatLng],
            color: Colors.blue,
            width: 5,
          ),
        },
      ),
    );
  }
}
