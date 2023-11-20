import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _issueText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(450, 800),
      builder: (context, child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
                width: 450.w,
                height: 800.h,
                color: const Color(0xFF00233F),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 110.h, left: 30.w, bottom: 40.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.report_problem_outlined, size: 120.w,
                              color: Colors.yellow,),
                            SizedBox(width: 20.w,),
                            Text("Report",
                                style: TextStyle(fontSize: 48.sp, fontFamily: "Lexend",
                                    fontWeight: FontWeight.w500, color: Colors.white)
                            )
                          ],
                        )
                      ,),
                    Text("Facing issues with the app?\nInform us to be a rakshak",
                        style: TextStyle(fontSize: 24.sp, fontFamily: "Lexend",
                            fontWeight: FontWeight.w400, color: Colors.grey), textAlign: TextAlign.center,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
                      child: TextFormField(
                        controller: _issueText,
                        maxLines: 7,
                        style: TextStyle(fontSize: 22.sp, fontFamily: "Lexend",
                            fontWeight: FontWeight.w400, color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.w),
                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurpleAccent)),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurpleAccent)),
                          hintText: "Describe Problem",
                          hintStyle: TextStyle(fontSize: 18.sp, fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: ()=>{},
                        style: ButtonStyle(
                            fixedSize: MaterialStatePropertyAll(Size(200.w, 40.h))
                        ),
                        child: Text("REPORT",
                          style: TextStyle(fontSize: 20.sp, fontFamily: "Lexend",
                              fontWeight: FontWeight.w700, color: Colors.white),)
                    )
                  ],
                ),
              ),
          ),
        );
      },
    );
  }
}
