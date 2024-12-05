import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secret.dart';

final fetchWeatherProvider = FutureProvider((ref) {
  final weatherProvider = ref.watch(weatherRepositoryProvider);
  return weatherProvider.getCurrentWeather();
});

final weatherRepositoryProvider = Provider((ref) => WeatherRepository());

class WeatherRepository {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
            'http://api.openweathermap.org/data/2.5/forecast?id=2332459&units=metric&appid=$apiKey'),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode != 200) {
        throw Exception('Failed to load weather');
      }
      return data;
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }
}
