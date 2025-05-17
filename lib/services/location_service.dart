import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class LocationData {
  final double latitude;
  final double longitude;
  final String? street;
  final String? neighborhood;

  LocationData({
    required this.latitude,
    required this.longitude,
    this.street,
    this.neighborhood,
  });
}

class LocationService {
  final loc.Location _location = loc.Location();

  Future<LocationData?> getCurrentLocation() async {
    try {
      // Verificar permissões
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return null;
      }

      loc.PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) return null;
      }

      // Obter posição
      final locationData = await _location.getLocation();
      
      // Geocoding para obter endereço
      if (locationData.latitude == null || locationData.longitude == null) {
        return null;
      }
      
      final placemarks = await placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );

      if (placemarks.isEmpty) return null;

      final place = placemarks.first;
      return LocationData(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
        street: place.street,
        neighborhood: place.subLocality ?? place.locality,
      );
    } catch (e) {
      print('Erro ao obter localização: $e');
      return null;
    }
  }
}