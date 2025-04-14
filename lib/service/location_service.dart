import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static Future<Position> getCurrentPosition() async {
    var status = await Permission.location.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      throw Exception("Permission de localisation refusée.");
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    final distance = Distance();
    return distance(LatLng(lat1, lon1), LatLng(lat2, lon2));
  }

  static Future<Map<String, dynamic>?> getMapDataFromStoreAddress(String address) async {
    try {
      final encodedAddress = Uri.encodeComponent(address);
      final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$encodedAddress&format=json&limit=1');

      final response = await http.get(url, headers: {
        'User-Agent': 'WallEatApp/1.0 (admin@gmail.com)',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final location = data[0];
          final storeLat = double.parse(location['lat']);
          final storeLng = double.parse(location['lon']);
          final storePosition = LatLng(storeLat, storeLng);

          final userPosition = await getCurrentPosition();
          final userLatLng = LatLng(userPosition.latitude, userPosition.longitude);

          final distance = calculateDistance(
            storeLat, storeLng,
            userPosition.latitude, userPosition.longitude,
          );

          return {
            'storePosition': storePosition,
            'userPosition': userLatLng,
            'distance': distance,
          };
        }
      }
    } catch (e) {
      print("Erreur lors du chargement des données carte : $e");
    }

    return null;
  }
}
