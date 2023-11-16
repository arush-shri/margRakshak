import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marg_rakshak/view/custom_bottom_row.dart';
import 'package:marg_rakshak/view/search_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  bool _showSearchScreen = false;

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
                          zoom: 15.0,
                        ),
                      ),
                      AnimatedPositioned(
                          top:  _showSearchScreen? 0.h : 70.h,
                          left: _showSearchScreen? 0.h : 35.w,
                          right: _showSearchScreen? 0.h : 35.w,
                          duration: const Duration(milliseconds: 200),
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                _showSearchScreen = true;
                              });
                            },
                            child: SearchScreen(searchBoxOpen: _showSearchScreen, callback: () {
                              setState(() {
                                _showSearchScreen = false;
                              });
                            },)
                          )
                      ),
                      Positioned(
                          top: 710.h,
                          left: 10.w,
                          child: _showSearchScreen? const SizedBox():Container(
                            width: 430.w,
                            height: 65.h,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.75),
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
