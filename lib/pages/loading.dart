import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void setupWorldTime() async{
    WorldTime instance = WorldTime(location: 'India', flag: 'india.png', url: 'Asia/Kolkata');
    await instance.getTime();

    await Future.delayed(const Duration(milliseconds: 1500));
    Navigator.pushReplacementNamed(context, '/provider', arguments : {
      'time' : instance.time,
      'seconds' : instance.seconds,
      'location' : instance.location,
      'flag' : instance.flag,
      'isDayTime' : instance.isDayTime,
      'url' : instance.url,
      'offset' : instance.offset,
      'now' : instance.now
    });
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SpinKitFoldingCube(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}
/*
Explaining async behaviour or getData()
    // stimulate network request for a username
    //await waits further block of code until this is done
    String username = await Future.delayed(const Duration(seconds : 3), (){
      return 'Harshit';
    });

    // stimulate network request for bio
    String bio = await Future.delayed(const Duration(seconds : 2), (){
      return 'Computer Science';
    });

    print("$username - $bio");
 */
