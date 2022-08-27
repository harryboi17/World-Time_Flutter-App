import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/activities/alarm_page.dart';
import 'package:world_time/activities/clock_page.dart';
import 'package:world_time/activities/stopwatch_page.dart';
import 'package:world_time/activities/timer_page.dart';
import 'package:world_time/objects/data.dart';
import 'package:world_time/objects/enum.dart';
import 'package:world_time/models/menu_info.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget? child){
        return Scaffold(
          // backgroundColor: const Color(0xFF444974),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgrounds/${value.background}'),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: menuItems.map((currentMenuInfo) => buildButton(currentMenuInfo)).toList(),
                ),
                const VerticalDivider(
                  color: Colors.white54,
                  width: 1,
                ),

                if(value.menuType == MenuType.clock) const ClockPage()
                else if(value.menuType == MenuType.alarm) const AlarmPage()
                else if(value.menuType == MenuType.stopwatch) CountUpTimerPage()
                else if(value.menuType == MenuType.timer) const TimerPage(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildButton(MenuInfo currentMenuInfo){
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget? child){
        return FlatButton(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          color: currentMenuInfo.menuType == value.menuType ? Colors.white54 : Colors.transparent,
          onPressed: (){
            var menuInfo = Provider.of<MenuInfo>(context, listen: false);
            menuInfo.updateMenu(currentMenuInfo);
          },
          child: Column(
            children: [
              Icon(IconData(currentMenuInfo.imageSource, fontFamily: 'MaterialIcons'), size: 50, color: Colors.black,),
              const SizedBox(height: 5),
              Text(currentMenuInfo.title, style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Maven', fontWeight: FontWeight.bold),)
            ],
          ),
        );
      },
    );
  }
}
