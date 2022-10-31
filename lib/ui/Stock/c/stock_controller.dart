import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/globle/m/user_details.dart';
import '../../../Dios/api_dio.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../Utils/tools.dart';
import '../../../globle/m/basic_response.dart';
import '../../../globle/m/error_response.dart';
import '../../../globle/m/project_model.dart';
import '../../../services/session_repo.dart';
import '../m/material_response.dart';

class StockController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Materialll? materialResponse;
  Project? selectedProject;
  bool isLoading = true;
  UserDetails? user;
  StockController(){
    getUser().then((value) {
      user = value;
    });
    getSelectedProject().then((value){
      selectedProject=value;
      getMaterial(0);
    });
  }

  void getMaterial(int type) {
    String filter=type==0?"Usage":"Stock";
    _ListenerGetMaterial().then((value){
      LockOverlay().closeOverlay();
      if(value.status){
        materialResponse=value.list.where((element) => element.type==filter).first;
        isLoading=false;
        notifyListeners();
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError((e){
      isLoading=false;
      materialResponse=Materialll.fromJson({});
      notifyListeners();
    });

  }
  void resetMaterial() {
    materialResponse!.accelerator="0";
    materialResponse!.fiber_1="0";
    materialResponse!.fiber_2="0";
    materialResponse!.hsc="0";
    materialResponse!.super_plaster_size="0";
    updateMaterial(materialResponse);
  }

  void addMaterial(Materialll ml) {
    ml.type="Stock";
    ml.project_id=selectedProject!.id;
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerAddMaterial(ml).then((value){
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
        getMaterial(1);
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError(onError);
  }
  void updateMaterial(val) {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerUpdateMaterial(val).then((value){
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
        getMaterial(1);
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError(onError);
  }
  Future<MaterialResponse>_ListenerGetMaterial() async {
    var response =
    await httpClientWithHeaderToken(user!.token).get("materials/${selectedProject!.id}");
    return MaterialResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerAddMaterial(Materialll map) async {
    var response =
    await httpClientWithHeaderToken(user!.token).post("materials",data: map.toJson());
    return BasicResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerUpdateMaterial(Materialll mm) async {
    var response =
    await httpClientWithHeaderToken(user!.token).put("materials/${mm.id}",data: mm.toJson());
    return BasicResponse.fromJson(response.data);
  }
  void onError(e){
    LockOverlay().closeOverlay();
    if (e is DioError) {
      ErrorResponse errorResponse=ErrorResponse.fromJson(e.response!.data);
      Tools.ShowErrorMessage(scaffoldKey.currentContext, errorResponse.message);
    }

  }
}
