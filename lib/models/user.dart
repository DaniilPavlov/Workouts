import 'package:firebase_auth/firebase_auth.dart';
import 'package:workouts/models/workout.dart';

class User {
  String id;
  UserData userData;

  User.fromFirebase(FirebaseUser fUser) {
    id = fUser.uid;
  }

  void setUserData(UserData userData) {
    this.userData = userData;
  }

  //проверка загружен воркаут или нет, чтобы не загружать еще раз
  bool hasActiveWorkout(String uid) =>
      userData != null &&
      userData.workouts != null &&
      userData.workouts
          .any((w) => w.workoutId == uid && w.completedOnMs == null);

  //ниже берем все воркауты (их айди), активные для данного пользователя
  List<String> get workoutIds => userData != null && userData.workouts != null
      ? userData.workouts.map((e) => e.workoutId).toList()
      : List<String>();
}

//так как работаем с firebase, нам нужны методы конвертации ИЗ (fromJson) и В (toMap) во всех классах
class UserData {
  String uid;
  List<UserWorkout> workouts;

  Map<String, dynamic> toMap() {
    return {
      "workouts":
          workouts == null ? [] : workouts.map((w) => w.toMap()).toList()
    };
  }

  UserData();

  UserData.fromJson(String uid, Map<String, dynamic> data) {
    this.uid = uid;
    if (data['workouts'] == null)
      workouts = List<UserWorkout>();
    else
      workouts = (data['workouts'] as List)
          .map((w) => UserWorkout.fromJson(w))
          .toList();
  }

  bool hasActiveWorkout(String uid) =>
      workouts != null &&
      workouts.any((w) => w.workoutId == uid && w.completedOnMs == null);

//в коллекцию воркаутов добавляем новую запись
  void addUserWorkout(UserWorkout userWorkout) {
    if (workouts == null) workouts = List<UserWorkout>();

    workouts.add(userWorkout);
  }
}

class UserWorkout {
  String workoutId;
  List<UserWorkoutWeek> weeks;
  int lastWeek;
  int lastDay;
  int loadedOnMs; //дата загрузки воркаута (начало работы с ним)
  int completedOnMs; //дата окончания воркаута (когда закончил его)

  Map<String, dynamic> toMap() {
    return {
      "workoutId": workoutId,
      "lastWeek": lastWeek,
      "lastDay": lastDay,
      "loadedOnMs": loadedOnMs,
      "completedOnMs": completedOnMs,
      "weeks": weeks.map((w) => w.toMap()).toList(),
    };
  }

  UserWorkout.fromJson(Map<String, dynamic> value) {
    workoutId = value['workoutId'];
    lastWeek = value['lastWeek'];
    lastDay = value['lastDay'];
    loadedOnMs = value['loadedOnMs'];
    completedOnMs = value['completedOnMs'];
    weeks = (value['weeks'] as List)
        .map((w) => UserWorkoutWeek.fromJson(w))
        .toList();
  }

  //мэпит воркаут айди, идет по всем неделям и дням и создает пустые ячейки.
  //каждый раз, когда пользователь будет загружать новый воркаут, мы будем сохранять его в его профиль
  UserWorkout.fromWorkout(WorkoutSchedule workout) {
    workoutId = workout.uid;
    weeks = workout.weeks.map((e) {
      final days = [
        for (var i = 0; i < e.days.length; i += 1) UserWorkoutDay.empty()
      ].toList();
      final week = UserWorkoutWeek(days);
      return week;
    }).toList();

    loadedOnMs = DateTime.now().millisecondsSinceEpoch;
  }
}

class UserWorkoutWeek {
  List<UserWorkoutDay> days;

  UserWorkoutWeek(this.days);

  Map<String, dynamic> toMap() {
    return {
      "days": days.map((w) => w.toMap()).toList(),
    };
  }

  UserWorkoutWeek.fromJson(Map<String, dynamic> value) {
    days =
        (value['days'] as List).map((w) => UserWorkoutDay.fromJson(w)).toList();
  }
}

class UserWorkoutDay {
  int completedOnMs;

  UserWorkoutDay.empty();

  UserWorkoutDay.fromJson(Map<String, dynamic> value) {
    completedOnMs = value['completedOnMs'];
  }

  Map<String, dynamic> toMap() {
    return {
      "completedOnMs": completedOnMs,
    };
  }
}
