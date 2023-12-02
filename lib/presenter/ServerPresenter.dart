import 'package:http/http.dart';
import 'package:marg_rakshak/model/ServerModel.dart';

class ServerPresenter {

  ServerPresenter._privateConstructor();
  static final ServerPresenter _instance = ServerPresenter._privateConstructor();
  static final _serverModel = ServerModel();

  factory ServerPresenter(){
    _serverModel.checkUserExists();
    return _instance;
  }
  Future<Response> getHomeLocation() async {
    return await _serverModel.getHomeLocation();
  }
  Future<Response> setHouseLocation() async {
    return await _serverModel.setHomeLocation();
  }
  Future<Response> makeContribution(String collectionName) async {
    return await _serverModel.makeContribution(collectionName);
  }
  Future<void> navigating(double lat, double lng, double speed) async {
    await _serverModel.navigating(lat, lng);
    final some = await _serverModel.getDanger(speed);
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    print(some);
  }
}