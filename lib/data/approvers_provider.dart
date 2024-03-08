import 'package:flutter/material.dart';

class ApproversProvider with ChangeNotifier {
  final _listApprover = <String>[
    "Janrey Dumaog",
    "Mc Greg Gerodiaz",
    "Bossing TAC"
  ];

  List<String> get listApprover => _listApprover;
}
