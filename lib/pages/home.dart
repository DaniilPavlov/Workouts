import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:workouts/components/my-workouts.dart';
import 'package:workouts/components/workouts-list.dart';
import 'package:workouts/models/workout.dart';
import 'package:workouts/services/auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bottomSection = 0;

  @override
  Widget build(BuildContext context) {
    var navigationBar = CurvedNavigationBar(
      items: const <Widget>[Icon(Icons.fitness_center), Icon(Icons.search)],
      index: 0,
      height: 50,
      color: Colors.white54,
      buttonBackgroundColor: Colors.white,
      backgroundColor: Colors.white54,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(milliseconds: 500),
      onTap: (int index) {
        setState(() => bottomSection = index);
      },
    );
    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text(
              "Workouts //" + (bottomSection == 0 ? " My Page" : " Search")),
          leading: Icon(Icons.fitness_center),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () {
                  AuthService().logOut();
                },
                icon: Icon(Icons.supervised_user_circle, color: Colors.white),
                label: SizedBox.shrink())
          ],
        ),
        body: bottomSection == 0 ? MyWorkouts() : WorkoutsList(),
        bottomNavigationBar: navigationBar,
      ),
    );
  }
}

Widget subtitle(BuildContext context, Workout workout) {
  var progressColor = Colors.grey;
  double indicator = 0;

  switch (workout.level) {
    case 'Beginner':
      progressColor = Colors.green;
      indicator = 0.33;
      break;
    case 'Intermediate':
      progressColor = Colors.yellow;
      indicator = 0.66;
      break;
    case 'Advanced':
      progressColor = Colors.red;
      indicator = 1;
      break;
  }

  return Row(
    children: <Widget>[
      Expanded(
          child: LinearProgressIndicator(
        backgroundColor: Theme.of(context).textTheme.title.color,
        value: indicator,
        valueColor: AlwaysStoppedAnimation(progressColor),
      )),
      SizedBox(width: 10),
      Expanded(
        flex: 2,
        child: Text(
          workout.level,
          style: TextStyle(color: Theme.of(context).textTheme.title.color),
        ),
      )
    ],
  );
}
