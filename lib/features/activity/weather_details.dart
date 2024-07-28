import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class WeatherDetails extends StatefulWidget {
  const WeatherDetails({super.key});

  @override
  _WeatherDetails createState() => _WeatherDetails();
}

class _WeatherDetails extends State<WeatherDetails> {
  final WeatherFactory _weatherFactory = WeatherFactory('1bcd343289225bb5168ea7cb19e732a2');

  final countryController = TextEditingController();

  Weather? _weather;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _weatherFactory.currentWeatherByCityName("Singapore").then((weather) {
      setState(() {
        _weather = weather;
      });
    });
  }

  updateWeather() {
    setState(() {
      _weatherFactory.currentWeatherByCityName(countryController.text).then((weather) {
        setState(() {
          _weather = weather;
        });
      });
    });
  }

  Widget _textBoxUI() {
    return Column(children: [
      TextField(
        controller: countryController,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.blue)),
            hintText: 'Country',
            hintStyle: const TextStyle(color: Colors.blueGrey),
            ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: ElevatedButton(
          onPressed: updateWeather,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6), // <-- Radius
              ),
              minimumSize: const Size(double.infinity, 40)),
          child: const Text(
              style: TextStyle(color: Colors.white), 'Search'),
        ),
      ),

    ]);
  }

  Widget _weatherUI() {
    if (_weather != null) {
      DateTime now = _weather!.date!;
      return Padding(
        padding: const EdgeInsets.only(top: 50),
        child: SizedBox(
          child: Column(
            children: <Widget>[
              //location
              Text(
                _weather?.areaName ?? "",
                style: TextStyle(fontSize: 32),
              ),

              Text(
                DateFormat("h:mm a").format(now) + ' ${_weather?.date?.timeZoneName}',
                style: TextStyle(fontSize: 20),
              ),
              Image(
                  image: NetworkImage(
                      "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png")),

              Text(
                "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
                style: TextStyle(fontSize: 64),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  'Feels like: ${_weather?.tempFeelsLike?.celsius?.toStringAsFixed(0)}°C',
                  style: TextStyle(fontSize: 20),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  _weather?.weatherDescription ?? "",
                  style: TextStyle(fontSize: 20),
                ),
              ),

              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          'Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}°C'),
                      const Text(' | '),
                      Text(
                          'Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°C'),
                    ],
                  )),
            ],
          ),
        ),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 40.0,
        vertical: 20.0,
      ),
      child: Column(
        children: <Widget>[_textBoxUI(),
          _weatherUI()],
      ),
    ));
  }
}
