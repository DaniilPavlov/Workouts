import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workouts/models/user.dart';
import 'package:workouts/core/constants.dart';
import 'package:workouts/pages/check.dart';
import 'package:workouts/services/auth.dart';

void main() {
  runApp(WorkoutsApp());
}

class WorkoutsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // С помощью StreamProvider<User> мы всегда знаем текущего нашего пользователя
    return StreamProvider<User>.value(
      value: AuthService().currentUser,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WORKOUTS',
          theme: ThemeData(
              primaryColor: bgColorPrimary,
              textTheme: TextTheme(headline6: TextStyle(color: Colors.white))),
          home: CheckPage()),
    );
  }
}
