import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Dios/api_dio.dart';
import 'package:scms/services/session_repo.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../Utils/tools.dart';
import '../../../generated/l10n.dart';
import '../../../globle/m/error_response.dart';
import '../m/login_response.dart';
class LoginController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();
  var name = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var cnf_password = TextEditingController();


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
  bool validateRegsiter() {
    if (name.value.text.toString().isEmpty) {
      Tools.ShowErrorMessage(scaffoldKey.currentContext, "Name required");
      return false;
    }if (email.value.text.toString().isEmpty) {
      Tools.ShowErrorMessage(scaffoldKey.currentContext, S.of(scaffoldKey.currentContext!).emailRequired);
      return false;
    }if (!Tools.isEmailValid(email.value.text.toString())) {
      Tools.ShowErrorMessage(scaffoldKey.currentContext, S.of(scaffoldKey.currentContext!).emailNotValid);
      return false;
    }if (password.value.text.toString().isEmpty) {
      Tools.ShowErrorMessage(scaffoldKey.currentContext, S.of(scaffoldKey.currentContext!).passwordRequired);
      return false;
    }if (password.value.text.toString()!=cnf_password.value.text.toString()) {
      Tools.ShowErrorMessage(scaffoldKey.currentContext, "Password not match");
      return false;
    }
    return true;
  }
  void lgoinWithPassword() async {
    if(validate()){
    FocusScope.of(scaffoldKey.currentContext!).unfocus();
      LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerLogin().then((value){
      LockOverlay().closeOverlay();
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
        Future.delayed(Duration(seconds: 2),() {
          Navigator.pushNamedAndRemoveUntil(scaffoldKey.currentContext!, '/project_list', (route) => false);
        },);
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError(onError);

  }
  }
  void register() async {
    if(validateRegsiter()){
    FocusScope.of(scaffoldKey.currentContext!).unfocus();
      LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerRegister().then((value){
      LockOverlay().closeOverlay();
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
        Navigator.pushNamedAndRemoveUntil(scaffoldKey.currentContext!, '/project_list', (route) => false);
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError(onError);

  }
  }

  Future<LoginResponse>_ListenerLogin() async {
    Map<String,dynamic> map=Map();
    map["email"]=email.value.text.toString();
    map["password"]=password.value.text.toString();
    var response =
    await httpClient().post("login",data: map);
    if(response.data["success"]) {
      CreateSession(response.data['data']);
    }
    return LoginResponse.fromJson(response.data);
  }
  Future<LoginResponse>_ListenerRegister() async {
    Map<String,dynamic> map=Map();
    map["name"]=name.value.text.toString();
    map["email"]=email.value.text.toString();
    map["password"]=password.value.text.toString();
    map["c_password"]=cnf_password.value.text.toString();
    map["user_type"]="2";
    var response =
    await httpClient().post("register",data: map);
    if(response.data["success"]) {
      CreateSession(response.data['data']);
    }
    return LoginResponse.fromJson(response.data);
  }
  void onError(e){
    if (e is DioError) {
      ErrorResponse errorResponse=ErrorResponse.fromJson(e.response!.data);
      Tools.ShowErrorMessage(scaffoldKey.currentContext, errorResponse.message);
    }
    LockOverlay().closeOverlay();
  }
 }
