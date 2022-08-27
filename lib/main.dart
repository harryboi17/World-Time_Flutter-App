import 'package:flutter/material.dart';
import 'package:world_time/services/alarm_helper.dart';
import 'package:world_time/services/myprovider.dart';
import 'package:world_time/pages/home.dart';
import 'package:world_time/pages/loading.dart';
import 'package:world_time/pages/choose_location.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid = const AndroidInitializationSettings('clock_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {});

  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  onSelectNotification: (String? payload) async {
    if(payload != null){
      debugPrint('notification payload: $payload');
    }
  });

  AlarmHelper.alarmHelper.initializeDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/' : (context) => const Loading(),
        '/provider' : (context) => const ProviderClass(),
        '/home' : (context) => const Home(),
        '/location' : (context) => const ChooseLocation(),
      },
    );
  }
}


