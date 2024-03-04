// class Log {
//   DateTime timeStamp;
//   String logType;
//   int id;
//   String imagePath;
//   String isSelfie;
//   String latlng;
//   int approvalStatus;

//   Log({
//     required this.timeStamp,
//     required this.logType,
//     required this.id,
//     this.imagePath = '',
//     required this.isSelfie,
//     required this.latlng,
//     required this.approvalStatus,
//   });

//   factory Log.fromJson(Map<String, dynamic> json) => Log(
//         timeStamp: DateTime.parse(json["time_stamp"]),
//         logType: json["log_type"].toString(),
//         id: json["id"],
//         imagePath: json["image_path"].toString(),
//         isSelfie: json["is_selfie"].toString(),
//         latlng: json["latlng"].toString(),
//         approvalStatus: json["approval_status"],
//       );

//   Map<String, dynamic> toJson() => {
//         "time_stamp": timeStamp.toIso8601String(),
//         "log_type": logType,
//         "id": id,
//         "image_path": imagePath,
//         "is_selfie": isSelfie,
//         "latlng": latlng,
//         "approval_status": approvalStatus,
//       };
// }

// To parse this JSON data, do
//
//     final log = logFromJson(jsonString);

import 'dart:convert';

Log logFromJson(String str) => Log.fromJson(json.decode(str));

String logToJson(Log data) => json.encode(data.toJson());

class Log {
  DateTime timeStamp;
  String logType;
  int id;
  String imagePath;
  int isSelfie;
  String latlng;
  int approvalStatus;

  Log({
    required this.timeStamp,
    required this.logType,
    required this.id,
    required this.imagePath,
    required this.isSelfie,
    required this.latlng,
    required this.approvalStatus,
  });

  factory Log.fromJson(Map<String, dynamic> json) => Log(
        timeStamp: DateTime.parse(json["time_stamp"]),
        logType: json["log_type"],
        id: json["id"],
        imagePath: json["image_path"],
        isSelfie: json["is_selfie"],
        latlng: json["latlng"],
        approvalStatus: json["approval_status"],
      );

  Map<String, dynamic> toJson() => {
        "time_stamp": timeStamp.toIso8601String(),
        "log_type": logType,
        "id": id,
        "image_path": imagePath,
        "is_selfie": isSelfie,
        "latlng": latlng,
        "approval_status": approvalStatus,
      };
}
