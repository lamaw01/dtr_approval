import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/department_model.dart';
import '../model/selfie_model.dart';
import '../services/http_service.dart';

final _is24HourFormat = ValueNotifier(false);
ValueNotifier<bool> get is24HourFormat => _is24HourFormat;

class SelfiesProvider with ChangeNotifier {
  var _selfieList = <SelfieModel>[];
  List<SelfieModel> get selfieList => _selfieList;

  var _uiList = <SelfieModel>[];
  List<SelfieModel> get uiList => _uiList;

  final _isLoading = ValueNotifier(false);
  ValueNotifier<bool> get isLoading => _isLoading;

  DateTime selectedFrom = DateTime.now();
  DateTime selectedTo = DateTime.now();
  final _dateFormat1 = DateFormat('yyyy-MM-dd HH:mm');

  void changeLoadingState(bool state) {
    _isLoading.value = state;
  }

  String dateFormat12or24Web(DateTime dateTime) {
    if (is24HourFormat.value) {
      return DateFormat('HH:mm').format(dateTime);
    } else {
      return DateFormat('hh:mm aa').format(dateTime);
    }
  }

  Future<void> getSelfies(String employeeId, DepartmentModel department) async {
    var newselectedFrom = selectedFrom.copyWith(hour: 0, minute: 0, second: 0);
    var newselectedTo = selectedTo.copyWith(hour: 23, minute: 59, second: 59);
    try {
      var result = await HttpService.getSelfies(
        employeeId: employeeId,
        dateFrom: _dateFormat1.format(newselectedFrom),
        dateTo: _dateFormat1.format(newselectedTo),
        department: department,
      );
      setData(result);
    } catch (e) {
      log('$e getSelfies');
    }
  }

  Future<void> getSelfiesAll(DepartmentModel department) async {
    var newselectedFrom = selectedFrom.copyWith(hour: 0, minute: 0, second: 0);
    var newselectedTo = selectedTo.copyWith(hour: 23, minute: 59, second: 59);
    try {
      var result = await HttpService.getSelfiesAll(
        dateFrom: _dateFormat1.format(newselectedFrom),
        dateTo: _dateFormat1.format(newselectedTo),
        department: department,
      );
      setData(result);
    } catch (e) {
      log('$e getSelfies');
    }
  }

  // get initial data for history and put 30 it ui
  void setData(List<SelfieModel> data) {
    _selfieList = data;
    if (_selfieList.length > 30) {
      _uiList = _selfieList.getRange(0, 30).toList();
    } else {
      _uiList = _selfieList;
    }
    notifyListeners();
  }

  void loadMore() {
    if (_selfieList.length - _uiList.length < 30) {
      _uiList.addAll(
          _selfieList.getRange(_uiList.length, _selfieList.length).toList());
    } else {
      _uiList.addAll(
          _selfieList.getRange(_uiList.length, _uiList.length + 30).toList());
    }
    notifyListeners();
  }

  Future<void> insertStatus({
    required int approved,
    required String approvedBy,
    required int logId,
    required int indexList,
    required int indexLog,
  }) async {
    try {
      var result = await HttpService.insertStatus(
        approved: approved,
        approvedBy: approvedBy,
        logId: logId,
      );
      _selfieList[indexList].logs[indexLog] = result;
      if (_selfieList.length == _uiList.length) {
        _uiList[indexList].logs[indexLog] = result;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('$e insertStatus');
    }
  }
}
