// To parse this JSON data, do
//
//     final forApprovalModel = forApprovalModelFromJson(jsonString);

import 'dart:convert';

List<ForApprovalModel> forApprovalModelFromJson(String str) =>
    List<ForApprovalModel>.from(
        json.decode(str).map((x) => ForApprovalModel.fromJson(x)));

String forApprovalModelToJson(List<ForApprovalModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ForApprovalModel {
  int id;
  String employeeId;
  String firstName;
  String lastName;
  String middleName;
  String logType;
  String latlng;
  String imagePath;
  String department;
  String team;
  DateTime timeStamp;

  ForApprovalModel({
    required this.id,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.logType,
    required this.latlng,
    required this.imagePath,
    required this.department,
    required this.team,
    required this.timeStamp,
  });

  factory ForApprovalModel.fromJson(Map<String, dynamic> json) =>
      ForApprovalModel(
        id: json["id"],
        employeeId: json["employee_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        middleName: json["middle_name"],
        logType: json["log_type"],
        latlng: json["latlng"],
        imagePath: json["image_path"],
        department: json["department"],
        team: json["team"],
        timeStamp: DateTime.parse(json["time_stamp"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "first_name": firstName,
        "last_name": lastName,
        "middle_name": middleName,
        "log_type": logType,
        "latlng": latlng,
        "image_path": imagePath,
        "department": department,
        "team": team,
        "time_stamp": timeStamp.toIso8601String(),
      };
}
