import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContributionRow extends StatefulWidget {
  const ContributionRow({super.key, required this.screenWidth});
  final double screenWidth;

  @override
  State<ContributionRow> createState() => _ContributionRowState();
}

class _ContributionRowState extends State<ContributionRow> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = widget.screenWidth;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        rowItem("assets/images/accident_icon.png", "Accident\nProne", screenWidth, () { }),
        rowItem("assets/images/turn_icon.png", "Blind\nTurn", screenWidth, () { }),
        rowItem("assets/images/forest_icon.png", "Forest\nArea", screenWidth, () { }),
        rowItem("assets/images/ghat_icon.png", "Ghat\nRegion", screenWidth, () { }),
      ],
    );
  }
}

Widget rowItem(String imagePath, String text, double screenWidth, VoidCallback callback){
  return Expanded(
    child: GestureDetector(
      onTap: callback,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 2.h,),
          SizedBox(
              width: screenWidth,
              child: Image.asset(imagePath, fit: BoxFit.fill,)
          ),
          Text(text,
            style: TextStyle(fontSize: screenWidth==0.w? 0.sp : 18.sp,
                fontFamily: "Lexend", fontWeight: FontWeight.w400, color: Colors.white ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ),
  );
}