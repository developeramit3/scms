import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/globle/m/basic_response.dart';
import 'package:scms/globle/m/project_model.dart';
import 'package:scms/services/session_repo.dart';
import '../../../Dios/api_dio.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../Utils/tools.dart';
import '../../../globle/m/error_response.dart';
import '../../../globle/m/user_details.dart';
class ProjectListController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();
  ProjectModel? projectModel;
  UserDetails? userDetails;
  var project_real_name = TextEditingController();
  var project_total_volume = TextEditingController();
  var project_total_wastage = TextEditingController();
  var was_per = TextEditingController();
  ProjectListController(){
    getUser().then((value){
      userDetails=value;
      notifyListeners();
    });
   projectList();
  }
  void projectList() async {
    _ListenerList().then((value){
      projectModel=value;
      LockOverlay().closeOverlay();
      notifyListeners();
    }).catchError(onError);
  }
  void addProject(Project project) async {
    FocusScope.of(scaffoldKey.currentContext!).unfocus();
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerAddProject(project).then((value){
      projectList();
    }).catchError(onError);
  }
  void deleteProject(Project project) async {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerDeleteProject(project).then((value){
      projectList();
    }).catchError(onError);
  }
  Future<ProjectModel>_ListenerList() async {
    var response =
    await httpClientWithHeaderToken(await getToken()).get("projects");
    return ProjectModel.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerAddProject(Project project) async {
    project.user_id=userDetails!.user_id;
    var response =
    await httpClientWithHeaderToken(await getToken()).post("projects",data: project.toMap());
    return BasicResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerDeleteProject(Project project) async {
    var response =
    await httpClientWithHeaderToken(await getToken()).delete("projects/${project.id}");
    return BasicResponse.fromJson(response.data);
  }
  void onError(e){
    if (e is DioError) {
      if(e.response!.data is Map) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(e.response!.data);
        Tools.ShowErrorMessage(
            scaffoldKey.currentContext, errorResponse.message);
      }else{
        Tools.ShowErrorMessage(
            scaffoldKey.currentContext, "Something went wrong");
      }
    }
    LockOverlay().closeOverlay();
  }

 }
