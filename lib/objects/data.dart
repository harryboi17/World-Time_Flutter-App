import 'package:world_time/objects/enum.dart';
import 'package:world_time/objects/theme_data.dart';

import '../models/alarm_info.dart';
import '../models/menu_info.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.clock, title: 'Clock', imageSource: 0xe73b, background: 'afternoon.jpg'),
  MenuInfo(MenuType.alarm, title: 'Alarm', imageSource: 0xf517, background: ''),
  MenuInfo(MenuType.timer, title: 'Timer', imageSource: 0xf7fc, background: ' '),
  MenuInfo(MenuType.stopwatch, title: 'StopWatch', imageSource: 0xf44a, background: ' '),
];

// List<AlarmInfo> alarms = [
//   AlarmInfo(alarmDateTime: DateTime.now().add(Duration(hours: 1)), title: 'Office', isPending: 0, gradientColorIndex: 0),
//   AlarmInfo(alarmDateTime: DateTime.now().add(Duration(hours: 1)), title: 'Sport', isPending: 0, gradientColorIndex: 1),
// ];