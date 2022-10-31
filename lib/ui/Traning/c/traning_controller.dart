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
import '../m/training_response.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class TraningController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Training>list=[];
  Project? selectedProject;
  bool isLoading = true;
  UserDetails? user;
  TraningController(){
    getUser().then((value) {
      user = value;
    });
    getSelectedProject().then((value){
      selectedProject=value;
      getTraining(0);
    });
  }

  void getTraining(int type) {
    _ListenerGetTesting().then((value){
      LockOverlay().closeOverlay();
      if(value.status){
        list=value.list.where((element) => element.type.toString()==type.toString()).toList();
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


  void deleteTraining(key,type) {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerDeleteTesting(key).then((value){
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
        getTraining(type);
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError((e){
      LockOverlay().closeOverlay();
    });
  }
  Future<void> downloadFile(Training res_file) async {
    if(res_file.link==null){
      Tools.ShowErrorMessage(scaffoldKey.currentContext!, 'File not found');
      return;
    }
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
      externalStorageDirPath = "storage/emulated/0/Download/";
    } else if (Platform.isIOS) {
      externalStorageDirPath = (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }
  Future<void> addFile(PlatformFile val,int type) async {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    PostImage(path: val.path, fileName: val.name, folder_path: "Testings").then((value){
      if(value.status){
        Map<String,dynamic>map=Map();
        map['link']=value.file_path;
        map['file_name']='${val.name}';
        map['type']='$type';
        map['project_id']=selectedProject!.id;
        addTexting(map,type);
      }
    });


  }
  void addTexting(val,type) async {
    _ListenerAddTesting(val).then((value){
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
        getTraining(type);
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError((e){
      LockOverlay().closeOverlay();
    });
  }
  Future<TrainingResponse>_ListenerGetTesting() async {
    var response =
    await httpClientWithHeaderToken(user!.token).get("trainings/${selectedProject!.id}");
    return TrainingResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerAddTesting(Map<String,dynamic> map) async {
    var response =
    await httpClientWithHeaderToken(user!.token).post("trainings",data: map);
    return BasicResponse.fromJson(response.data);
  }Future<BasicResponse>_ListenerDeleteTesting(id) async {
    var response =
    await httpClientWithHeaderToken(user!.token).delete("trainings/$id");
    return BasicResponse.fromJson(response.data);
  }
}
