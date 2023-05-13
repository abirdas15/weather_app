import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/service/api_service.dart';
import 'package:weather_app/ui/components/todays_weather.dart';

import 'components/future_forcat_list_item.dart';
import 'components/hourly_weather_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ApiService apiService = ApiService();
  final _textFieldController = TextEditingController();
  String queryText = "auto:ip";

  _showTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Search Location'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "search by city,zip"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    if (_textFieldController.text.isEmpty) {
                      return;
                    }
                    Navigator.pop(context, _textFieldController.text);
                  }),
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [
          IconButton(
          onPressed: () async {
            _textFieldController.clear();
            String text = await _showTextInputDialog(context);
            setState(() {
              queryText = text;
            });
            }, icon: Icon(Icons.search)),
          IconButton(onPressed: (){
            queryText = "auto:ip";
            setState(() {

            });
          }, icon: Icon(Icons.my_location))
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              WeatherModel? weatherModel = snapshot.data;
              return SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    TodaysWeather(
                        weatherModel: weatherModel
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Weather by Hours",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(itemBuilder: (context, index) {
                        Hour? hour = weatherModel?.forecast?.forecastday?[0].hour?[index];
                        return HourlyWeatherListItem(hour: hour);
                      },
                      itemCount: weatherModel?.forecast?.forecastday?[0].hour?.length,
                      scrollDirection: Axis.horizontal,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Next Days Weather",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          Forecastday? forcastday = weatherModel?.forecast?.forecastday?[index];
                          return FutureForcastListItem(
                            forecastday: forcastday,
                          );
                        },
                        itemCount: weatherModel?.forecast?.forecastday?.length,
                      ),
                    )
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error has occured'),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          future: apiService.getWeatherData(queryText),
        ),
      ),
    );
  }
}
