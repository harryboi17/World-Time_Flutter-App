import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../objects/clock_view.dart';
import '../models/menu_info.dart';
import '../services/world_time.dart';
class ClockPage extends StatefulWidget {
  const ClockPage({Key? key}) : super(key: key);

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  Map data = {};
  late Timer timer;
  @override
  void initState() {
    var menuInfo = Provider.of<MenuInfo>(context, listen : false);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      WorldTime instance = WorldTime(location: data['location'], flag: data['flag'], url: data['url']);
      await instance.getTime();
      data['time'] = instance.time;
      data['seconds'] = instance.seconds;
      data['now'] = instance.now;

      String img;
      if(data['isDayTime'] == 1) img = 'morning.jpg';
      else if(data['isDayTime'] == 2) img = 'afternoon.jpg';
      else if(data['isDayTime'] == 3) img = 'evening.jpg';
      else img = 'night.jpg';

      if(menuInfo.background != img) {
        menuInfo.updateBackground(img);
      }

      if(mounted) {
        setState((){});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;

    Color _color = data['isDayTime'] == 4 || data['isDayTime'] == 3 ? Colors.white : Colors.black;
    Color _color2 = data['isDayTime'] == 1 ? Colors.white : Colors.blue;
    Color _color3 = data['isDayTime'] == 3 ? Colors.white : Colors.black;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(18,64,0,0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Text('Clock', style: TextStyle(fontSize: 28, fontFamily: 'Gentium', color: Colors.white))
          ),
          Flexible(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['time'],
                  style: TextStyle(
                    fontFamily: 'Gentium',
                    fontSize: 60,
                    color: _color3,
                  ),
                ),
                Text(
                  DateFormat('EEE, d MMM').format(data['now']),
                  style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Gentium',
                      color : _color3,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
              flex : 14,
              fit: FlexFit.tight,
              child: Align(
                  alignment: Alignment.topCenter,
                  child: ClockView(now : data['now'], size: MediaQuery.of(context).size.height / 3.05)
              )
          ),
          Flexible(
            flex: 9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'TimeZone',
                  style: TextStyle(color: _color, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Gentium'),
                ),
                const SizedBox(width: 15,),
                TextButton.icon(
                  onPressed: (){
                    // var result = await Navigator.pushNamed(context, '/location');
                    // setState((){
                    //   data = result as Map;
                    // });
                    Navigator.pushReplacementNamed(context, '/location');
                  },
                  icon: const Icon(Icons.edit_location, color: Colors.black,),
                  label:  Text(
                    'Edit Location',
                    style: TextStyle(fontSize: 16, fontFamily: 'Gentium', color: _color2),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.language, color: Colors.white, size: 18,),
                    const SizedBox(width: 10,),
                    Text('UTC ${data['offset']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Gentium'))
                  ],
                ),
                const SizedBox(height: 6,),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 18,
                      child: Image(
                        image: AssetImage('assets/flag/${data['flag']}'),
                        fit: BoxFit.fill ,
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      data['location'].toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
