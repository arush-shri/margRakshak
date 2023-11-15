import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marg_rakshak/view/custom_bottom_row.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final TextEditingController _searchText = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(450, 800),
      builder: (context, child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                SizedBox(
                  width: 450.w,
                  height: 800.h,
                  child: Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: _onMapCreated,
                        scrollGesturesEnabled: true,
                        zoomControlsEnabled: false,
                        mapType: MapType.satellite,
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(37.43296265331129, -122.08832357078792),
                          zoom: 11.0,
                        ),
                      ),
                      Positioned(
                          top: 70.h,
                          left: 35.w,
                          child: Container(
                            height: 45.h,
                            width: 380.w,
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.all(Radius.circular(400.w))
                            ),
                            child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.search_rounded, size: 35.h,),
                                      Expanded(child:
                                          TextField(
                                            controller: _searchText,
                                            cursorColor: Colors.deepPurpleAccent,
                                            decoration: InputDecoration(
                                              hintText: 'Search',
                                              fillColor: Colors.transparent,
                                              filled: true,
                                              hintStyle: TextStyle(fontSize: 16.sp, fontFamily: GoogleFonts.poppins().fontFamily,
                                                  color: Colors.black),
                                              isDense: true,
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                            style: const TextStyle(color: Colors.black),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                          )
                      ),
                      Positioned(
                          top: 710.h,
                          left: 10.w,
                          child: Container(
                            width: 430.w,
                            height: 65.h,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.82),
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                            ),
                            child: const BottomHomeRow(),
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
