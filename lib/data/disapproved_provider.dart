import 'package:flutter/material.dart';

import '../model/approval_model.dart';
import '../services/http_service.dart';

class DisapprovedProvider with ChangeNotifier {
  var _disapprovedList = <ApprovalModel>[];
  List<ApprovalModel> get disapprovedList => _disapprovedList;

  var _loadMore = false;
  bool get loadMore => _loadMore;

  String fullName(ApprovalModel approvalModel) {
    return '${approvalModel.lastName}, ${approvalModel.firstName} ${approvalModel.middleName}';
  }

  void changeLoadingState(bool state) {
    _loadMore = state;
    notifyListeners();
  }

  Future<void> getDisapproved() async {
    try {
      var result = await HttpService.getDisapproved();
      _disapprovedList = result;
      notifyListeners();
    } catch (e) {
      debugPrint('$e getDisapproved');
    }
  }

  Future<void> getDisapprovedLoadmore() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      var result = await HttpService.getDisapprovedLoadmore(
          1); //_disapprovedList.last.logId
      _disapprovedList.addAll(result);
      notifyListeners();
    } catch (e) {
      debugPrint('$e getDisapprovedLoadmore');
    }
  }
}
