import 'package:flutter/material.dart';
import 'package:workouts/pages/check.dart';

void main() {
  runApp(WorkoutsApp());
}

class WorkoutsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Workouts",
      theme: ThemeData(
          primaryColor: Color.fromRGBO(73, 161, 212, 1),
          textTheme: TextTheme(title: TextStyle(color: Colors.white))),
      home: CheckPage(),
    );
  }
}
