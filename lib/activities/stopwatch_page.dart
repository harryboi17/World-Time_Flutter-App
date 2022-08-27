import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

import '../objects/custom_floating_action_button.dart';

class CountUpTimerPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => CountUpTimerPage(),
      ),
    );
  }
  @override
  _State createState() => _State();
}

class _State extends State<CountUpTimerPage> with SingleTickerProviderStateMixin {

  final StopWatchTimer stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    // onChange: (value) => print('onChange $value'),
    // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    // onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
    // onStop: () {
    //   print('onStop');
    // },
    // onEnded: () {
    //   print('onEnded');
    // },
  );

  var buttons = ['Hours', 'Minutes', 'Seconds', 'Time', 'Clear'];
  var isActive1 = true, isActive2 = false, isActive3 = false;
  final _scrollController = ScrollController();

  late AnimationController _controller;
  late Animation<Offset> animation1, animation2;
  late Animation<double> animation3;

  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // _stopWatchTimer.rawTime.listen((value) => print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    // _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    // _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    // _stopWatchTimer.records.listen((value) => print('records $value'));
    // _stopWatchTimer.fetchStop.listen((value) => print('stop from stream'));
    // _stopWatchTimer.fetchEnded.listen((value) => print('ended from stream'));

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 230)
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
  }

  @override
  void dispose() async {
    super.dispose();
    await stopWatchTimer.dispose();
    _controller.dispose();
  }

  void actionButtonFunction(int check){
    setState(() {
      if(check == 0){stopWatchTimer.setPresetHoursTime(1);}
      else if(check == 1){stopWatchTimer.setPresetMinuteTime(1);}
      else if(check == 2){stopWatchTimer.setPresetSecondTime(1);}
      else if(check == 3){stopWatchTimer.setPresetTime(mSec: 3599 * 1000);}
      else if(check == 4){stopWatchTimer.clearPresetTime();}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  'StopWatch',
                  style: TextStyle(
                    fontFamily: 'Gentium',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 18,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /// Display stop watch time
                  Flexible(
                    flex: 1,
                    child: StreamBuilder<int>(
                      stream: stopWatchTimer.rawTime,
                      initialData: stopWatchTimer.rawTime.value,
                      builder: (context, snap) {
                        final value = snap.data!;
                        final displayTime =
                        StopWatchTimer.getDisplayTime(value, hours: true, milliSecond: false);
                        final displayMillTime =
                        StopWatchTimer.getDisplayTime(value, hours: true, minute: false, second: false);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              displayTime,
                              style: const TextStyle(
                                fontSize: 60,
                                fontFamily: 'Gentium',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 13),
                              child: Text(
                                displayMillTime.substring(2),
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Gentium',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20,),
                  // Lap time.
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: SizedBox(
                        height: 200,
                        child: StreamBuilder<List<StopWatchRecord>>(
                          stream: stopWatchTimer.records,
                          initialData: stopWatchTimer.records.value,
                          builder: (context, snap) {
                            final value = snap.data!;
                            if (value.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            Future.delayed(const Duration(milliseconds: 100), () {
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOut);
                            });
                            print('Listen records. $value');
                            return ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                final data = value[index];
                                final diff = index == 0? value[index].rawValue! : value[index].rawValue! - value[index-1].rawValue!;
                                var d = int.parse(diff.toString());
                                var e = '+${((d/(1000*60*60))%24).toInt()}:${((d/(1000*60))%60).toInt()}:${((d/1000)%60).toInt()}:${(d%1000)~/10}';
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${index + 1}.  ${data.displayTime}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Gentium',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            e,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Helvetica',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 1, color: Colors.black,)
                                  ],
                                );
                              },
                              itemCount: value.length,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  //Misc
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Divider(color: Colors.black, thickness: 1.2, indent: 15, endIndent: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildStreamBuilder('min', stopWatchTimer.minuteTime),
                                buildStreamBuilder('sec', stopWatchTimer.secondTime),
                                buildStreamBuilder('msec', stopWatchTimer.rawTime),
                              ],
                            ),
                            // PopupMenuButton(
                            //     icon: const Icon(Icons.add_box, color: Colors.white,),
                            //     iconSize: 45,
                            //     color: Colors.transparent,
                            //     elevation: 20,
                            //     shape: const OutlineInputBorder(
                            //         borderSide: BorderSide(
                            //             color: Colors.grey,
                            //             width: 2
                            //         )
                            //     ),
                            //     itemBuilder: (context){
                            //       return [
                            //         PopupMenuItem(child: setButton(buttons[0], 0)),
                            //         PopupMenuItem(child: setButton(buttons[1], 1)),
                            //         PopupMenuItem(child: setButton(buttons[2], 2)),
                            //         PopupMenuItem(child: setButton(buttons[3], 3)),
                            //         PopupMenuItem(child: setButton(buttons[4], 4)),
                            //       ];
                            //     }
                            // ),
                            CustomFloatingActionButton(actionButtonFunction: actionButtonFunction,),
                            // FloatingActionButton(
                            //   onPressed: () {
                            //     if (fabKey.currentState!.isOpen) {
                            //       fabKey.currentState!.close();
                            //     } else {
                            //       fabKey.currentState!.open();
                            //     }
                            //   },
                            //   child: FabCircularMenu(
                            //     ringColor: Colors.transparent,
                            //     alignment: Alignment.centerRight,
                            //     animationDuration: Duration(milliseconds: 500),
                            //     ringDiameter: 370,
                            //     fabMargin: const EdgeInsets.all(2),
                            //     key: fabKey,
                            //     fabSize: 300,
                            //     children: [
                            //       setButton(buttons[4], 4),
                            //       setButton(buttons[3], 3),
                            //       setButton(buttons[2], 2),
                            //       setButton(buttons[1], 1),
                            //       setButton(buttons[0], 0),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 0,),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  //Buttons
                  Stack(
                    // alignment: Alignment(100, 100),
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
                            iconButton(Icons.flag_rounded, 3, isActive2, animation2, 2)
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
                ],
              ),
            ),
          ],
        ),
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
            stopWatchTimer.onExecute.add(StopWatchExecute.start);
            setState((){
              if(isActive1) {_controller.forward();}
              isActive1 = false; isActive2 = true; isActive3 = false;
            });
          }
          else if(check == 1 && enabled){
            stopWatchTimer.onExecute.add(StopWatchExecute.stop);
            setState((){
              isActive1 = false; isActive2 = false; isActive3 = true;
            });
          }
          else if(check == 2 && enabled){
            stopWatchTimer.onExecute.add(StopWatchExecute.reset);
            _controller.reverse().whenComplete(() =>
                setState((){
                  isActive1 = true; isActive2 = false; isActive3 = false;
                  _controller.duration = const Duration(milliseconds: 200);
                  _controller.forward();
                  _controller.duration = const Duration(milliseconds: 300);
                })
            );
          }
          else if(check == 3 && enabled){stopWatchTimer.onExecute.add(StopWatchExecute.lap);}
          },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            // side: BorderSide(color: Colors.green),
          )),
          backgroundColor: MaterialStateProperty.all<Color?>(Colors.black54)
        ),
        child: Icon(buttonIcon, color: Colors.blue, size: 56,),
      ),
    );
  }

  Padding setButton(title, check) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.pinkAccent,
          onPrimary: Colors.white,
          shape: const StadiumBorder(),
        ),
        onPressed: () async{
          if(check == 0){stopWatchTimer.setPresetHoursTime(1);}
          else if(check == 1){stopWatchTimer.setPresetMinuteTime(1);}
          else if(check == 2){stopWatchTimer.setPresetSecondTime(1);}
          else if(check == 3){stopWatchTimer.setPresetTime(mSec: 3599 * 1000);}
          else if(check == 4){stopWatchTimer.clearPresetTime();}
        },
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  StreamBuilder<int> buildStreamBuilder(title, myStream) {
    return StreamBuilder<int>(
      stream: myStream,
      initialData: myStream.value,
      builder: (context, snap) {
        final value = snap.data;
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                '$title :',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Gentium',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                value.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: (value! >= 1e8  ? 16 : 20),
                    fontFamily: 'Gentium',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
        },
    );
  }
}