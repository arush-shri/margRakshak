import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marg_rakshak/view/report_screen.dart';
import 'package:marg_rakshak/view/road_side_help.dart';

class BottomHomeRow extends StatefulWidget {
  final VoidCallback toggleContribute;
  const BottomHomeRow({super.key, required this.toggleContribute});

  @override
  State<BottomHomeRow> createState() => _BottomHomeRowState();
}

class _BottomHomeRowState extends State<BottomHomeRow> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.25).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback callback = widget.toggleContribute;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        rowItem(Icons.location_on_outlined, "Explore", const Color(0xFF5C4033), ()=>{}),
        rowItem(Icons.car_crash_outlined, "Assist", const Color(0xFF5C40F3), ()=>Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RoadSideHelpScreen()))),
        contributeRowItem(callback),
        rowItem(Icons.warning_amber, "Report", const Color(0xFFECB100), ()=>Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ReportScreen()))
        ),
      ],
    );
  }

  Widget contributeRowItem(VoidCallback callback) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        callback();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
              AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14,
                    child: Icon(
                      Icons.add_circle_outline_sharp,
                      color: const Color(0xFFA41ADC),
                      size: 37.w,
                    ),
                  );
              },
            ),
          Text(
            "Contribute",
            style: TextStyle(
                fontSize: 18.sp,
                fontFamily: "Lexend",
                fontWeight: FontWeight.w400,
                color: Colors.black),
          ),
        ],
      ),
    );
  }
}

Widget rowItem(IconData icon, String text, Color color,VoidCallback callback){
  return GestureDetector(
    onTap: callback,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,color: color,
            size: 37.w,),
          Text(text,
              style: TextStyle(fontSize: 18.sp, fontFamily: "Lexend", fontWeight: FontWeight.w400, color: Colors.black )
          )
        ],
      ),
  );
}