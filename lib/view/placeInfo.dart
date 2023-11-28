import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';

import '../presenter/HomePresenter.dart';

class PlaceInformation extends StatefulWidget {
  final Map<String, dynamic> locationDetails;
  const PlaceInformation({super.key, required this.locationDetails});

  @override
  State<PlaceInformation> createState() => _PlaceInformationState();
}

class _PlaceInformationState extends State<PlaceInformation> {

  final homePresenter = HomePresenter();
  List<Response>? imageResponseList;

  @override
  void initState() {
    super.initState();
    imageResponseList = [];
    for (Map<String, dynamic> item in widget.locationDetails["photos"]){
      getImage(item["photo_reference"]);
    }
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(450,800),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: SingleChildScrollView(
                child: Container(
                  height: 800.h,
                  color: const Color(0xFF00233F),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 80.h,),
                      Center(
                        child: Text(widget.locationDetails['name'],
                          style: TextStyle(fontSize: 32.sp, fontFamily: "Lexend",
                              fontWeight: FontWeight.w500, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("RATING: ${widget.locationDetails["rating"].toString()}",
                            style: TextStyle(fontSize: 20.sp, fontFamily: "Lexend",
                                fontWeight: FontWeight.w400, color: Colors.white),                             //total
                          ),
                          SizedBox(width: 4.w,),
                          const Icon(Icons.star, color: Color(0xFFFFD700),),
                          SizedBox(width: 4.w,),
                          Text("(${widget.locationDetails["user_ratings_total"].toString()})",
                            style: TextStyle(fontSize: 20.sp, fontFamily: "Lexend",
                                fontWeight: FontWeight.w500, color: Colors.blueGrey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Row(
                        children: [
                          SizedBox(
                            width: 80.w,
                            height: 50.h,
                            child: Icon(Icons.location_on, color: Colors.indigoAccent,
                                size: 40.h ,),
                          ),
                          Expanded(
                              child: Text("Address: ${widget.locationDetails["formatted_address"]}",
                                style: TextStyle(fontSize: 22.sp, fontFamily: "Lexend",
                                    fontWeight: FontWeight.w400, color: Colors.white),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 80.w,
                            height: 50.h,
                            child: Icon(Icons.phone, color: Colors.indigoAccent,
                                size: 34.h ,),
                          ),
                          Expanded(
                              child: Text("Phone Number: ${widget.locationDetails["formatted_phone_number"]}",
                                style: TextStyle(fontSize: 22.sp, fontFamily: "Lexend",
                                    fontWeight: FontWeight.w400, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ),
                        ],
                      ),
                      widget.locationDetails.containsKey("opening_hours") && widget.locationDetails["opening_hours"]["open_now"]!=null?
                      Row(
                        children: [
                          SizedBox(
                            width: 80.w,
                            height: 50.h,
                            child: Icon(Icons.access_time_filled, color: Colors.indigoAccent,
                                size: 34.h ,),
                          ),
                          Expanded(
                              child: Text( widget.locationDetails["opening_hours"]["open_now"]? "Open": "Close",
                                style: TextStyle(fontSize: 22.sp, fontFamily: "Lexend",
                                    fontWeight: FontWeight.w400,
                                    color: widget.locationDetails["opening_hours"]["open_now"]? const Color(0xFF1FFF12) : Colors.red),
                              ),
                          ),
                          PopupMenuButton(
                            position: PopupMenuPosition.under,
                            icon: Icon(Icons.keyboard_arrow_down_rounded, size: 34.h,),
                            color: const Color(0xFF9C21FF),
                            itemBuilder: (context) {
                              return List.generate(
                                  widget.locationDetails["opening_hours"]["weekday_text"].length, (index) {
                                return PopupMenuItem(
                                    child: Text(widget.locationDetails["opening_hours"]["weekday_text"][index],
                                      style: TextStyle(fontSize: 20.sp, fontFamily: "Lexend",
                                          fontWeight: FontWeight.w400, color: Colors.white),
                                      overflow: TextOverflow.ellipsis, // Adjust the font size as needed
                                    )
                                );
                              }
                              );
                            },
                          )
                        ],
                      ) : const SizedBox(),
                      Row(
                        children: [
                          SizedBox(
                            width: 80.w,
                            height: 70.h,
                            child: Icon(Icons.photo_sharp, color: Colors.indigoAccent,
                                size: 36.h ,),
                          ),
                          Text("Photos:",
                            style: TextStyle(fontSize: 26.sp, fontFamily: "Lexend",
                                fontWeight: FontWeight.w500, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      imageResponseList!.length>1?SizedBox(
                        height: 250.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageResponseList?.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              child: Image.memory(Uint8List.fromList(imageResponseList![index].bodyBytes),
                                  fit: BoxFit.fill),
                            );
                          },
                        ),
                      ) : const Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(
                            color: Color(0xFF135ED0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ),
        );
      },
    );
  }
  Future<void> getImage(String reference) async {
    final response = await homePresenter.getPlaceImage(reference);
    setState(() {
      imageResponseList?.add(response);
    });
  }
}
