import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/services/session_repo.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../Utils/tools.dart';
import '../../../generated/l10n.dart';
import '../../Home/m/user_model.dart';
class LoginController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();
  var email = TextEditingController();
  var password = TextEditingController();
  String? error;
  String? token;
  String? passCode;
  bool rememberMe=false;
  bool isVerified=false;

  LoginController() {
    email.text="admin@gmail.com";
    password.text="admin2022";
  }

  bool validate() {
    if (email.value.text.toString().isEmpty) {
      Tools.ShowErrorMessage(scaffoldKey.currentContext, S.of(scaffoldKey.currentContext!).emailRequired);
      return false;
    }if (!Tools.isEmailValid(email.value.text.toString())) {
      Tools.ShowErrorMessage(scaffoldKey.currentContext, S.of(scaffoldKey.currentContext!).emailNotValid);
      return false;
    }if (password.value.text.toString().isEmpty) {
      Tools.ShowErrorMessage(scaffoldKey.currentContext, S.of(scaffoldKey.currentContext!).passwordRequired);
      return false;
    }
    return true;
  }
  void lgoinWithPassword() async {
    if(validate()){
    FocusScope.of(scaffoldKey.currentContext!).unfocus();
      LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.value.text.toString(),
        password: password.value.text.toString(),
      );
      getUser(credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      LockOverlay().closeOverlay();
      if (e.code == 'user-not-found') {
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, 'No user found for that email.');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, 'Wrong password provided for that user.');
      }

    } catch (e) {
      print(e);
      LockOverlay().closeOverlay();
    }
  }
  }
  void getUser(udid){
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/$udid');
    ref.onValue.listen((DatabaseEvent event) {
      LockOverlay().closeOverlay();
      final data = event.snapshot;
      print(event.snapshot.value);
      UserModel model=UserModel(
          uid: data.child('uid').value,
          name: data.child('name').value,
          email: data.child('email').value,
          password: data.child('password').value,
          user_type: data.child('user_type').value,
      );
      CreateSession(model.toMap());
      Navigator.pushNamedAndRemoveUntil(scaffoldKey.currentContext!, '/project_list', (route) => false);
      print("getuser ${model.toMap()}");
    });
  }
 }
