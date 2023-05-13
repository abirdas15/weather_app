import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/weather_model.dart';

class FutureForcastListItem extends StatelessWidget {
  final Forecastday? forecastday;
  const FutureForcastListItem({Key? key, this.forecastday}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      margin: EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: [
          Image.network("https:${forecastday?.day?.condition?.icon ?? ""}"),
          Expanded(
            child: Text(
              DateFormat.MMMEd().format(DateTime.parse(forecastday?.date.toString() ?? "")),
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
          Expanded(
            child: Text(
              forecastday?.day?.condition?.text.toString() ?? "",
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
          Expanded(
            child: Text(
              "^${forecastday?.day?.maxtempC?.round().toString()}/${forecastday?.day?.mintempC?.round().toString()}",
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        ],
      ),
    );
  }
}

