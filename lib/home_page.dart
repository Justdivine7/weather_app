import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<Map<String, dynamic>> getAdditionalInfo(weatherData) {
    return [
      {
        'label': 'Pressure',
        'value': '${weatherData['main']['pressure']} hPa',
        'icon': Icons.compress
      },
      {
        'label': 'Humidity',
        'value': '${weatherData['main']['humidity']}%',
        'icon': Icons.water_drop,
      },
      {
        'label': 'Wind Speed',
        'value': '${weatherData['wind']['speed']} m/s',
        'icon': Icons.air,
      },
      {
        'label': 'Feels Like',
        'value': '${weatherData['main']['feels_like']} K',
        'icon': Icons.thermostat,
      },

      // {'label':}
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lagos Weather Forecast'),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () => setState(() {}),
              child: const Icon(Icons.refresh),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: ref.watch(fetchWeatherProvider).when(data: (data) {
           final weatherData = data;
          final currentWeather = weatherData['list'][0];
          final currentTemp = weatherData['list'][0]['main']['temp'];
          final currentSky = weatherData['list'][0]['weather'][0]['main'];
          final additionalInfo = getAdditionalInfo(currentWeather);
          return Consumer(
            builder: (context, ref, child) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today',
                        style: TextStyle(
                          // fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  "$currentTemp C",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  currentSky == "Clouds"
                                      ? Icons.cloud
                                      : currentSky == 'Rain'
                                          ? Icons.umbrella
                                          : currentSky == 'Snow'
                                              ? Icons.ac_unit
                                              : currentSky == 'Sun'
                                                  ? Icons.sunny
                                                  : currentSky == 'Clear'
                                                      ? Icons.brightness_7
                                                      : Icons.help_outline,
                                  size: 80,
                                ),
                                Text(
                                  currentSky,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Weather Forecast',
                        style: TextStyle(
                          // fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 150,
                        // width :100,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            final hourlyForecast = weatherData['list'][index + 1];
                            final hourlySky =
                                hourlyForecast['weather'][0]['main'];
                            final hourlyTemp =
                                hourlyForecast['main']['temp'].toString();
                            final time =
                                DateTime.parse(hourlyForecast['dt_txt']);
                            return SizedBox(
                              width: 120,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(DateFormat.Hm().format(time)),
                                      Icon(
                                        hourlySky == 'Clouds'
                                            ? Icons.cloud
                                            : hourlySky == "Rain"
                                                ? Icons.umbrella
                                                : hourlySky == 'Sun'
                                                    ? Icons.sunny
                                                    : hourlySky == 'Snow'
                                                        ? Icons.ac_unit
                                                        : hourlySky == 'Clear'
                                                            ? Icons.brightness_7
                                                            : Icons
                                                                .help_outline,
                                      ),
                                      Text("$hourlyTemp C"),
                                      Text(hourlySky)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Additional Information',
                        style: TextStyle(
                          // fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: additionalInfo.length,
                            itemBuilder: (context, index) {
                              final info = additionalInfo[index];
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        info['label'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        info['icon'],
                                      ),
                                      Text(
                                        info['value'],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }, error: (error, StackTrace) {
          return Text("An error occurred: ${error.toString()}");
        }, loading: () {
          return Text("Loading...");
        }));
  }
}
