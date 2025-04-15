import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wall_eat_project/service/location_service.dart';

class StoreMapScreen extends StatefulWidget {
  final String storeAddress;
  final String storeName;

  const StoreMapScreen({
    super.key,
    required this.storeAddress,
    required this.storeName,
  });

  @override
  State<StoreMapScreen> createState() => _StoreMapScreenState();
}

class _StoreMapScreenState extends State<StoreMapScreen> {
  LatLng? storePosition;
  LatLng? userPosition;
  double? distanceInMeters;

  @override
  void initState() {
    super.initState();
    _loadMapData();
  }

  Future<void> _loadMapData() async {
    final data =
        await LocationService.getMapDataFromStoreAddress(widget.storeAddress);
    if (data != null) {
      final storePos = data['storePosition'] as LatLng;
      final userPos = data['userPosition'] as LatLng;

      final Distance distance = const Distance();
      final calculatedDistance =
          distance.as(LengthUnit.Meter, userPos, storePos);

      setState(() {
        storePosition = storePos;
        userPosition = userPos;
        distanceInMeters = calculatedDistance;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Impossible de charger les données de localisation')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (storePosition == null || userPosition == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Carte du magasin")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Carte - ${widget.storeName}"),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: storePosition!,
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: storePosition!,
                width: 40,
                height: 40,
                child: const Icon(Icons.store, color: Colors.red, size: 40),
              ),
              Marker(
                point: userPosition!,
                width: 40,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.location_on,
                      color: Colors.blue, size: 40),
                ),
              ),
            ],
          ),
          if (distanceInMeters != null)
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'Distance client → magasin : ${(distanceInMeters! / 1000).toStringAsFixed(2)} km',
                  prependCopyright: false,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
