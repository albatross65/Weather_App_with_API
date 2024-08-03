import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Climate extends StatefulWidget {
  const Climate({super.key});

  @override
  State<Climate> createState() => _ClimateState();
}

class _ClimateState extends State<Climate> {
  String _cityName = "Vehari";
  String _apiKey = "9b5b33f7ba441fa075990f6473b75875";
  Map<String, dynamic>? _weatherData;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();

    // Set the system navigation bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff20002c),
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  Future<void> _fetchWeatherData() async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$_cityName&appid=$_apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        _weatherData = json.decode(response.body);
      });
    } else {
      print('Failed to fetch weather data');
    }
  }

  void _searchCity(String value) {
    setState(() {
      _cityName = value;
      _fetchWeatherData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff20002c), Color(0xffcbb4d4), Color(0xff20002c)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _weatherData == null
            ? Center(child: CircularProgressIndicator())
            : _buildWeatherInfo(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search any location',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        onSubmitted: _searchCity,
      ),
    );
  }

  Widget _buildWeatherInfo() {
    String weatherDescription = _weatherData!['weather'][0]['description'];
    String weatherIconUrl = 'https://openweathermap.org/img/wn/${_weatherData!['weather'][0]['icon']}@2x.png';

    String formatTime(int timestamp) {
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      return DateFormat('hh:mm a').format(date);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSearchBar(),
          ),
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff20002c), Color(0xffcbb4d4)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.network(
                      weatherIconUrl,
                      width: 80,
                      height: 80,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_weatherData!['name']}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${_weatherData!['main']['temp']}°C',
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${weatherDescription}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildWeatherDetail(
                      icon: Icons.air,
                      label: 'Wind',
                      value: '${_weatherData!['wind']['speed']} m/s',
                    ),
                    _buildWeatherDetail(
                      icon: Icons.opacity,
                      label: 'Humidity',
                      value: '${_weatherData!['main']['humidity']}%',
                    ),
                    _buildWeatherDetail(
                      icon: Icons.compress,
                      label: 'Pressure',
                      value: '${_weatherData!['main']['pressure']} hPa',
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildWeatherDetail(
                      icon: Icons.thermostat,
                      label: 'Feels Like',
                      value: '${_weatherData!['main']['feels_like']}°C',
                    ),
                    _buildWeatherDetail(
                      icon: Icons.wb_sunny,
                      label: 'Sunrise',
                      value: formatTime(_weatherData!['sys']['sunrise']),
                    ),
                    _buildWeatherDetail(
                      icon: Icons.nights_stay,
                      label: 'Sunset',
                      value: formatTime(_weatherData!['sys']['sunset']),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildWeatherDetail(
                      icon: Icons.calendar_today,
                      label: 'Date',
                      value: DateTime.now().toLocal().toString().split(' ')[0],
                    ),
                    _buildWeatherDetail(
                      icon: Icons.access_time,
                      label: 'Time',
                      value: DateTime.now().toLocal().toString().split(' ')[1].split('.')[0],
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchWeatherData,
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail({required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 16, fontFamily: 'Roboto'),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Roboto'),
        ),
      ],
    );
  }
}
