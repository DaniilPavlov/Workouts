import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workouts/models/user.dart';

class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final CollectionReference _userDataCollection =
      Firestore.instance.collection("userData");

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      var user = User.fromFirebase(firebaseUser);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<User> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      AuthResult result = await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      var user = User.fromFirebase(firebaseUser);

      var userData = UserData();
      //при регистрации нового пользователя создается новый документ с айди пользователя
      await _userDataCollection.document(user.id).setData(userData.toMap());

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future logOut() async {
    await _fAuth.signOut();
  }

  Stream<User> get currentUser {
    return _fAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user != null ? User.fromFirebase(user) : null);
  }

  //принимаем юзера, достаем дополнительные данные из текущего снепшота, расширяем нашего юзера и возвращаем
  Stream<User> getCurrentUserWithData(User user) {
    //когда юзер делаег логаут, он становится null. Поэтому у user?.id стоит ?(проверка на null)
    //в этом случае будут возвращены пустые данные (null) (в случае логаута)
    return _userDataCollection.document(user?.id).snapshots().map((snapshot) {
      if (snapshot?.data == null) return null;

      var userData = UserData.fromJson(snapshot.documentID, snapshot.data);
      user.setUserData(userData);
      return user;
    });
  }
}
