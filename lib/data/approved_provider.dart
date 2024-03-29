import 'package:flutter/material.dart';

import '../model/approval_model.dart';
import '../services/http_service.dart';

class ApprovedProvider with ChangeNotifier {
  var _approvedList = <ApprovalModel>[];
  List<ApprovalModel> get approvedList => _approvedList;

  var _loadMore = false;
  bool get loadMore => _loadMore;

  String fullName(ApprovalModel approvalModel) {
    return '${approvalModel.lastName}, ${approvalModel.firstName} ${approvalModel.middleName}';
  }

  void changeLoadingState(bool state) {
    _loadMore = state;
    notifyListeners();
  }

  Future<void> getApproved() async {
    try {
      var result = await HttpService.getApproved();
      _approvedList = result;
      notifyListeners();
    } catch (e) {
      debugPrint('$e getApproved');
    }
  }

  Future<void> getApprovedLoadmore() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      var result =
          await HttpService.getApprovedLoadmore(_approvedList.last.logId);
      _approvedList.addAll(result);
      notifyListeners();
    } catch (e) {
      debugPrint('$e getApprovedLoadmore');
    }
  }
}
