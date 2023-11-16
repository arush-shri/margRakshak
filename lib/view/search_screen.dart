import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback callback;
  final bool searchBoxOpen;
  const SearchScreen({super.key, required this.searchBoxOpen, required this.callback});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchText = TextEditingController();
  bool toastShown = false;
  String transportMedium = "";

  @override
  Widget build(BuildContext context) {
    return widget.searchBoxOpen? searchOpened(context) : searchClosed();
  }

  Widget searchClosed(){
    return Container(
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
            Text("Search",
              style: TextStyle(fontSize: 18.sp, fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold , color: Colors.black),),
          ],
        ),
      ),
    );
  }

  Widget searchOpened(BuildContext context){
    if (!toastShown){
      toastShown = true;
      Fluttertoast.showToast(
          msg: "Please select your transportation medium",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: const Color(0xFF46009A),
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    return WillPopScope(onWillPop: () async {
      widget.callback();
      toastShown = false;
      return false;
    },
      child: Container(
        width: 450.w,
        height: 800.h,
        decoration: const BoxDecoration(color: Color(0xFF031434)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 70.w, 30.w, 15.w),
              child: TextField(
                controller: _searchText,
                cursorColor: Colors.deepPurpleAccent,
                decoration: InputDecoration(
                  labelText: 'Search',
                  fillColor: Colors.transparent,
                  labelStyle: TextStyle(fontSize: 20.sp, fontFamily: GoogleFonts.poppins().fontFamily,
                      color: Colors.deepPurpleAccent),
                  filled: true,
                  isDense: true,
                  border: const UnderlineInputBorder(),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurpleAccent)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurpleAccent)),
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(color: Colors.white, fontSize: 23.sp,
                    fontFamily: "Lexend", fontWeight: FontWeight.w400),
              ),
            ),
            ChangeNotifierProvider(
              create: (context) => ButtonHighlighter(),
              child: Consumer<ButtonHighlighter>(
                builder: (context, provider, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    rowItem( context, "car", Icons.directions_car_filled_outlined, ()=>transportMedium = "car"),
                    rowItem( context, "bus", Icons.directions_bus_filled_outlined, ()=>transportMedium = "bus"),
                    rowItem( context, "bike", Icons.motorcycle_sharp, ()=>transportMedium = "bike"),
                    rowItem( context, "walk", Icons.directions_walk_outlined, ()=>transportMedium = "walk"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h,),
            Divider(
              height: 1.h,
              thickness: 1.5.h,
              color: const Color(0xFFABABAB),
            )
          ],
        ),
      ),
    );
  }
}

Widget rowItem(BuildContext context, String name, IconData icon,VoidCallback callback){
  final colorChange = Provider.of<ButtonHighlighter>(context,listen: true);
  bool colorBool = colorChange.getValue(name);
  return GestureDetector(
    onTap: (){
      callback;
      colorChange.setValue(name);
    },
    child: Container(
      width: 80.w,
      height: 40.h,
      decoration: BoxDecoration(
          color: colorBool? const Color(0xFF3479E1): Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(400.w))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,color: colorBool? Colors.white : const Color(0xFF989898), size: 36.w,)
        ],
      ),
    ),
  );
}

class ButtonHighlighter extends ChangeNotifier{
  bool carIcon = true;
  bool busIcon = false;
  bool bikeIcon = false;
  bool walkIcon = false;

  bool getValue(String name){
    if(name == "car") {
      return carIcon;
    } else if(name == "bus") {
      return busIcon;
    } else if(name == "bike") {
      return bikeIcon;
    }
    return walkIcon;
  }

  void setValue(String name){
    if(name == "car" && !carIcon) {
      busIcon = bikeIcon = walkIcon = false;
      carIcon = true;
    }
    else if(name == "bus" && !busIcon) {
      carIcon = bikeIcon = walkIcon = false;
      busIcon = true;
    }
    else if(name == "bike" && !bikeIcon) {
      carIcon = busIcon = walkIcon = false;
      bikeIcon = true;
    }
    else if(name == "walk" && !walkIcon) {
      carIcon = busIcon = bikeIcon = false;
      walkIcon = true;
    }
    notifyListeners();
  }
}