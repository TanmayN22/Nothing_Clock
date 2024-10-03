// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(ClockApp());
}

class ClockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ClockScreen(),
    );
  }
}

class ClockScreen extends StatefulWidget {
  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  int currentSecond = 0;
  int currentMinute = 0;
  int currentHour = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      final now = DateTime.now();
      setState(() {
        currentSecond = now.second;
        currentMinute = now.minute;
        currentHour = now.hour % 12; // 12-hour format
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Clock',
          style: GoogleFonts.getFont(
            'Poppins',
            textStyle: const TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        // ignore: sized_box_for_whitespace
        child: Container(
          width: 450,
          height: 300,
          child: CustomPaint(
            painter: ClockPainter(
              currentSecond: currentSecond,
              currentMinute: currentMinute,
              currentHour: currentHour,
            ),
          ),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final int currentSecond;
  final int currentMinute;
  final int currentHour;

  ClockPainter({
    required this.currentSecond,
    required this.currentMinute,
    required this.currentHour,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    const double circleRadius = 8; // Radius of the small circles

    Paint circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Paint secondPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    Paint minutePaint = Paint()
      ..color = Color.fromARGB(255, 75, 70, 70)
      ..style = PaintingStyle.fill;

    Paint hourPaint = Paint()
      ..color = const Color.fromARGB(255, 75, 70, 70)
      ..style = PaintingStyle.fill;

    // Draw 60 circles around the clock
    for (int i = 0; i < 60; i++) {
      double angle = (i * 6) * pi / 180;
      double x = center.dx + radius * 0.9 * cos(angle);
      double y = center.dy + radius * 0.9 * sin(angle);

      // Highlight the current second's circle in red, unless it coincides with minute or hour
      if (i == currentSecond && i != currentMinute && i != (currentHour * 5)) {
        canvas.drawCircle(Offset(x, y), circleRadius, secondPaint);
      }
      // Highlight the current minute's circle in black
      else if (i == currentMinute) {
        canvas.drawCircle(Offset(x, y), circleRadius, minutePaint);
      }
      // Highlight the current hour's circle in black (hour * 5 converts to clock position)
      else if (i == currentHour * 5) {
        canvas.drawCircle(Offset(x, y), circleRadius, hourPaint);
      } else {
        canvas.drawCircle(Offset(x, y), circleRadius, circlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) {
    return oldDelegate.currentSecond != this.currentSecond ||
        oldDelegate.currentMinute != this.currentMinute ||
        oldDelegate.currentHour != this.currentHour;
  }
}
