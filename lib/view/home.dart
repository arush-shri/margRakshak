import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:marg_rakshak/components/custom_widgets/contribution_row.dart';
import 'package:marg_rakshak/components/custom_widgets/outdoor_animator.dart';
import 'package:marg_rakshak/components/custom_widgets/custom_bottom_row.dart';
import 'package:marg_rakshak/view/placeInfo.dart';
import 'package:marg_rakshak/view/search_screen.dart';

import '../presenter/HomePresenter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? _controller;
  bool _showSearchScreen = false;
  bool _showContributionScreen = false;
  bool _navScreen = false;
  MapType mapStyle = MapType.hybrid;
  double containerHeight = 0.0.h;
  double containerWidth = 0.0.h;
  double contributionHeight = 0.0.h;
  double contributionWidth = 0.0.h;
  double terrainRadius = 0.0.h;
  String outdoorCondition = "";
  double screenWidth = 0.0.w;
  Position? position;
  late Response placePic;
  late Map<String, dynamic> _locationDetails;
  final homePresenter = HomePresenter();
  Marker? placeMark;
  double _navScreenTop = 650.h;

  Future<void> initLocation() async {
  final hasPermission = await _handleLocationPermission(context);
  if(hasPermission){
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
  @override
  void initState() {
    initLocation();
    super.initState();
  }

  void _toggleContainer() {
    setState(() {
      containerHeight = containerHeight == 0.0.h ? 60.0.h : 0.0.h;
      containerWidth = containerWidth == 0.0.h ? 223.0.w : 0.0.w;
      terrainRadius = terrainRadius == 0.0.h ? 21.0.h : 0.0.h;
    });
  }

  void _toggleContribute(){
    setState(() {
      contributionHeight = contributionHeight == 0.0.h ? 84.h : 0.0.h;
      contributionWidth = contributionWidth == 0.0.w ? 410.0.w : 0.0.w;
      _showContributionScreen = !_showContributionScreen;
      screenWidth = screenWidth == 0.0.w? 46.w : 0.0.w;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _centerCamera();
  }

  Future<void> locationSearched(String placeName) async {
    final response = await homePresenter.getPlaceDetails(placeName);
    _locationDetails = json.decode(response.body)['result'];
    placePic = await homePresenter.getPlaceImage(_locationDetails['photos'][0]["photo_reference"]);
    final pos = LatLng(_locationDetails["geometry"]["location"]["lat"], _locationDetails["geometry"]["location"]["lng"]);
    setState(() {
      if(_locationDetails.containsKey("opening_hours")){
        _navScreenTop = 615.h;
      }
      _showSearchScreen = false;
      _navScreen = true;
      placeMark = Marker(
        markerId: const MarkerId('place marker'),
        position: pos,
        infoWindow: InfoWindow(title: _locationDetails["name"]),
      );
      _controller!.animateCamera(
        CameraUpdate.newLatLng(
          pos,
        ),
      );
    });
  }

  void _centerCamera() async {
    while (position == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (_controller != null) {
      _controller!.animateCamera(
        CameraUpdate.newLatLng(
            LatLng(position!.latitude, position!.longitude),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_showSearchScreen){
          setState(() {
            _showSearchScreen = false;
          });
          return false;
        }
        if(placeMark != null){
          setState(() {
            placeMark = null;
            _navScreen = false;
          });
          _centerCamera();
          return false;
        }
        return true;
      },
      child: ScreenUtilInit(
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
                          myLocationButtonEnabled: false,
                          myLocationEnabled: true,
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: false,
                          mapType: mapStyle,
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(0,0),
                            zoom: 15.0,
                          ),
                          markers: placeMark == null? {}: {placeMark as Marker},
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
                              }, locationSearched: (String placeName) { locationSearched(placeName); },)
                            )
                        ),
                        outdoorCondition == "" ? Container() : Positioned(
                          child: Container(
                            width: 450.w,
                            height: 800.h,
                            color: const Color(0xFF2C2C2C).withOpacity(0.7),
                            child: OutdoorAnimation(condition: outdoorCondition),
                          ),
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
                                        mapStyle = MapType.hybrid;
                                      });
                                      _toggleContainer;
                                    }),
                                    SizedBox(width: 26.w,),
                                    terrainIcon('assets/images/def_pic.png', () {
                                      setState(() {
                                        mapStyle = MapType.normal;
                                      });
                                      _toggleContainer;
                                    }),
                                    SizedBox(width: 26.w,),
                                    terrainIcon('assets/images/ter_pic.png', () {
                                      setState(() {
                                        mapStyle = MapType.terrain;
                                      });
                                      _toggleContainer;
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
                            child: _showSearchScreen? const SizedBox() : CircleAvatar(
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
                            child: _showSearchScreen? const SizedBox() : CircleAvatar(
                              radius: 20.h,
                              backgroundColor: Colors.white70,
                              child: Icon(Icons.gps_fixed_rounded, size: 29.h,
                                color: const Color(0xFF3263FF),),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                            bottom: 100.h,
                            left: _showContributionScreen? 10.w : 300.w,
                            right: _showContributionScreen? 30.w : 180.w,
                            duration: const Duration(milliseconds: 250),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              height: contributionHeight,
                              width: contributionWidth,
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20.h)),
                                  color: const Color(0xFF44056C).withOpacity(0.9)
                              ),
                              child: SingleChildScrollView(
                                child: ContributionRow(screenWidth: screenWidth,),
                              )
                            )
                        ),
                        _navScreen? Positioned(
                            top: _navScreenTop,
                            child: _showSearchScreen? const SizedBox() : locationInfo()
                        ) : Positioned(
                            top: 710.h,
                            left: 10.w,
                            child: _showSearchScreen? const SizedBox() : Container(
                              width: 430.w,
                              height: 65.h,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.75),
                                  borderRadius: BorderRadius.all(Radius.circular(20.w))
                              ),
                              child: BottomHomeRow(toggleContribute: _toggleContribute,),
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
      ),
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

  Widget locationInfo(){
    return Container(
        padding: EdgeInsets.only(left: 10.w, right: 10.w,top: 5.h),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_locationDetails['name'],
              style: TextStyle(fontSize: 26.sp, fontFamily: "Lexend",
                  fontWeight: FontWeight.w500, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5.h,),
            SizedBox(
              width: 450.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Distance time",
                          style: TextStyle(fontSize: 19.sp, fontFamily: "Lexend",
                              fontWeight: FontWeight.w400, color: Colors.black ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5.h,),
                      _locationDetails.containsKey("opening_hours") && _locationDetails["opening_hours"]["open_now"]!=null?
                      Text( _locationDetails["opening_hours"]["open_now"]? "Open": "Close",
                        style: TextStyle(fontSize: 19.sp, fontFamily: "Lexend",
                            fontWeight: FontWeight.w400,
                            color: _locationDetails["opening_hours"]["open_now"]? const Color(0xFF1FFF12) : Colors.red),
                      ) : const SizedBox(),
                      SizedBox(height: 5.h,),
                      _locationDetails.containsKey("rating")?
                      Row(
                        children: [
                          Text("RATING: ${_locationDetails["rating"].toString()}",
                            style: TextStyle(fontSize: 17.sp, fontFamily: "Lexend",
                                fontWeight: FontWeight.w400, color: Colors.black),                             //total
                          ),
                          const Icon(Icons.star, color: Color(0xFFFFD700),),
                          Text("(${_locationDetails["user_ratings_total"].toString()})",
                            style: TextStyle(fontSize: 17.sp, fontFamily: "Lexend",
                                fontWeight: FontWeight.w500, color: Colors.blueGrey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ) : const SizedBox(),
                      GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => PlaceInformation(locationDetails: _locationDetails)));
                          },
                          child: Text("Show more details",
                            style: TextStyle(fontSize: 20.sp, fontFamily: "Lexend",
                                fontWeight: FontWeight.w500, color: Colors.blue,
                                decoration: TextDecoration.underline),
                            overflow: TextOverflow.ellipsis,
                          )
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: ()=>{},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(400.w))
                              )
                            ),
                            child: Text(
                                "START",
                                style: TextStyle(fontSize: 18.sp, fontFamily: "Lexend",
                                    fontWeight: FontWeight.w400, color: Colors.white),
                              ),
                          ),
                          SizedBox(width: 22.w,),
                          ElevatedButton(
                            onPressed: ()=>{},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(400.w))
                                )
                            ),
                            child: Text(
                              "SHARE",
                              style: TextStyle(fontSize: 18.sp, fontFamily: "Lexend",
                                  fontWeight: FontWeight.w400, color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    width: 200.w,
                    height: 100.h,
                    child: Image.memory(Uint8List.fromList(placePic.bodyBytes),
                        fit: BoxFit.fill,),
                  )
                ],
              ),
            ),
          ],
        ),
      );
  }
}
Future<bool> _handleLocationPermission(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location services are disabled. Please enable the services')));
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }
  return true;
}
