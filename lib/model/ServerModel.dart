import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ServerModel{

  String _userEmail = "";
  String _objectId = "";
  final _serverLink = dotenv.env['SERVERLINK'];
  ServerModel(){
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      _userEmail = user.email!;
    }
  }

  Future<http.Response> createUser() async {
    return await http.get(Uri.parse("${_serverLink}user/createUser/$_userEmail"));
  }

  Future<void> checkUserExists() async {
    final response = await http.get(Uri.parse("${_serverLink}user/userExists/$_userEmail"));
    if(response.statusCode == 402){
      createUser();
    }
  }

  Future<http.Response> getHomeLocation() async {
    return await http.get(Uri.parse("${_serverLink}user/getHomeLocation/$_userEmail"));
  }

  Future<http.Response> setHomeLocation() async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return await http.post(Uri.parse("${_serverLink}user/updateHomeLocation/$_userEmail"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'latitude': "${position.latitude}",
          'longitude': "${position.longitude}"
        })
    );
  }

  Future<http.Response> makeContribution(String collectionName) async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    return await http.post(Uri.parse("${_serverLink}contribute/makeContribution"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'collectionName': collectionName,
      'latitude': "${position.latitude}",
      'longitude': "${position.longitude}"
    }));
  }

  Future<void> navigating(double lat, double lng) async {
    final setResponse = await http.post(
          Uri.parse("${_serverLink}navigation/myLocation"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "email": _userEmail,
            "latitude": "$lat",
            "longitude": "$lng",
            "objectId": _objectId
          })
        );
    if(setResponse.body.isNotEmpty){
      _objectId = json.decode(setResponse.body);
    }
  }

  Future<void> getDanger() async {
    final getDangerRes = await http.get(Uri.parse("${_serverLink}navigation/getDangers"));
    print(json.decode(getDangerRes.body));

  }
}