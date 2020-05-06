import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentDay extends StatelessWidget {
  String curentDateString = new DateFormat('MMMMEEEEd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(curentDateString),
      ),
    );
  }

}