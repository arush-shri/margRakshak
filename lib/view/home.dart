import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marg_rakshak/view/custom_bottom_row.dart';
import 'package:marg_rakshak/view/search_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? _controller;
  bool _showSearchScreen = false;
  MapType mapStyle = MapType.satellite;
  double containerHeight = 0.0.h;
  double containerWidth = 0.0.h;
  double terrainRadius = 0.0.h;

  static const Marker mark = Marker(
      markerId: MarkerId('MyMarker'),
      infoWindow: InfoWindow(title: "You"),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(37.43296265331129, -122.08832357078792)
  );

  void _toggleContainer() {
    setState(() {
      containerHeight = containerHeight == 0.0.h ? 60.0.h : 0.0.h;
      containerWidth = containerWidth == 0.0.h ? 195.0.h : 0.0.h;
      terrainRadius = terrainRadius == 0.0.h ? 21.0.h : 0.0.h;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _centerCamera() {
    if (_controller != null) {
      _controller!.animateCamera(
        CameraUpdate.newLatLng(
            const LatLng(37.43296265331129, -122.08832357078792),
        ),
      );
    }
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
                        markers: {mark},
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: false,
                        mapType: mapStyle,
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
                          bottom: 150.h,
                          left: 34.w,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn,
                            height: containerHeight,
                            width: containerWidth,
                            padding: EdgeInsets.symmetric(horizontal: 13.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20.h)),
                              color: Colors.white.withOpacity(0.9)
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  terrainIcon('assets/images/sat_pic.png', () {
                                    setState(() {
                                      mapStyle = MapType.satellite;
                                    });
                                  }),
                                  SizedBox(width: 26.w,),
                                  terrainIcon('assets/images/def_pic.png', () {
                                    setState(() {
                                      mapStyle = MapType.normal;
                                    });
                                  }),
                                  SizedBox(width: 26.w,),
                                  terrainIcon('assets/images/ter_pic.png', () {
                                    setState(() {
                                      mapStyle = MapType.terrain;
                                    });
                                  }),
                                ],
                              ),
                            ),
                          )
                      ),
                      Positioned(
                        top: 660.h,
                        left: 10.w,
                        child: GestureDetector(
                          onTap: _toggleContainer,
                          child: CircleAvatar(
                            radius: 20.h,
                            backgroundColor: Colors.white70,
                            child: Icon(Icons.layers_rounded, size: 28.h, color: Colors.black,),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 660.h,
                        right: 10.w,
                        child: GestureDetector(
                          onTap: _centerCamera,
                          child: CircleAvatar(
                            radius: 20.h,
                            backgroundColor: Colors.white70,
                            child: Icon(Icons.gps_fixed_rounded, size: 29.h,
                              color: const Color(0xFF3263FF),),
                          ),
                        ),
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

  Widget terrainIcon(String picPath, VoidCallback callback){
    return GestureDetector(
      onTap: callback,
      child: CircleAvatar(
        radius: terrainRadius,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage(picPath),
      ),
    );
  }
}
