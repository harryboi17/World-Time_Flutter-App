import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:simple_timer/simple_timer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:world_time/main.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  int _secondValue = 0, _minuteValue = 0, _hourValue = 0;

  late AnimationController _controller;
  late AnimationController _animationControllerTimer;
  late Animation<Offset> animation1, animation2;
  late Animation<double> animation3;
  late Animation<Offset> animationTimer1, animationTimer2, animationTimer3;

  var isActive1 = true, isActive2 = false, isActive3 = false;
  var widgetState = true;

  late TimerController _timerController;

  @override
  void initState() {
    super.initState();

    _timerController = TimerController(this);

    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
        reverseDuration: const Duration(milliseconds: 230)
    );
    _animationControllerTimer = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 350)
    );

    animation1 = Tween<Offset>(begin: const Offset(0.7, 0), end: const Offset(0, 0)).animate(_controller);
    animation2 = Tween<Offset>(begin: const Offset(-0.7, 0), end: const Offset(0, 0)).animate(_controller);
    animation3 = Tween<double>(begin: 1.0, end: 1.05).animate(_controller)..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        if(isActive1) {
          _controller.reverseDuration = const Duration(milliseconds: 100);
          _controller.reverse();
          _controller.reverseDuration = const Duration(milliseconds: 250);
        }
      }
    });

    animationTimer1 = Tween<Offset>(begin: const Offset(0.0, 0.0), end: const Offset(0.38, -0.31)).animate(_animationControllerTimer);
    animationTimer2 = Tween<Offset>(begin: const Offset(0.0,0.0), end: const Offset(0.0, -0.31)).animate(_animationControllerTimer);
    animationTimer3 = Tween<Offset>(begin: const Offset(0.0,0.0), end: const Offset(-0.38, -0.31)).animate(_animationControllerTimer);

  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _animationControllerTimer.dispose();
    _timerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  'Timer',
                  style: TextStyle(
                    fontFamily: 'Gentium',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: widgetState ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 350),
                    child: Visibility(visible : widgetState, maintainState: true, child: timePicker(),),
                  ),
                  AnimatedOpacity(
                    opacity: !widgetState ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 350),
                    child: Visibility(visible : !widgetState, maintainState: true, child: myTimer(),),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Visibility(
                    visible: isActive1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        iconButton(Icons.play_arrow_rounded, 0, isActive1, animation3, 1),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isActive2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        iconButton(Icons.pause_rounded, 1, isActive2, animation1, 2),
                        iconButton(Icons.stop_rounded, 2, isActive2, animation2, 2)
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isActive3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        iconButton(Icons.play_arrow_rounded, 0, isActive3, animation1, 2),
                        iconButton(Icons.stop_rounded, 2, isActive3, animation2, 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myTimer(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height/3.6,
          width: MediaQuery.of(context).size.width/1.5,
          decoration: BoxDecoration(
            color: Colors.black87,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 8,
                // offset: const Offset(4, 4),
              ),
            ],
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 10,
            ),
          ),
          child: SimpleTimer(
            duration: Duration(hours: _hourValue, minutes: _minuteValue, seconds: _secondValue),
            progressTextFormatter: (value) => durationFormatter(value),
            controller: _timerController,
            progressTextStyle: const TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontFamily: 'Gentium'
            ),
            strokeWidth: 8,
            timerStyle: TimerStyle.ring,
            backgroundColor: Colors.black,
            onEnd: onCompleted,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AddTimer(time: 30, type: 'min', timerController: _timerController),
            AddTimer(time: 5, type: 'min', timerController: _timerController),
            AddTimer(time: 30, type: 'sec', timerController: _timerController),
            AddTimer(time: 5, type: 'sec', timerController: _timerController),
          ],
        ),
        const SizedBox(height: 0,),
      ],
    );
  }

  Row timePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildNumberPicker(_hourValue, 2, 23, animationTimer1),
        buildNumberPicker(_minuteValue, 1, 59, animationTimer2),
        buildNumberPicker(_secondValue, 0, 59, animationTimer3),
      ],
    );
  }

  AnimatedBuilder buildNumberPicker(timeValue, check, max, animation) {
    return AnimatedBuilder(
      animation: _animationControllerTimer.view,
      builder: (BuildContext context, Widget? child) {
        return SlideTransition(position: animation, child: child,);
      },
      child: NumberPicker(
        itemCount: 5,
        itemHeight: 60, itemWidth: 75,
        minValue: 0, maxValue: max,
        value: timeValue,
        onChanged: (value) => setState((){
          if(check == 0) {_secondValue = value;}
          else if(check == 1) {_minuteValue = value;}
          else if(check == 2) {_hourValue = value;}
          HapticFeedback.lightImpact();
        }),
        selectedTextStyle: const TextStyle(fontSize: 50, color: Colors.blue, fontFamily: 'Gentium'),
        textStyle: const TextStyle(fontSize: 40, color: Colors.black45, fontFamily: 'Gentium'),
        infiniteLoop: true,
        zeroPad: true,
        // decoration: BoxDecoration(
        //   borderRadius: const BorderRadius.all(Radius.circular(20)),
        //   color: Colors.transparent,
        //   border: Border.all(color: Colors.white),
        // ),
      ),
    );
  }

  AnimatedBuilder iconButton(buttonIcon, check, enabled, animation, type) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget? child) {
        if(type == 1){return Transform.scale(scale: animation.value, child: child,);}
        else {return SlideTransition(position: animation, child: child,);}
      },
      child: OutlinedButton(
        onPressed: () async {
          if(check == 0 && enabled){
            if(_hourValue == 0 && _minuteValue == 0 && _secondValue == 0){
              Fluttertoast.showToast(
                  msg: "Please select Time",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
              );
            }
            else {
              if (widgetState) {
                _timerController.duration = Duration(hours: _hourValue, minutes: _minuteValue, seconds: _secondValue);
                _animationControllerTimer.forward().whenComplete(() => setState(() {widgetState = !widgetState;}));
              }
              _timerController.start();
              setState(() {
                if (isActive1) {_controller.forward();}
                isActive1 = false; isActive2 = true; isActive3 = false;
              });
            }
          }
          else if(check == 1 && enabled){
            _timerController.stop();
            setState((){
              isActive1 = false; isActive2 = false; isActive3 = true;
            });
          }
          else if(check == 2 && enabled){
            Reset();
          }
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            )),
            backgroundColor: MaterialStateProperty.all<Color?>(Colors.black54)
        ),
        child: Icon(buttonIcon, color: Colors.blue, size: 56,),
      ),
    );
  }

  String durationFormatter(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void Reset(){
    setState((){
      widgetState = true;
      _animationControllerTimer.reverse();
      _timerController.reset();
      _controller.reverse().whenComplete(() =>
          setState((){
            isActive1 = true; isActive2 = false; isActive3 = false;
            _controller.duration = const Duration(milliseconds: 200);
            _controller.forward();
            _controller.duration = const Duration(milliseconds: 300);
          })
      );
    });
  }

  void onCompleted(){
    Reset();
    scheduleAlarm();
  }
  void scheduleAlarm() async {
    String display = "";
    if(_hourValue != 0){display += "$_hourValue ${_hourValue == 1 ? "hour" : "hours"}";}
    if(_minuteValue != 0){display += "$_minuteValue ${_minuteValue == 1 ? "minute" : "minutes"}";}
    if(_secondValue != 0){display += "$_secondValue ${_secondValue == 1 ? "second" : "seconds"}";}

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

    await flutterLocalNotificationsPlugin.show(1001, display, "Timer", platformChannelSpecifics, payload: "hii");
  }
}

class AddTimer extends StatelessWidget {

  final int time;
  final String type;

  const AddTimer({Key? key, required this.time, required this.type, required TimerController timerController})
      : _timerController = timerController, super(key: key);

  final TimerController _timerController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        children: [
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: (){
                if(type == 'min') {
                  _timerController.add(Duration(minutes: time), start: true);
                }
                else if(type == 'sec'){
                  _timerController.add(Duration(seconds: time), start: true);
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: 58,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  border: Border.all(color: Colors.black),
                ),
                child: Text('+$time', style: const TextStyle(fontFamily: 'Gentium', color: Colors.white, fontSize: 23),),
              ),
            ),
          ),
          Text(type, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}
