import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:open_file/open_file.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../services/project_model.dart';
import '../../../services/session_repo.dart';
import '../../Home/m/user_model.dart';
import '../m/training_response.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class TraningController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<TrainingResponse>list=[];
  ProjectModel? selectedProject;
  bool isLoading = true;
  UserModel? user;
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
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('Testings/${selectedProject!.project}');
    ref_projectdetails.child(type==0?"modules":"exam")
        .onValue
        .listen((event) {
      list.clear();
      for (final element in event.snapshot.children) {
        list.add(TrainingResponse(key: element.key.toString(),
          file_name: element.child("file_name").value.toString(),
          link: element.child("link").value.toString(),
        ));
      }
      isLoading=false;
      notifyListeners();
    });

  }


  void deleteTraining(key) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('Testings/${selectedProject!.project}/$key');
    ref_projectdetails.remove();

  }
  Future<void> downloadFile(TrainingResponse res_file) async {
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
      // final directory = await getExternalStorageDirectory();
      // externalStorageDirPath = directory?.path;
      externalStorageDirPath = "storage/emulated/0/Download/";
    } else if (Platform.isIOS) {
      externalStorageDirPath = (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }
  Future<void> addFile(PlatformFile val,int type) async {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    var ref = FirebaseStorage.instance.ref().child('Testings/${val.name}');
    ref.putFile(File(val.path!)).asStream().listen((event) {
      DatabaseReference ref_projectdetails =
      FirebaseDatabase.instance.ref('Testings/${selectedProject!.project}/').child(type==0?"modules":"exam");
      String key=ref_projectdetails.push().key.toString();
      ref.getDownloadURL().then((value) {
        Map<String,dynamic>map=Map();
        map['link']=ref.getDownloadURL().toString();
        map['file_name']='${val.name}';
        ref_projectdetails.child(key).update(map);
      });

      LockOverlay().closeOverlay();
    });

  }
}
