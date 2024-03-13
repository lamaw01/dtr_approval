import 'package:flutter/material.dart';

import '../model/department_model.dart';
import '../services/http_service.dart';

class DepartmentProvider with ChangeNotifier {
  var _departmentList = <DepartmentModel>[];
  List<DepartmentModel> get departmentList => _departmentList;

  var dropdownValue =
      DepartmentModel(departmentId: '000', departmentName: 'All');

  Future<void> getDepartment() async {
    try {
      final result = await HttpService.getDepartment();
      _departmentList = result;
      _departmentList.insert(0, dropdownValue);
      notifyListeners();
    } catch (e) {
      debugPrint('$e getDepartment');
    }
  }
}
