import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workouts/models/workout.dart';

class DatabaseService {
  final CollectionReference _workoutCollection =
      Firestore.instance.collection('workouts');
  final CollectionReference _workoutSchedulesCollection =
      Firestore.instance.collection('workoutSchedules');

  Future addOrUpdateWorkout(WorkoutSchedule schedule) async {
    DocumentReference workoutRef = _workoutCollection.document(schedule.uid);
// Берем ссылку на документ по schedule.id. Она позволит потом достать кусочек данных без неделей
// Кусочек будет хранить название, описание, автора, доступность и дату создания (показывается в меню)
    return workoutRef.setData(schedule.toWorkoutMap()).then((_) async {
      // Сохраняем кусочек по ссылке в коллекцию workouts.
      var docId = workoutRef.documentID;
      // Теперь достаем айди этого воркаута ( .then((_)) )
      // После этого сохраняем в коллекцию workoutSchedules по этому айди (там будут полные данные)
      await _workoutSchedulesCollection
          .document(docId)
          .setData(schedule.toMap());
    });
  }

  // Возвращает список воркаутов в меню. Есть поддержка фильтрации (уровень и автор)
  Stream<List<Workout>> getWorkouts({String level, String author}) {
    // Query - запрос о данных в конкретном месте
    Query query;
    //
    if (author != null)
      query = _workoutCollection.where('author', isEqualTo: author);
    else
      query = _workoutCollection.where('isOnline', isEqualTo: true);

    if (level != null) query = query.where('level', isEqualTo: level);

// Метод snapshots() позволяет вернуть данные в конкретный момент как они есть в базе
// Перемепиваем их на наши воркауты
// Параметр doc будет содержать данные о конкретном воркауте. У него есть id и data
    return query.snapshots().map((QuerySnapshot data) => data.documents
        .map((DocumentSnapshot doc) =>
            Workout.fromJson(doc.documentID, doc.data))
        .toList());
  }
}
