import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

class UserModel extends Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;

  Map<String, dynamic> userData = {};

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  final Logger logger = Logger();

  //carregar o usuário logado ao abrir o app
  @override
  void addListener(VoidCallback listener) {
    _loadCurrentUser();
    super.addListener(listener);
  }

  //Usuário atual
  void signUp(
      {required Map<String, dynamic> userData,
      required String pass,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) async {
    // print(' entrou 1');

    isLoading = true;
    notifyListeners();

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userData['email'], password: pass);

      user = credential.user;

      await _saveUserData(userData);

      logger.i('Usuário encontrado: $userData');
      onSuccess();
    } on FirebaseAuthException catch (e, stackStrace) {
      if (e.code == 'email-already-in-use') {
        logger.d("Erro: $e", stackTrace: stackStrace);
        onFail();
      }
    } catch (e, stackStrace) {
      logger.d('Usuário não encontrado: $e', stackTrace: stackStrace);

      onFail();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void singIn({
    required String email,
    required String pass,
    required VoidCallback onSucess,
    required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);

      user = credential.user;
      await _loadCurrentUser();
      logger.i(userData);
      onSucess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        logger.d('No user found for that email.: $e');
      } else if (e.code == 'wrong-password') {
        logger.d('Wrong password provided for that user.: $e');
      }
      onFail();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return user != null;
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
          userData,
        );
  }

  void signOut() async {
    isLoading = true;
    notifyListeners();

    await _auth.signOut();

    userData = {};
    user = null;

    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      user = currentUser;
      final DocumentSnapshot docUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final Map<String, dynamic>? data =
          docUser.data() as Map<String, dynamic>?;
      if (data != null) {
        userData = data;
      }
    }
    notifyListeners();
  }
}
