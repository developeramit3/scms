import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/globle/m/user_details.dart';
import 'package:scms/services/session_repo.dart';
import '../../../Dios/api_dio.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../Utils/tools.dart';
import '../../../globle/m/basic_response.dart';
import '../../../globle/m/error_response.dart';
import '../../../globle/m/project_model.dart';
import '../../Task/m/task_details_model.dart';
import '../../Task/m/task_response.dart';
import '../m/delay_response.dart';

class HomeController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  DelayResponse? delayResponse;
  UserDetails? user;
  Project? projectResponse;
  double dump_volume=0;
  HomeController() {
    getUser().then((value) {
      user = value;
    });
    getSelectedProject().then((value){
      projectResponse=value;
      getDelay();
      notifyListeners();
    });
  }

  void getProjectDetails() {
    _ListenerList().then((value){
      projectResponse=value;
      notifyListeners();
    });
  }
  Future<Project>_ListenerList() async {
    var response =
    await httpClientWithHeaderToken(await getToken()).get("projects/${projectResponse!.id}");
    return Project.fromJson(response.data['data']);
  }
  void getDelay() {
    _ListenerDelay().then((value){
      delayResponse=value;
      notifyListeners();
    }).catchError((e){
      delayResponse=DelayResponse.fromJson({});
      notifyListeners();
    });
  }
  Future<DelayResponse>_ListenerDelay() async {
    var response =
    await httpClientWithHeaderToken(await getToken()).get("delays/${projectResponse!.id}");
    return DelayResponse.fromJson(response.data);
  }
  void postValDay(String val) {
    projectResponse!.volume_complete_day = val;
    _ListenerUpdateProject(projectResponse!).then((value){
      getProjectDetails();
    });
  }
  void updateProject() {
    _ListenerUpdateProject(projectResponse!).then((value){
      getProjectDetails();
    });
  }
  Future<BasicResponse>_ListenerUpdateProject(Project project) async {
    var response =
    await httpClientWithHeaderToken(await getToken()).put("projects/${project.id}",data: project.toMap());
    return BasicResponse.fromJson(response.data);
  }
  void reset() {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    projectResponse!.volume_complete_day = "0";
    projectResponse!.volume = "0";
    projectResponse!.start_day = Tools.getCurrentDate();
    updateProject();
   /*
    DatabaseReference ref_Delay =
        FirebaseDatabase.instance.ref('Delay/selectedProject');
    DatabaseReference ref_projectdetails =
        FirebaseDatabase.instance.ref('projectdetails/selectedProject');
    ref_Delay.remove();
    getDelay();
    dump_volume=0;
    ref_projectdetails
        .orderByChild('file_type')
        .equalTo(2)
        .onValue
        .listen((event) {
      for (final element in event.snapshot.children) {
        String key = element.key.toString();
        dynamic shotcrete_application_package =
            element.child("shotcrete_application_package").value;
        if (shotcrete_application_package) {
          Map<String, dynamic> map_a = getValue(element);
          Map<String, dynamic> map = map_a['shotcrete_application_package']!=null?map_a['shotcrete_application_package']:Map();
          map['volume'] = "0";
          map['dump_volume'] = "0";
          map['euipment_performance_date'] = "";
          ref_projectdetails.child(key).child('details').set(map.toString());

        }
      }
    });*/
  }
  void getDumvalue() {
    dump_volume=0;
    _ListenerProjectDetailsList().then((value){
      List<TaskList>list=value.list.where((element) => element.file_type=="2").toList();
      list.forEach((element) {
        if(element.shotcrete_application_package.toString()=="1"&&element.details!=null){
          SoftcutApplicationModel short= element.details!.shotcrete_application_package;
          if(short.dump_volume!=null){
            double volume = double.tryParse(short.dump_volume)??0;
            dump_volume = dump_volume + volume;
          }
        }
      });
    }).catchError(onError);
  }
  Future<TaskResponse>_ListenerProjectDetailsList() async {
    var response =
    await httpClientWithHeaderToken(await getToken()).get("project-details/${projectResponse!.id}");
    return TaskResponse.fromJson(response.data);
  }

  void onError(e){
    if (e is DioError) {
      ErrorResponse errorResponse=ErrorResponse.fromJson(e.response!.data);
      Tools.ShowErrorMessage(scaffoldKey.currentContext, errorResponse.message);
    }
    LockOverlay().closeOverlay();
  }
}
