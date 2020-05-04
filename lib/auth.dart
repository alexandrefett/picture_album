import 'dart:async';
import 'package:firebase/firebase.dart';

abstract class BaseAuth {
  User currentUser();
  Stream<User> onAuthStateChanged();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

class AuthService implements BaseAuth {
  Auth _firebaseAuth;
  User user;

  AuthService() {
    initializeApp(
        apiKey: 'AIzaSyCfD19geKC_N5ZsnL8-zk9og9zUhUOhK58',
        authDomain: 'digitalsignage-a824c.firebaseapp.com',
        databaseURL: 'https://digitalsignage-a824c.firebaseio.com',
        projectId: 'digitalsignage-a824c',
        storageBucket: 'digitalsignage-a824c.appspot.com',
        messagingSenderId: '990343580564');
    _firebaseAuth = auth();
    user = _firebaseAuth.currentUser;
  }

  @override
  Stream<User> onAuthStateChanged() {
    return _firebaseAuth.onAuthStateChanged;
  }

  @override
  User currentUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.createUserWithEmailAndPassword(email, password))
        .user;
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(email, password))
        .user;
  }

  Future signOut() {
    return _firebaseAuth.signOut();
  }
}

final AuthService authService = AuthService();
