import 'package:flutter/material.dart';

class DataRowWidget extends StatelessWidget {
  const DataRowWidget({
    super.key,
    required this.text,
    this.color,
    required this.width,
  });
  final String text;
  final Color? color;
  final double width;

  Color? fontColorFunc(String text) {
    if (text == 'IN' || text == 'OUT') {
      return text == 'IN' ? Colors.green : Colors.red;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: color,
      width: width,
      child: Text(
        maxLines: 1,
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 13.0, color: fontColorFunc(text)),
      ),
    );
  }
}
