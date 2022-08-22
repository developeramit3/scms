import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scms/services/project_model.dart';
import 'package:scms/ui/Home/m/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
const String prefSelectedLanguageCode = "SelectedLanguageCode";

Future<String>getUserID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return jsonDecode(prefs.getString('data')!)["customerId"].toString();
}

//TODO: ==============Session Crud======================
CreateSession(data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLogin', true);
  await prefs.setString('data', jsonEncode(data));
  prefs.commit();
}
setTheme(String b) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('themeMode', b);
  prefs.commit();
}

setSessionToken(token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token',token);
  prefs.commit();
}

Logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  prefs.commit();
}
Future<bool?> isLogin() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLogin');
}
Future<bool?> isRemember() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isRemember')??false;
}
Future<String?> getSessionTheme() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('themeMode')??"light";
}


Future<UserModel>getUser() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("userDetails===> ${prefs.getString('data')}");
  return UserModel.fromJson(jsonDecode(prefs.getString('data')!));
}
Future<ProjectModel>getSelectedProject() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("selected_project===> ${prefs.getString('selected_project')}");
  return ProjectModel.fromJson(jsonDecode(prefs.getString('selected_project')!));
}

setSelectedProject(data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('selected_project', jsonEncode(data));
  prefs.commit();
}


Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(prefSelectedLanguageCode, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
  print('languageCode ${systemLocales.first.languageCode}');
  String languageCode = _prefs.getString(prefSelectedLanguageCode) ?? systemLocales.first.languageCode;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
  return languageCode != null && languageCode.isNotEmpty
      ? Locale(languageCode, '')
      : Locale(systemLocales.first.languageCode, '');
}

void changeLanguage(BuildContext context, String selectedLanguageCode) async {
  var _locale = await setLocale(selectedLanguageCode);
  MyApp.setLocale(context, _locale);
}

