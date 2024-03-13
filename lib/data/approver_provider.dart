import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../model/approver_model.dart';
import '../model/approver_model.dart';
import '../services/http_service.dart';

enum Auth { success, error, failed }

class ApproversProvider with ChangeNotifier {
  Future<Auth> login({
    required String emloyeeId,
    required String password,
  }) async {
    try {
      final result =
          await HttpService.login(emloyeeId: emloyeeId, password: password);
      storeLoginData(result);
      return Auth.success;
    } on TypeError catch (e) {
      debugPrint('$e auth error');
      return Auth.error;
    } catch (e) {
      debugPrint('$e failed');
      return Auth.failed;
    }
  }

  void storeLoginData(ApproverModel model) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final string = approverModelToJson(model);
      prefs.setString('login_info', string);
    } catch (e) {
      debugPrint('$e storeLoginData');
    }
  }
}
