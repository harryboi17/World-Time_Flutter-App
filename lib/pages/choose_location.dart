import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';


class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key? key}) : super(key: key);

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {

  List<WorldTime> locations = [
    WorldTime(location: 'London', flag: 'uk.png', url: 'Europe/London'),
    WorldTime(location: 'Cairo', flag: 'egypt.png', url: 'Africa/Cairo'),
    WorldTime(location: 'Chicago', flag: 'usa.png', url: 'America/Chicago'),
    WorldTime(location: 'Seoul', flag: 'south_korea.png', url: 'Asia/Seoul'),
    WorldTime(location: 'India', flag: 'india.png', url: 'Asia/Kolkata'),
  ];

  void sendData(index) async{
    await locations[index].getTime();
    // Navigator.pop(context, {})
    Navigator.pushReplacementNamed(context, '/provider', arguments : {
      'time' : locations[index].time,
      'seconds' : locations[index].seconds,
      'location' : locations[index].location,
      'flag' : locations[index].flag,
      'isDayTime' : locations[index].isDayTime,
      'url' : locations[index].url,
      'offset' : locations[index].offset,
      'now' : locations[index].now,
    });
  }

  Future<bool> getLocations() async{
    Response response = await get(Uri.parse('https://worldtimeapi.org/api/timezone'));
    List<dynamic> data = jsonDecode(response.body);

    for(int i = 0; i < data.length; i++){
        String s = data[i].toString();
        String location = "", region = "";
        int j = 0;
        while(j < s.length && s[j] != '/') region += s[j++];
        j++;
        while(j < s.length) location += s[j++];

        if(region == 'Europe'){
          locations.add(WorldTime(location: location, flag: 'europe.png', url: s));
        }
        else if(region == 'America'){
          locations.add(WorldTime(location: location, flag: 'usa.png', url: s));
        }
        else if(region == 'Antarctica'){
          locations.add(WorldTime(location: location, flag: 'antarctica.png', url: s));
        }
        else if(region == 'Australia'){
          locations.add(WorldTime(location: location, flag: 'australia.webp', url: s));
        }
        else if(region == 'Africa'){
          locations.add(WorldTime(location: location, flag: 'africa.png', url: s));
        }
        else{
          locations.add(WorldTime(location: location.isEmpty ? region : location, flag: 'world.png', url: s));
        }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getLocations(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SpinKitPulse(color: Colors.white70),
            );
          }
          else {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blue[900],
                  title: const Text('Choose a Location'),
                  centerTitle: true,
                  elevation: 0,
                ),
                backgroundColor: Colors.grey[200],
                body: ListView.builder(
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              sendData(index);
                            },
                            title: Text(
                              locations[index].location,
                            ),
                            leading: CircleAvatar(
                              backgroundImage: AssetImage('assets/flag/${locations[index].flag}'),
                            ),
                          ),
                        ),
                      );
                    }
                )
            );
          }
        }
    );
  }
}
