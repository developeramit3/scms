import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:open_file/open_file.dart';
import 'package:scms/globle/m/user_details.dart';
import '../../../Dios/api_dio.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../Utils/tools.dart';
import '../../../globle/m/basic_response.dart';
import '../../../globle/m/project_model.dart';
import '../../../services/session_repo.dart';
import '../../Home/m/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../m/trials_response.dart';
class TrialsController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Trials>list=[];
  List<Trials>Oldlist=[];
  Project? selectedProject;
  bool isLoading = true;
  UserDetails? user;
  TrialsController(){
    getUser().then((value) {
      user = value;
    });
    getSelectedProject().then((value){
      selectedProject=value;
      Refresh(0);
    });
  }
void Refresh(int type){
    if(Oldlist.length>0){
      list=Oldlist.where((element) => element.type.toString()==type.toString()).toList();
      notifyListeners();
    }else{
      getTrails(type);
    }
}
  void getTrails(int type) {
    _ListenerGetTrails().then((value){
      LockOverlay().closeOverlay();
      if(value.status){
        Oldlist=value.list;
        Refresh(type);
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
      isLoading=false;
      notifyListeners();
    }).catchError((e){
      LockOverlay().closeOverlay();
      isLoading=false;
      notifyListeners();
    });

  }

  void addTrials(val) {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerAddTrails(val).then((value){
      if(value.status){
        getTrails(val['type']);
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError((e){
      print("error==>$e");
      LockOverlay().closeOverlay();
    });
  }
  void updateTrials(type,val) {
    _ListenerUpdateTrails(val).then((value){
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
        getTrails(type);
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError((e){
      LockOverlay().closeOverlay();
    });
  }
  void deleteTrials(type,key) {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerDeleteTrails(key).then((value){
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
        getTrails(type);
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError((e){
      LockOverlay().closeOverlay();
    });
  }

  Future<String> prepareSaveDir() async {
    String _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    return _localPath;
  }
  Future<String?> _findLocalPath() async {
    var externalStorageDirPath;
    if (Platform.isAndroid) {
      // final directory = await getExternalStorageDirectory();
      // externalStorageDirPath = directory?.path;
      externalStorageDirPath = "storage/emulated/0/Download/";
    } else if (Platform.isIOS) {
      externalStorageDirPath = (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }
  Future<void> addFile(Trials response,PlatformFile val,type) async {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    PostImage(path: val.path, fileName: val.name, folder_path: "Results").then((value){
      if(value.status){
        response.file_name=val.name;
        response.link=value.file_path;
        response.type="2";
        updateTrials(type,response);
      }
    });
  }
  Future<void> downloadFile(Trials res_file) async {
    print('link==> ${res_file.link}');
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    var uri=Uri.parse(res_file.link);
    var data = await http.get(uri);
    final output = await prepareSaveDir();
    final file = File('${output}/${res_file.file_name}');
    print('FilePath ${file.path}');
    if(!file.existsSync()) {
      await file.writeAsBytes(data.bodyBytes);
    }
    LockOverlay().closeOverlay();
    OpenFile.open(file.path);
  }
  Future<TrialsResponse>_ListenerGetTrails() async {
    var response =
    await httpClientWithHeaderToken(user!.token).get("trails/${selectedProject!.id}");
    return TrialsResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerDeleteTrails(id) async {
    var response =
    await httpClientWithHeaderToken(user!.token).delete("trails/$id");
    return BasicResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerAddTrails(Map<String,dynamic> map) async {
    map['project_id']=selectedProject!.id;
    var response =
    await httpClientWithHeaderToken(user!.token).post("trails",data: map);
    return BasicResponse.fromJson(response.data);
  }Future<BasicResponse>_ListenerUpdateTrails(Trials trials) async {
    var response =
    await httpClientWithHeaderToken(user!.token).put("trails/${trials.id}",data: trials.toJson());
    return BasicResponse.fromJson(response.data);
  }
}
