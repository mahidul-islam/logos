import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isOnLeft(double rotation) =>
      math.cos(rotation) > 0; //<---- check if angle is on the left

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final numberOfTexts = 20;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(
            numberOfTexts,
            (index) {
              return AnimatedBuilder(
                //<--- wrap everything in AnimatedBuilder
                animation: _animationController, //<--- pass the controller
                child:
                    LinearText(), //<--- set child for performance optimization
                builder: (context, child) {
                  final animationRotationValue = _animationController.value *
                      2 *
                      math.pi /
                      numberOfTexts; //<-- calculate animation rotation value
                  double rotation = 2 * math.pi * index / numberOfTexts +
                      math.pi / 2 +
                      animationRotationValue; //<-- add the animation value
                  if (isOnLeft(rotation)) {
                    rotation = -rotation +
                        2 * animationRotationValue - //<-- adjust the formula on the left side
                        math.pi * 2 / numberOfTexts;
                  }
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(rotation) //<----use the updated rotation
                      ..translate(-120.0),
                    child: LinearText(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class LinearText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
        child: Text(
          'PILLAR',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 110,
          ),
        ),
        foregroundDecoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.9),
              Colors.transparent
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.0, 0.2, 0.8],
          ),
        ),
      ),
    );
  }
}
