import 'package:flutter/material.dart';

class DisapprovedView extends StatefulWidget {
  const DisapprovedView({super.key});

  @override
  State<DisapprovedView> createState() => _DisapprovedViewState();
}

class _DisapprovedViewState extends State<DisapprovedView> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Disapproved View'));
  }
}
