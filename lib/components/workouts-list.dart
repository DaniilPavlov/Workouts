import 'package:flutter/material.dart';
import 'package:workouts/models/workout.dart';
import 'package:workouts/pages/home.dart';

class WorkoutsList extends StatefulWidget {
  @override
  _WorkoutsListState createState() => _WorkoutsListState();
}

class _WorkoutsListState extends State<WorkoutsList> {
  @override
  void initState() {
    clearFilter();
    super.initState();
  }

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

  var filterMy = false;
  var filterTitle = "";
  var filterTitleController = TextEditingController();
  var filterLevel = "Any Level";
  var filterContent = "";
  var filterHeight = 0.0;

  List<Workout> applyFilter() {
    setState(() {
      filterContent = filterMy ? "My Workouts" : "All Workouts";
      filterContent += "/" + filterLevel;
      if (filterTitle.isNotEmpty) filterContent += "/" + filterTitle;
      filterHeight = 0;
    });
    var list = workouts;
    return list;
  }

  List<Workout> clearFilter() {
    setState(() {
      filterContent = "All Workouts/Any Level";
      filterMy = false;
      filterTitle = "";
      filterLevel = "Any Level";
      filterTitleController.clear();
      filterHeight = 0;
    });
    var list = workouts;
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var workoutsList = Expanded(
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
                                right:
                                    BorderSide(width: 1, color: Colors.white))),
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
            }));

    var filterSection = Container(
      margin: EdgeInsets.only(top: 3, left: 7, right: 7, bottom: 5),
      decoration: BoxDecoration(color: Colors.white54),
      height: 40,
      child: RaisedButton(
        child: Row(
          children: <Widget>[
            Icon(Icons.filter_list),
            Text(
              filterContent,
              style: TextStyle(),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
        onPressed: () {
          setState(() {
            filterHeight = (filterHeight == 0 ? 280 : 0);
          });
        },
      ),
    );

    var levelMenu = <String>[
      "Any Level",
      "Beginner",
      "Intermediate",
      "Advanced"
    ].map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();

    var filterForm = AnimatedContainer(
        margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Only my workouts"),
                  value: filterMy,
                  onChanged: (bool val) => setState(() => filterMy = val),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Level"),
                  items: levelMenu,
                  value: filterLevel,
                  onChanged: (String val) => setState(() => filterLevel = val),
                ),
                TextFormField(
                  controller: filterTitleController,
                  decoration: InputDecoration(labelText: "Title"),
                  onChanged: (String val) => setState(() => filterTitle = val),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        onPressed: () {
                          applyFilter();
                        },
                        child: Text("Apply",
                            style: TextStyle(color: Colors.white)),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        onPressed: () {
                          clearFilter();
                        },
                        child: Text("Clear",
                            style: TextStyle(color: Colors.white)),
                        color: Colors.red,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        height: filterHeight);

    return Column(
      children: <Widget>[
        filterSection,
        filterForm,
        workoutsList,
      ],
    );
  }
}
