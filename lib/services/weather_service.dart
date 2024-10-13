import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/wetaher_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apikey;

  WeatherService(this.apikey);

  Future<Weather> getWeather(String cityName) async {
    try {
      final response = await http
          .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apikey&units=metric'));

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to load weather data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error occured while fetching weather data: $e');
    }
  }

  Future<String> getCurrentCity() async {
    try {
      // meminta izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location Permission are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location Permission are permanently denied, we cannot request permissions.');
      }

      // mendapatkan posisi saat ini
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // mengonversi koordinat saat ini
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // mengambil nama kota dari placemark pertama
      String? city = placemarks[0].locality;

      return city ?? "Unknown city";
    } catch (e) {
      throw Exception('Error occurred while fetching city name: $e');
    }
  }
}
