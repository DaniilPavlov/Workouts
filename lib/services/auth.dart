import 'package:firebase_auth/firebase_auth.dart';
import 'package:workouts/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> emailAndPasswordLogIn(String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = authResult.user;
      return User.fromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future<User> emailAndPasswordReg(String email, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = authResult.user;
      return User.fromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future<User> emailAndPasswordLogOut() async {
    await _auth.signOut();
  }

  Stream<User> get currentUser {
    return _auth.onAuthStateChanged.map(
        (FirebaseUser user) => user != null ? User.fromFirebase(user) : null);
  }
}
