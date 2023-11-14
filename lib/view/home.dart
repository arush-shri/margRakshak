import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(450, 800),
      builder: (context, child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 450.w,
                    height: 735.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.w),
                          bottomRight: Radius.circular(30.w)),
                    ),
                    child: Stack(
                      children: [
                        Positioned(child: Row(

                        ))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 450.w,
                    height: 65.h,
                    child: Stack(
                      children: [
                        Positioned(child: Row(

                        ))
                      ],
                    ),
                  )
                ],
              )
            ),
          ),
        );
      },
    );
  }
}
