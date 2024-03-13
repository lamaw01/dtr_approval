import 'dart:convert';
// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/approval_model.dart';
import '../model/approver_model.dart';
import '../model/department_model.dart';
import '../model/for_approval_model.dart';
import '../model/log_model.dart';
import '../model/selfie_model.dart';

class HttpService {
  static const String _serverUrl =
      'http://103.62.153.74:53000/dtr_approval_api';
  static String get serverUrl => _serverUrl;

  static Future<List<SelfieModel>> getSelfies({
    required String employeeId,
    required String dateFrom,
    required String dateTo,
    required DepartmentModel department,
  }) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/get_selfie.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            <String, dynamic>{
              'employee_id': employeeId,
              'date_from': dateFrom,
              'date_to': dateTo,
              'department': department.departmentId,
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    // debugPrint('getSelfies ${response.body}');
    return selfieModelFromJson(response.body);
  }

  static Future<List<SelfieModel>> getSelfiesAll({
    required String dateFrom,
    required String dateTo,
    required DepartmentModel department,
  }) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/get_all_selfie.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            <String, dynamic>{
              'date_from': dateFrom,
              'date_to': dateTo,
              'department': department.departmentId,
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    // debugPrint('getSelfiesAll ${response.body}');
    return selfieModelFromJson(response.body);
  }

  static Future<List<DepartmentModel>> getDepartment() async {
    var response = await http.get(
      Uri.parse('$_serverUrl/get_department.php'),
      headers: <String, String>{
        'Accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 10));
    return departmentModelFromJson(response.body);
  }

  static Future<Log> insertStatus({
    required int approved,
    required String approvedBy,
    required int logId,
  }) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/insert_status.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            <String, dynamic>{
              'approved': approved,
              'approved_by': approvedBy,
              'log_id': logId,
              'id': logId,
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    // debugPrint('insertStatus ${response.statusCode} ${response.body}');
    return logFromJson(response.body);
  }

  static Future<List<ApprovalModel>> getApproved() async {
    var response = await http.get(
      Uri.parse('$_serverUrl/get_approved.php'),
      headers: <String, String>{
        'Accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 10));
    // debugPrint('getApproved ${response.body}');
    return approvalModelFromJson(response.body);
  }

  static Future<List<ApprovalModel>> getApprovedLoadmore(int id) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/get_approved_loadmore.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(<String, dynamic>{'id': id}),
        )
        .timeout(const Duration(seconds: 10));
    // debugPrint('getApprovedLoadmore ${response.body}');
    return approvalModelFromJson(response.body);
  }

  static Future<List<ApprovalModel>> getDisapproved() async {
    var response = await http.get(
      Uri.parse('$_serverUrl/get_disapproved.php'),
      headers: <String, String>{
        'Accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 10));
    // debugPrint('getDisapproved ${response.body}');
    return approvalModelFromJson(response.body);
  }

  static Future<List<ApprovalModel>> getDisapprovedLoadmore(int id) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/get_disapproved_loadmore.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(<String, dynamic>{'id': id}),
        )
        .timeout(const Duration(seconds: 10));
    // debugPrint('getDisapprovedLoadmore ${response.body}');
    return approvalModelFromJson(response.body);
  }

  static Future<List<ForApprovalModel>> getForApproval() async {
    var response = await http.get(
      Uri.parse('$_serverUrl/get_for_approval.php'),
      headers: <String, String>{
        'Accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 10));
    // debugPrint('getForApproval ${response.body}');
    return forApprovalModelFromJson(response.body);
  }

  static Future<void> insertStatusForApproval({
    required int approved,
    required String approvedBy,
    required int logId,
  }) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/insert_status_for_approval.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            <String, dynamic>{
              'approved': approved,
              'approved_by': approvedBy,
              'log_id': logId,
              'id': logId,
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    debugPrint(
        'insertStatusForApproval ${response.statusCode} ${response.body}');
  }

  static Future<List<ForApprovalModel>> getForApprovalLoadmore(int id) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/get_for_approval_loadmore.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(<String, dynamic>{'id': id}),
        )
        .timeout(const Duration(seconds: 10));
    // debugPrint(
    //     'getForApprovalLoadmore ${response.body}');
    return forApprovalModelFromJson(response.body);
  }

  static Future<ApproverModel> login({
    required String emloyeeId,
    required String password,
  }) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/login.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            <String, dynamic>{
              'employee_id': emloyeeId,
              'password': password,
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    // debugPrint('login ${response.body}');
    return approverModelFromJson(response.body);
  }
}
