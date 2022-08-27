import 'dart:math';

import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  DateTime now;
  final double size;
  ClockView({required this.now, required this.size});

  @override
  State<ClockView> createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color(0xFF2D2F41),
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: ClockPainter(widget.now),
      ),
    );
  }
}

class ClockPainter extends CustomPainter{
  DateTime now;
  ClockPainter(this.now);

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width/2;
    var centerY = size.height/2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var fillBrush = Paint()
      ..color = const Color(0xFFFFFF);
      // ..color = const Color(0xFF444974);

    var outlineBrush = Paint()
      ..color = const Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    var centerFillBrush = Paint()
      ..color = const Color(0xFFEAECFF);

    var secHandBrush = Paint()
      ..shader  = const RadialGradient(colors: [Colors.orangeAccent, Colors.yellowAccent])
          .createShader(Rect.fromCircle(center: center, radius : radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7;

    var minHandBrush = Paint()
      ..shader  = const RadialGradient(colors: [Colors.deepPurpleAccent, Colors.pink])
          .createShader(Rect.fromCircle(center: center, radius : radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 9;

    var hourHandBrush = Paint()
      ..shader  = const RadialGradient(colors: [Colors.pinkAccent, Colors.orangeAccent])
          .createShader(Rect.fromCircle(center: center, radius : radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;

    var dashBrush = Paint()
    ..color = Colors.black
    ..strokeWidth = 3;

    canvas.drawCircle(center, radius - 40, fillBrush);
    canvas.drawCircle(center, radius - 40, outlineBrush);

    var secHandY = centerX - 85 * cos(now.second * 6 * pi / 180);
    var secHandX = centerY + 85 * sin(now.second * 6 * pi / 180);
    var minHandY = centerX - 70 * cos(now.minute * 6 * pi / 180);
    var minHandX = centerY + 70 * sin(now.minute * 6 * pi / 180);
    var hourHandY = centerX - 50 * cos(now.hour * 30 * pi / 180);
    var hourHandX = centerY + 50 * sin(now.hour * 30 * pi / 180);

    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    canvas.drawCircle(center, 16, centerFillBrush);

    for(double i = 0; i < 360; i+= 12){
      var x1 = centerX + (radius-10) * cos(i * pi / 180);
      var y1 = centerY + (radius-10) * sin(i * pi / 180);

      var x2 = centerX + (radius-25) * cos(i * pi / 180);
      var y2 = centerY + (radius-25) * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
