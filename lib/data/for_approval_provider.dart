import 'package:flutter/material.dart';

import '../model/for_approval_model.dart';
import '../services/http_service.dart';
import '../services/stream_shared.dart';

class ForApprovalProvider with ChangeNotifier {
  var _forapprovalList = <ForApprovalModel>[];
  List<ForApprovalModel> get forapprovalList => _forapprovalList;

  var _loadMore = false;
  bool get loadMore => _loadMore;

  String fullName(ForApprovalModel approvalModel) {
    return '${approvalModel.lastName}, ${approvalModel.firstName} ${approvalModel.middleName}';
  }

  void changeLoadingState(bool state) {
    _loadMore = state;
    notifyListeners();
  }

  Future<void> getForApproval() async {
    try {
      var result = await HttpService.getForApproval();
      _forapprovalList = result;
      notifyListeners();
    } catch (e) {
      debugPrint('$e getForApproval');
    }
  }

  Future<void> getForApprovalLoadmore() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      var result =
          await HttpService.getForApprovalLoadmore(_forapprovalList.last.id);
      _forapprovalList.addAll(result);
      notifyListeners();
    } catch (e) {
      debugPrint('$e getDisapprovedLoadmore');
    }
  }

  Future<void> insertStatusForApproval({
    required int approved,
    required int logId,
  }) async {
    try {
      final String approver = await SharedPreference().approverName();

      await HttpService.insertStatusForApproval(
          approved: approved, approvedBy: approver, logId: logId);
    } catch (e) {
      debugPrint('$e insertStatusForApproval');
    } finally {
      await getForApproval();
    }
  }
}
