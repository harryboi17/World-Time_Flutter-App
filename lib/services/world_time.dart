import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime{
  String location;
  String url;
  String flag;
  late String time;
  late String seconds;
  late String offset;
  late DateTime now;
  late int isDayTime;

  WorldTime({required this.location, required this.flag, required this.url});

  Future<bool> getTime() async{
    try{
      Response response = await get(Uri.parse('https://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(response.body);

      String datetime = data['datetime'];
      offset = data['utc_offset'];
      int hours = int.parse(offset.substring(1, 3));
      int minutes = int.parse(offset.substring(4,6));

      now = DateTime.parse(datetime);
      if(offset[0] == '+') {
        now = now.add(Duration(hours: hours, minutes: minutes));
      } else {
        now = now.subtract(Duration(hours: hours, minutes: minutes));
      }

      time = DateFormat.jm().format(now);
      seconds = DateFormat.s().format(now);

      if(now.hour >= 6 && now.hour <12) isDayTime = 1;
      else if(now.hour >= 12 && now.hour < 18) isDayTime = 2;
      else if(now.hour >= 18 && now.hour < 20) isDayTime = 3;
      else isDayTime = 4;
    }
    catch(e){
      print('caught error: $e');
      time = 'could not get time data';
      offset = 'null';
    }
    return true;
  }
}

