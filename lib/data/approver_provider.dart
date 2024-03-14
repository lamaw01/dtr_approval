import 'package:flutter/material.dart';

import '../services/http_service.dart';
import '../services/stream_shared.dart';

enum Auth { success, error, failed }

class ApproversProvider with ChangeNotifier {
  Future<Auth> login({
    required String emloyeeId,
    required String password,
  }) async {
    try {
      final result =
          await HttpService.login(emloyeeId: emloyeeId, password: password);
      SharedPreference().storeLoginData(result);
      return Auth.success;
    } on TypeError catch (e) {
      debugPrint('$e auth error');
      return Auth.error;
    } catch (e) {
      debugPrint('$e failed');
      return Auth.failed;
    }
  }
}
