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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: color,
      width: width,
      child: Text(
        maxLines: 1,
        text,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13.0),
      ),
    );
  }
}
