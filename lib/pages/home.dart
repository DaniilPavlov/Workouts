import 'package:flutter/material.dart';
import 'package:workouts/models/workout.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text("Workouts"),
          leading: Icon(Icons.fitness_center),
        ),
        body: WorkoutsList(),
      ),
    );
  }
}

class WorkoutsList extends StatelessWidget {
  final workouts = <Workout>[
    Workout(
        title: 'test1', author: 'kek1', description: 'smth', level: 'Beginner'),
    Workout(
        title: 'test2',
        author: 'kek1',
        description: 'smth',
        level: 'Intermediate'),
    Workout(
        title: 'test3', author: 'kek2', description: 'smth', level: 'Beginner'),
    Workout(
        title: 'test4', author: 'kek1', description: 'smth', level: 'Advanced'),
    Workout(
        title: 'test5', author: 'kek3', description: 'smth', level: 'Beginner'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          child: ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, i) {
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(73, 161, 212, 0.7),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.fitness_center,
                            color: Theme.of(context).textTheme.title.color,
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 1, color: Colors.white))),
                        ),
                        title: Text(
                          workouts[i].title,
                          style: TextStyle(
                              color: Theme.of(context).textTheme.title.color,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).textTheme.title.color,
                        ),
                        subtitle: subtitle(context, workouts[i]),
                      )),
                );
              })),
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
