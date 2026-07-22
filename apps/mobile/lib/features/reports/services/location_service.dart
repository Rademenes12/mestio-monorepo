import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

class LocationDetails {
  final double latitude;
  final double longitude;
  final String label;
  final String source;

  LocationDetails({
    required this.latitude,
    required this.longitude,
    required this.label,
    required this.source,
  });
}

@lazySingleton
class LocationService {
  double? _simulatedLatitude;
  double? _simulatedLongitude;
  String? _simulatedLabel;

  Future<LocationDetails> getCurrentLocation() async {
    if (_simulatedLatitude != null && _simulatedLongitude != null) {
      return LocationDetails(
        latitude: _simulatedLatitude!,
        longitude: _simulatedLongitude!,
        label: _simulatedLabel ?? "Lokalizacja ustawiona ręcznie",
        source: "Symulacja 🛠️",
      );
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("error_location_service_disabled");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("error_location_permission_denied");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("error_location_permission_denied_forever");
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 6),
        ),
      );

      return LocationDetails(
        latitude: position.latitude,
        longitude: position.longitude,
        label: "Aktualna pozycja GPS",
        source: "Satelita GPS 🛰️",
      );
    } catch (e) {
      debugPrint("Real GPS query failed: $e - Returning default backup Warszawa coordinates.");
      return LocationDetails(
        latitude: 52.2297,
        longitude: 21.0122,
        label: "Warszawa (Domyślna - brak czujnika/uprawnień)",
        source: "Autodetekcja 📍 (Błąd: ${e.toString().replaceAll('Exception: ', '')})",
      );
    }
  }

  void setSimulationLocation(double lat, double lng, String label) {
    _simulatedLatitude = lat;
    _simulatedLongitude = lng;
    _simulatedLabel = label;
    debugPrint("Location simulator configured override: $label ($lat, $lng)");
  }

  void clearSimulation() {
    _simulatedLatitude = null;
    _simulatedLongitude = null;
    _simulatedLabel = null;
    debugPrint("Location service restored to real raw GPS query.");
  }

  bool get isSimulationActive => _simulatedLatitude != null;
  String? get activeSimulationLabel => _simulatedLabel;
}
