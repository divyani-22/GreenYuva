import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Default campus coordinates (Pune University / Campus Hub)
  static const double defaultLatitude = 18.5204;
  static const double defaultLongitude = 73.8567;

  static Position getDefaultPosition() {
    return Position(
      latitude: defaultLatitude,
      longitude: defaultLongitude,
      timestamp: DateTime.now(),
      accuracy: 100,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }

  /// Tries to get the real device/browser location.
  /// Proactively requests permissions if not yet granted.
  /// Falls back to default campus coordinates if permission is denied, disabled, or times out.
  static Future<Position> determinePosition({
    Duration timeLimit = const Duration(seconds: 4),
  }) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('⚠️ Location services are disabled. Using campus fallback.');
        return getDefaultPosition();
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('⚠️ Location permission denied by user. Using campus fallback.');
          return getDefaultPosition();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('⚠️ Location permission denied forever. Using campus fallback.');
        return getDefaultPosition();
      }

      // Permission is granted, attempt to fetch position with timeout
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: timeLimit,
      );

      debugPrint('📍 Location acquired: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      debugPrint('⚠️ Error determining location ($e). Using campus fallback.');
      return getDefaultPosition();
    }
  }

  /// Request location permission explicitly from UI
  static Future<bool> requestPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
    } catch (_) {
      return false;
    }
  }
}
