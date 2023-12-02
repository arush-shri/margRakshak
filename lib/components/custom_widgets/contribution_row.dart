import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../presenter/ServerPresenter.dart';

class ContributionRow extends StatefulWidget {
  const ContributionRow({super.key, required this.screenWidth, required this.moving});
  final double screenWidth;
  final bool moving;

  @override
  State<ContributionRow> createState() => _ContributionRowState();
}

class _ContributionRowState extends State<ContributionRow> {

  final serverPresenter = ServerPresenter();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: widget.moving? 450.w : 400.w
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            rowItem("assets/images/accident_icon.png", "Accident\nProne", widget.screenWidth, () {
              serverPresenter.makeContribution("AccidentArea");
            }),
            rowItem("assets/images/rail_icon.png", "Railway\nCrossing", widget.screenWidth, () {
              serverPresenter.makeContribution("RailwayCross");
            }),
            rowItem("assets/images/forest_icon.png", "Forest\nArea", widget.screenWidth, () {
              serverPresenter.makeContribution("ForestArea");
            }),
            rowItem("assets/images/ghat_icon.png", "Ghat\nRoad", widget.screenWidth, () {
              serverPresenter.makeContribution("GhatRegion");
            }),
            rowItem("assets/images/other_icon.png", "Other\nRegion", widget.screenWidth, () {
              serverPresenter.makeContribution("OtherRegion");
            }),
          ],
        ),
      ),
    );
  }
}

Widget rowItem(String imagePath, String text, double screenWidth, VoidCallback callback){
  return GestureDetector(
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
    );
}