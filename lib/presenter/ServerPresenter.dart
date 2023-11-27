import 'package:http/http.dart';
import 'package:marg_rakshak/model/ServerModel.dart';

class ServerPresenter{

  ServerPresenter._privateConstructor();
  static final ServerPresenter _instance = ServerPresenter._privateConstructor();
  final _serverModel = ServerModel();

  factory ServerPresenter(){
    return _instance;
  }
  Future<Response> getHomeLocation() async {
    return await _serverModel.getHomeLocation();
  }
  Future<Response> setHouseLocation() async {
    return await _serverModel.setHomeLocation();
  }
}