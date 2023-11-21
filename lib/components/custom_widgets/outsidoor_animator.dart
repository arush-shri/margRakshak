import 'package:flutter/material.dart';
import 'dart:math' show pi;

import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutdoorAnimation extends StatefulWidget {
  final String condition;
  const OutdoorAnimation({super.key, required this.condition});

  @override
  State<OutdoorAnimation> createState() => _OutdoorAnimationState();
}

class _OutdoorAnimationState extends State<OutdoorAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
        "assets/gifs/rain_anim.gif",
      fit: BoxFit.fill,
      );
  }
}


