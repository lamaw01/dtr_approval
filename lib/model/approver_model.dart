// To parse this JSON data, do
//
//     final approverModel = approverModelFromJson(jsonString);

import 'dart:convert';

ApproverModel approverModelFromJson(String str) =>
    ApproverModel.fromJson(json.decode(str));

String approverModelToJson(ApproverModel data) => json.encode(data.toJson());

class ApproverModel {
  int id;
  String employeeId;
  String lastName;
  String firstName;
  String middleName;

  ApproverModel({
    required this.id,
    required this.employeeId,
    required this.lastName,
    required this.firstName,
    required this.middleName,
  });

  factory ApproverModel.fromJson(Map<String, dynamic> json) => ApproverModel(
        id: json["id"],
        employeeId: json["employee_id"],
        lastName: json["last_name"],
        firstName: json["first_name"],
        middleName: json["middle_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "last_name": lastName,
        "first_name": firstName,
        "middle_name": middleName,
      };

  @override
  String toString() {
    return "($id,$employeeId,$lastName,$firstName,$middleName)";
  }
}
