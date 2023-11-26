import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GoogleMapsQuery{

  final String? _apiKey = dotenv.env['GMAPSAPI'];

  Future<http.Response> getPlaces(String inputText, String sessionToken) async {
    String baseURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request = "$baseURL?input=$inputText&key=$_apiKey&sessiontoken=$sessionToken";
    return await http.get(Uri.parse(request));
  }

  Future<http.Response> getLocationDetail(String placeName) async {
    String baseUrl = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$placeName&key=$_apiKey";
    final response = await http.get(Uri.parse(baseUrl));
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    print(json.decode(response.body)['results'][0]['place_id']);
    String placeDetailUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=${json.decode(response.body)['results'][0]['place_id']}&key=$_apiKey";
    return await http.get(Uri.parse(placeDetailUrl));
  }

  Future<http.Response> getPlaceImage(String photoRefer) async {
    String baseUrl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoRefer&key=$_apiKey";
    return await http.get(Uri.parse(baseUrl));
  }
}