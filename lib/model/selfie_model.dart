// To parse this JSON data, do
//
//     final SelfieModel = selfieModelFromJson(jsonString);

import 'dart:convert';

import 'log_model.dart';

List<SelfieModel> selfieModelFromJson(String str) => List<SelfieModel>.from(
    json.decode(str).map((x) => SelfieModel.fromJson(x)));

String selfieModelToJson(List<SelfieModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SelfieModel {
  String employeeId;
  String firstName;
  String lastName;
  String middleName;
  DateTime date;
  List<Log> logs;
  String weekSchedId;
  String currentSchedId;

  SelfieModel({
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.date,
    required this.logs,
    required this.weekSchedId,
    required this.currentSchedId,
  });

  factory SelfieModel.fromJson(Map<String, dynamic> json) => SelfieModel(
        employeeId: json["employee_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        middleName: json["middle_name"],
        date: DateTime.parse(json["date"]),
        logs: List<Log>.from(json["logs"].map((x) => Log.fromJson(x))),
        weekSchedId: json["week_sched_id"],
        currentSchedId: json["current_sched_id"],
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "first_name": firstName,
        "last_name": lastName,
        "middle_name": middleName,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "logs": List<dynamic>.from(logs.map((x) => x.toJson())),
        "week_sched_id": weekSchedId,
        "current_sched_id": currentSchedId,
      };
}
