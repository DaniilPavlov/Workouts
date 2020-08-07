import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workouts/models/user.dart';
import 'package:workouts/pages/check.dart';
import 'package:workouts/services/auth.dart';

void main() {
  runApp(WorkoutsApp());
}

class WorkoutsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().currentUser,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Workouts",
          theme: ThemeData(
              primaryColor: Color.fromRGBO(73, 161, 212, 1),
              textTheme: TextTheme(title: TextStyle(color: Colors.white))),
          home: CheckPage(),
        ));
  }
}
