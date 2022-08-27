import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:world_time/main.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:world_time/objects/theme_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/alarm_info.dart';
import '../services/alarm_helper.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  Map data = {};
  late tz.TZDateTime _alarmTime;
  late String _alarmTimeString;
  final AlarmHelper _alarmHelper = AlarmHelper.alarmHelper;
  Future<List<AlarmInfo>>? _alarms;
  List<AlarmInfo>? _currentAlarms;
  late tz.Location location;
  late TextEditingController controller;
  late String alarmTitle;
  bool _isRepeatSelected = false;

  @override
  void initState() {
    tz.initializeTimeZones();
    controller = TextEditingController();
    alarmTitle = 'Alarm';
    loadAlarms();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // tz.initializeTimeZones();
    data = data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;
    location = tz.getLocation(data['url']);
    tz.setLocalLocation(location);
    _alarmTime = tz.TZDateTime.now(tz.local);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                'Alarm',
                style: TextStyle(
                  fontFamily: 'Gentium',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),
            Expanded(
              flex: 14,
              child: FutureBuilder<List<AlarmInfo>>(
                future: _alarms,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    _currentAlarms = snapshot.data;
                    return ListView(
                        children: _currentAlarms!.map<Widget>((alarm) {
                          var alarmTime = DateFormat('hh:mm aa').format(alarm.alarmDateTime);
                          var gradientColor = GradientTemplate.gradientTemplate[alarm.gradientColorIndex].colors;
                          var alarmDate = DateFormat('EEE, MMM d').format(alarm.alarmDateTime);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradientColor,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(24)),
                                boxShadow: [
                                  BoxShadow(
                                    color: gradientColor.last.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: const Offset(4, 4),
                                  ),
                                ]
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.label, color: Colors.white, size: 24,),
                                        const SizedBox(width: 8,),
                                        Text(alarm.title, style: const TextStyle(color: Colors.white, fontFamily: 'Gentium'),)
                                      ],
                                    ),
                                    Switch(
                                      onChanged: (bool value) async{
                                        if(value){
                                          _alarmTime = tz.TZDateTime(location,
                                              alarm.alarmDateTime.year, alarm.alarmDateTime.month, alarm.alarmDateTime.day,
                                              alarm.alarmDateTime.hour, alarm.alarmDateTime.minute
                                          );
                                          tz.TZDateTime scheduleAlarmDateTime;
                                          if(_alarmTime.isAfter(tz.TZDateTime.now(tz.local))){
                                            scheduleAlarmDateTime = _alarmTime;
                                          }
                                          else{
                                            scheduleAlarmDateTime = _alarmTime.add(const Duration(days: 1));
                                          }
                                          scheduleAlarm(scheduleAlarmDateTime, alarm);
                                        }
                                        else{
                                          await flutterLocalNotificationsPlugin.cancel(alarm.id!);
                                        }
                                        setState((){
                                          alarm.isPending = alarm.isPending == 1 ? 0 : 1;
                                          _alarmHelper.updateAlarm(alarm.id!, alarm);
                                        });
                                      },
                                      value: alarm.isPending == 1 ? true : false,
                                      activeColor: Colors.white,
                                    ),
                                  ],
                                ),
                                FlatButton(
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  onPressed: () async {
                                    var newDate = await showDatePicker(
                                        context: context,
                                        initialDate: alarm.alarmDateTime,
                                        firstDate: alarm.alarmDateTime,
                                        lastDate: alarm.alarmDateTime.add(const Duration(days: 365))
                                    );
                                    if(newDate != null){
                                      alarm.alarmDateTime = DateTime(
                                        newDate.year, newDate.month, newDate.day,
                                        alarm.alarmDateTime.hour, alarm.alarmDateTime.minute
                                      );
                                      _alarmTime = tz.TZDateTime(location,
                                          newDate.year, newDate.month, newDate.day,
                                          alarm.alarmDateTime.hour, alarm.alarmDateTime.minute
                                      );
                                      updateAlarm(alarm);
                                    }
                                  },
                                  child: Text(
                                      alarmDate,
                                      style: const TextStyle(color: Colors.white, fontFamily: 'Gentium', fontSize: 16)
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        var oldTime = alarm.alarmDateTime;
                                        var newTime = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.fromDateTime(oldTime),
                                        );
                                        if(newTime != null){
                                          alarm.alarmDateTime = DateTime(
                                              oldTime.year, oldTime.month, oldTime.day,
                                              newTime.hour, newTime.minute
                                          );
                                          _alarmTime = tz.TZDateTime(location,
                                            oldTime.year, oldTime.month, oldTime.day,
                                            newTime.hour, newTime.minute
                                          );
                                          updateAlarm(alarm);
                                        }
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(5, 0, 0, 0)),
                                      ),
                                      child: Text(
                                        alarmTime,
                                        style: const TextStyle(color: Colors.white, fontFamily: 'Gentium', fontSize: 24, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 26),
                                      color: Colors.white,
                                      onPressed: () {
                                        deleteAlarm(alarm.id!, alarm);
                                      }
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).followedBy([
                          DottedBorder(
                            strokeWidth: 3,
                            color: const Color(0xFFEAECFF),
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(24),
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Color(0xFF444974),
                                  borderRadius: BorderRadius.all(Radius.circular(24))
                              ),
                              child: FlatButton(
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                onPressed: (){
                                  _alarmTimeString = DateFormat('hh:mm aa').format(tz.TZDateTime.now(tz.local));
                                  _isRepeatSelected = false;
                                  showModalBottomSheet(
                                      useRootNavigator: true,
                                      context: context,
                                      clipBehavior: Clip.antiAlias,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(24),
                                        ),
                                      ),

                                      builder: (context) {
                                        return StatefulBuilder(
                                            builder: (context, setModalState){
                                              return Container(
                                                padding: const EdgeInsets.all(32),
                                                child: Column(
                                                  children: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        var selectedTime = await showTimePicker(context: context
                                                            , initialTime: TimeOfDay.fromDateTime(tz.TZDateTime.now(tz.local)));
                                                        if(selectedTime != null){
                                                          final now = tz.TZDateTime.now(tz.local);
                                                          var selectedDateTime = tz.TZDateTime(
                                                            now.location, now.year, now.month, now.day,
                                                            selectedTime.hour, selectedTime.minute,
                                                          );
                                                          _alarmTime = selectedDateTime;
                                                          setModalState(() {
                                                            _alarmTimeString = DateFormat('hh:mm aa').format(selectedDateTime);
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 205,
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey[200],
                                                            borderRadius: const BorderRadius.all(Radius.circular(16)),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Icon(Icons.watch_later_outlined, size: 30, color: Colors.lightBlue,),
                                                            Text(
                                                              _alarmTimeString,
                                                              style: const TextStyle(fontSize: 30, color: Colors.black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 30,),
                                                    ListTile(
                                                      title: const Text('Repeat'),
                                                      trailing: Switch(
                                                        onChanged: (value) {
                                                          setModalState(() {
                                                            _isRepeatSelected = value;
                                                          });
                                                        },
                                                        value: _isRepeatSelected,
                                                      ),
                                                    ),
                                                    const ListTile(
                                                      title: Text('Sound'),
                                                      trailing: Icon(
                                                          Icons.arrow_forward_ios),
                                                    ),
                                                    ListTile(
                                                      title: const Text('Title'),
                                                      trailing: const Icon(Icons.arrow_forward_ios),
                                                      onTap: () async {
                                                        var title = await showDialog(
                                                            context: context,
                                                            builder: (context) => AlertDialog(
                                                              title: const Text('Alarm Title'),
                                                              content: TextField(
                                                                autofocus: true,
                                                                decoration: const InputDecoration(hintText: 'Enter the Title'),
                                                                controller: controller,
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop(controller.text);
                                                                    },
                                                                    child: const Text("SUBMIT")
                                                                )
                                                              ],
                                                            )
                                                        );
                                                        // controller.clear()
                                                        if(title != null){
                                                          alarmTitle = title;
                                                        }
                                                      },
                                                    ),
                                                    const SizedBox(height: 30,),
                                                    FloatingActionButton.extended(
                                                      onPressed: () {
                                                        onSaveAlarm();
                                                      },
                                                      label: const Text('Save'),
                                                      icon: const Icon(Icons.alarm),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }
                                        );
                                      }
                                  );
                                },
                                child: Column(
                                  children: const [
                                    Icon(Icons.add_alarm, size: 40, color: Colors.lightBlue,),
                                    SizedBox(height: 8,),
                                    Text(
                                      'Add Alarm',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontFamily: 'Gentium'
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]).toList()
                    );
                  }
                  return const Center(child: SpinKitFoldingCube(color: Colors.blue, size: 100,));
                },

              ),
            ),
          ],
        ),
      ),
    );
  }

  void scheduleAlarm(tz.TZDateTime scheduleNotificationDateTime, AlarmInfo alarmInfo) async {
    // var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 10));
    var androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('alarm_notif', 'Channel for Alarm notification',
          icon: 'clock_icon',
          // sound: RawResourceAndroidNotificationSound('a_long_cold_string'),
          largeIcon: DrawableResourceAndroidBitmap('clock_icon'),
          importance: Importance.max,
          priority: Priority.max,
          ticker: 'ticker',
        );

    var iosPlatformChannelSpecifics = const IOSNotificationDetails(
      // sound: 'a_long_cold_string.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iosPlatformChannelSpecifics,
    );

    if(alarmInfo.isRepeat == 1){
      await flutterLocalNotificationsPlugin.zonedSchedule(alarmInfo.id!, alarmInfo.title, 'Repeated',
        scheduleNotificationDateTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,);
    }
    else {
      await flutterLocalNotificationsPlugin.zonedSchedule(alarmInfo.id!, alarmInfo.title, 'Office',
        scheduleNotificationDateTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
            .absoluteTime,);
    }
  }

  void onSaveAlarm() async {
    tz.TZDateTime scheduleAlarmDateTime;
    scheduleAlarmDateTime = _alarmTime;

    // print(scheduleAlarmDateTime.timeZoneOffset);
    int? id = await _alarmHelper.getId();
    var alarmInfo = AlarmInfo(
        id: id,
        title: alarmTitle,
        alarmDateTime: scheduleAlarmDateTime.add(scheduleAlarmDateTime.timeZoneOffset),
        isPending: 1,
        isRepeat: _isRepeatSelected ? 1 : 0,
        gradientColorIndex: (_currentAlarms!.length)%5,
        // location: location
    );

    await _alarmHelper.insertAlarm(alarmInfo);

    scheduleAlarm(scheduleAlarmDateTime, alarmInfo);
    loadAlarms();
    Navigator.pop(context);
  }

  void deleteAlarm(int id, AlarmInfo alarmInfo) async{
    await _alarmHelper.delete(id);
    //unsubscribe for notification
    await flutterLocalNotificationsPlugin.cancel(alarmInfo.id!);
    loadAlarms();
  }

  void updateAlarm(AlarmInfo alarmInfo){
    _alarmHelper.updateAlarm(alarmInfo.id!, alarmInfo);
    scheduleAlarm(_alarmTime, alarmInfo);
    loadAlarms();
  }
}
