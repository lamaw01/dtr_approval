import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/approver_model.dart';

class SharedPreference {
  void storeLoginData(ApproverModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final string = approverModelToJson(model);
    prefs.setString('loginData', string);
  }

  Future<ApproverModel?> getLoginData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? string = prefs.getString('loginData');
      return approverModelFromJson(string!);
    } catch (e) {
      debugPrint('getLoginData $e');
      return null;
    }
  }

  Future<String> approverName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? string = prefs.getString('loginData');
      final model = approverModelFromJson(string!);
      return '${model.lastName}, ${model.firstName} ${model.middleName}';
    } catch (e) {
      debugPrint('approverName $e');
      return '';
    }
  }

  void removeLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('loginData');
  }
}
