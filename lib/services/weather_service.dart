import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:project_1/models/wetaher_model.dart';

class WeatherService {
  static const BASE_URL =
      "https://api.openweathermap.org/data/2.5/weather"; // versi API diperbaiki
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    try {
      final response = await http
          .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to load weather data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching weather data: $e');
    }
  }

  Future<String> getCurrentCity() async {
    try {
      // Meminta izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // Mendapatkan posisi saat ini
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Mengonversi koordinat ke daftar placemark
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Mengambil nama kota dari placemark pertama
      String? city = placemarks[0].locality;

      return city ?? "Unknown City";
    } catch (e) {
      throw Exception('Error occurred while fetching city name: $e');
    }
  }
}
