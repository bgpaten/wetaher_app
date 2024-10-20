import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project_1/models/wetaher_model.dart';
import 'package:project_1/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // apikey
  final _WeatherService = WeatherService('11fa70a587543483bb243ef0b7a4f9dd');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _WeatherService.getCurrentCity();

    // get Weather for city
    try {
      final weather = await _WeatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/cerah.json'; // default nya cerah

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/hujan.json';
      case 'thunderstorm':
        return 'assets/petir.json';
      case 'clear':
        return 'assets/cerah.json';
      default:
        return 'assets/cerah.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            Text(_weather?.cityName ?? 'Loading city...'),

            // animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // temperature
            Text('${_weather?.temperature.round()} °C'),

            // cuaca
            Text(_weather?.mainCondition ?? "")
          ],
        ),
      ),
    );
  }
}
