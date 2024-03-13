import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/approver_model.dart';

class SharedPreference {
  final _controller = StreamController<bool>();

  Stream<bool> get loggedIn async* {
    yield* _controller.stream;
  }

  void setLogged(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged', value);
    _controller.add(value); // update value here.
  }

  Future<bool> getLogged() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('logged') ?? false;
  }

  void storeLoginData(ApproverModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final string = approverModelToJson(model);
    prefs.setString('loginData', string);
  }

  Future<ApproverModel> getLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    String? string = prefs.getString('loginData');
    return approverModelFromJson(string!);
  }

  // call when user closes the app or something.
  void dispose() => _controller.close();
}
