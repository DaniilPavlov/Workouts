import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workouts/models/user.dart';
import 'package:workouts/core/constants.dart';
import 'package:workouts/pages/check.dart';
import 'package:workouts/services/auth.dart';

void main() {
  runApp(WorkoutsApp());
}

class WorkoutsApp extends StatefulWidget {
  @override
  _WorkoutsAppState createState() => _WorkoutsAppState();
}

class _WorkoutsAppState extends State<WorkoutsApp> {
  //подписка на стрим, который возвращает пользователя
  StreamSubscription<User> userStreamSubscription;

  //стрим юзера вместе с данными
  Stream<User> userDataStream;

  //будем ждать нашего текущего пользователя, но не входим
  //когда будет стрим юзера с юзер дейта внутри, тогда мы будем его загружать
  StreamSubscription<User> setUserDataStream() {
    final auth = AuthService();
    return auth.currentUser.listen((user) {
      userDataStream = auth.getCurrentUserWithData(user);
      setState(() {});
    });
  }

  //первый раз, когда виджет создается, вызываем метод setUserDataStream()
  @override
  void initState() {
    super.initState();
    userStreamSubscription = setUserDataStream();
  }

//каждый раз когда мы создаем новый StreamSubscription, нам нужно от него отписаться в dispose методе
  @override
  void dispose() {
    super.dispose();
    userStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // С помощью StreamProvider<User> мы всегда знаем текущего нашего пользователя
    return StreamProvider<User>.value(
      value: userDataStream,
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
