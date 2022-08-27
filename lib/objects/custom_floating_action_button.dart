import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatefulWidget{

  final Function actionButtonFunction;
  CustomFloatingActionButton({Key? key, required this.actionButtonFunction}) : super(key: key);

  @override
  State<CustomFloatingActionButton> createState() => _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton> with SingleTickerProviderStateMixin {
  var buttons = ['Hr', 'Min', 'Sec', 'add', 'Clear'];
  var colors = [Colors.redAccent, Colors.orangeAccent, Colors.yellowAccent, Colors.blueAccent, Colors.greenAccent];

  late AnimationController animationController;
  // late Animation degOneTranslationAnimation,degTwoTranslationAnimation,degThreeTranslationAnimation;
  late Animation rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this,duration: const Duration(milliseconds: 250), reverseDuration: const Duration(milliseconds: 350));

    // degOneTranslationAnimation = TweenSequence([
    //   TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.2), weight: 75.0),
    //   TweenSequenceItem<double>(tween: Tween<double>(begin: 1.2,end: 1.0), weight: 25.0),
    // ]).animate(animationController);
    // degTwoTranslationAnimation = TweenSequence([
    //   TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.4), weight: 55.0),
    //   TweenSequenceItem<double>(tween: Tween<double>(begin: 1.4,end: 1.0), weight: 45.0),
    // ]).animate(animationController);
    // degThreeTranslationAnimation = TweenSequence([
    //   TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.75), weight: 35.0),
    //   TweenSequenceItem<double>(tween: Tween<double>(begin: 1.75,end: 1.0), weight: 65.0),
    // ]).animate(animationController);

    rotationAnimation = Tween<double>(begin: 180.0,end: 0.0).animate(CurvedAnimation(parent: animationController
        , curve: Curves.easeOut));
    animationController.addListener((){
      setState(() {

      });
    });
    // animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // right: 100,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2.7,
            height: MediaQuery.of(context).size.height / 4.1,
            child: Stack(
              alignment: Alignment.centerRight,
              // children: buttons.map((e) => animateButton(buttons.indexOf(e))).toList(),
              children: buttons.asMap().entries.map((e) => animateButton(e.key)).toList(),
            ),
          ),
          Transform(
            transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
            alignment: Alignment.center,
            child: CircularButtonMain(
              color: Colors.white,
              width: 55,
              height: 45,
              icon: const Icon(Icons.menu, color: Colors.black, size: 25,),
              onClick: (){
                if (animationController.isCompleted) {
                  animationController.reverse();
                } else {
                  animationController.forward();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Transform animateButton(int index) {

    Animation degreeAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.2,end: 1.0), weight: 25.0),
    ]).animate(animationController);

    double deg = 180 + 30*((buttons.length%2 == 0 ? buttons.length/2 : (buttons.length-1)/2));
    return Transform.translate(
      offset: Offset.fromDirection(getRadiansFromDegree(deg - index*30), degreeAnimation.value*(95)),
      child: Transform(
        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degreeAnimation.value),
        alignment: Alignment.center,
        child: CircularButtonAction(
          color: colors[index],
          width: 55,
          height: 45,
          title: buttons[index],
          onClick: (){widget.actionButtonFunction(index);},
        ),
      ),
    );
  }
}

class CircularButtonMain extends StatelessWidget {

  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final Function onClick;

  CircularButtonMain({required this.color, required this.width, required this.height, required this.icon, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color,shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(icon: icon,enableFeedback: true, onPressed: (){onClick();}),
    );
  }
}
class CircularButtonAction extends StatelessWidget {

  final double width;
  final double height;
  final Color color;
  final String title;
  final Function onClick;

  CircularButtonAction({required this.color, required this.width, required this.height, required this.title, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color,shape: BoxShape.circle),
      width: width,
      height: height,
      child: TextButton(onPressed: (){onClick();}, child: Text(title, style: const TextStyle(color: Colors.black),),),
    );
  }
}

