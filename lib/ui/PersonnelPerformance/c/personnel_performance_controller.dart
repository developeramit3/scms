import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/services/session_repo.dart';
import '../../../Dios/api_dio.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../Utils/tools.dart';
import '../../../globle/m/basic_response.dart';
import '../../../globle/m/error_response.dart';
import '../../../globle/m/project_model.dart';
import '../../../globle/m/user_details.dart';
import '../../Task/m/task_details_model.dart';
import '../../Task/m/task_response.dart';
import '../m/performance_response.dart';

class PersonnelPerformanceController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  PerformanceResponse? performanceResponse;
  double totalVolume=0;
  Project? selectedProject;
  String id="";
  UserDetails? userDetails;
  bool isLoading=true;
  PersonnelPerformanceController(){
    getSelectedProject().then((value){
      selectedProject=value;
      getValue();
    });
    getUser().then((value){
      userDetails=value;
      notifyListeners();
    });
  }
  void PersonalPerformancesList() async {
    _ListenerList().then((value){
      performanceResponse=value;
      LockOverlay().closeOverlay();
      notifyListeners();
    }).catchError(onError);
  }
  void deletePerformance(Performance performance) async {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerDelete(performance).then((value){
      PersonalPerformancesList();
    }).catchError(onError);
  }

  void addPerformance(Map<String,dynamic>map) async {
    FocusScope.of(scaffoldKey.currentContext!).unfocus();
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerAdd(map).then((value){
      Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
    }).catchError(onError);
  }
  void updatePerformance(Map<String,dynamic>map) async {
    FocusScope.of(scaffoldKey.currentContext!).unfocus();
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerUpdate(map).then((value){
      PersonalPerformancesList();
    }).catchError(onError);
  }
  Future<BasicResponse>_ListenerAdd(Map<String,dynamic>map) async {
    var response =
    await httpClientWithHeaderToken(await getToken()).post("personal-performances",data: map);
    return BasicResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerUpdate(Map<String,dynamic>map) async {
    var response =
    await httpClientWithHeaderToken(await getToken()).put("personal-performances/${map['id']}",data: map);
    return BasicResponse.fromJson(response.data);
  }
  Future<PerformanceResponse>_ListenerList() async {
    var response =
    await httpClientWithHeaderToken(await getToken()).get("personal-performances");
    return PerformanceResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerDelete(Performance performance) async {
    var response =
    await httpClientWithHeaderToken(await getToken()).delete("personal-performances/${performance.id}");
    return BasicResponse.fromJson(response.data);
  }
  void onError(e){
    if (e is DioError) {
      ErrorResponse errorResponse=ErrorResponse.fromJson(e.response!.data);
      Tools.ShowErrorMessage(Tools.navigatorKey.currentContext, errorResponse.message);
    }
    LockOverlay().closeOverlay();
  }

  void getValue() {
    _ListenerTaskList().then((value){
      if(value.status){
        isLoading=false;
        List<TaskList> taskList=value.list.where((element) => element.file_type=="2").toList();
        taskList.forEach((element) {
          if(element.shotcrete_application_package.toString()=="1"){
            SoftcutApplicationModel shotcrete_application_package=element.details!.shotcrete_application_package;
            if(shotcrete_application_package.name_id_nozzleman.toString()==id && shotcrete_application_package.volume!=null){
              double volume = double.tryParse(shotcrete_application_package.volume)??0;
              totalVolume = totalVolume + volume;
            }
          }
        });
        notifyListeners();
      }
    }).catchError(onError);

  }

  void reset() {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerTaskList().then((value){
      if(value.status){
        List<TaskList> taskList=value.list.where((element) => element.file_type=="2").toList();
        taskList.forEach((element) {
          if(element.shotcrete_application_package.toString()=="1"){
            SoftcutApplicationModel shotcrete_application_package=element.details!.shotcrete_application_package;
            if(shotcrete_application_package.name_id_nozzleman==id){
              shotcrete_application_package.volume="0";
              updateTask(element);
            }
          }
        });
        notifyListeners();
      }
    }).catchError(onError);

  }
  Future<TaskResponse>_ListenerTaskList() async {
    var response =
    await httpClientWithHeaderToken(await getToken()).get("project-details/${selectedProject!.id}");
    return TaskResponse.fromJson(response.data);
  }
  void updateTask(TaskList data) {
    Map<String,dynamic>map=Map();
    map['details']=jsonEncode(data.details!.toMap());
    map['file_type']=data.file_type;
    _ListenerUpdateTask(map,data.id).then((value){
    }).catchError(onError);
  }
  Future<BasicResponse>_ListenerUpdateTask(Map<String,dynamic>map,id) async {
    var response =
    await httpClientWithHeaderToken(await getToken()).put("project-details/${id}",data: map);
    return BasicResponse.fromJson(response.data);
  }
}
