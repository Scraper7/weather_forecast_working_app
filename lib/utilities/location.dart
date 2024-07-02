import 'package:geolocator/geolocator.dart';

class Location {
  late double latitude;
  late double longitude;

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Проверяем, включены ли службы геолокации
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      // Проверяем статус разрешения
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Разрешения запрещены навсегда, обработайте этот случай
        throw 'Location permissions are permanently denied.';
      }

      // Если разрешения предоставлены, получаем текущее местоположение
      Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .timeout(Duration(seconds: 10));

      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      throw 'Something goes wrong: $e';
    }
  }
}
