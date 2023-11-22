import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContributionRow extends StatelessWidget {
  const ContributionRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        rowItem("assets/images/accident_icon.png", "Accident\nProne", () { })
      ],
    );
  }
}

Widget rowItem(String imagePath, String text,VoidCallback callback){
  return GestureDetector(
    onTap: callback,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath),
        Text(text,
            style: TextStyle(fontSize: 18.sp, fontFamily: "Lexend", fontWeight: FontWeight.w400, color: Colors.black )
        )
      ],
    ),
  );
}