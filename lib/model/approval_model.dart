// To parse this JSON data, do
//
//     final approvalModel = approvalModelFromJson(jsonString);

import 'dart:convert';

List<ApprovalModel> approvalModelFromJson(String str) =>
    List<ApprovalModel>.from(
        json.decode(str).map((x) => ApprovalModel.fromJson(x)));

String approvalModelToJson(List<ApprovalModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ApprovalModel {
  int id;
  int logId;
  String approvedBy;
  String logType;
  String imagePath;
  String latlng;
  String employeeId;
  String department;
  String team;
  String firstName;
  String lastName;
  String middleName;
  DateTime timeStamp;

  ApprovalModel({
    required this.id,
    required this.logId,
    required this.approvedBy,
    required this.logType,
    required this.imagePath,
    required this.latlng,
    required this.employeeId,
    required this.department,
    required this.team,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.timeStamp,
  });

  factory ApprovalModel.fromJson(Map<String, dynamic> json) => ApprovalModel(
        id: json["id"],
        logId: json["log_id"],
        approvedBy: json["approved_by"],
        logType: json["log_type"],
        imagePath: json["image_path"],
        latlng: json["latlng"],
        employeeId: json["employee_id"],
        department: json["department"],
        team: json["team"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        middleName: json["middle_name"],
        timeStamp: DateTime.parse(json["time_stamp"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "log_id": logId,
        "approved_by": approvedBy,
        "log_type": logType,
        "image_path": imagePath,
        "latlng": latlng,
        "employee_id": employeeId,
        "department": department,
        "team": team,
        "first_name": firstName,
        "last_name": lastName,
        "middle_name": middleName,
        "time_stamp": timeStamp.toIso8601String(),
      };
}
