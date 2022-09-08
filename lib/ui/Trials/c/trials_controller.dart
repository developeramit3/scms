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
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../m/trials_response.dart';
class TrialsController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<TrialsResponse>list=[];
  ProjectModel? selectedProject;
  bool isLoading = true;
  UserModel? user;
  TrialsController(){
    getUser().then((value) {
      user = value;
    });
    getSelectedProject().then((value){
      selectedProject=value;
      getTrails(0);
    });
  }

  void getTrails(int type) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('Trails/${selectedProject!.project}');
    ref_projectdetails.child(type==0?"Schedule":type==1?"Completed":"Results")
        .onValue
        .listen((event) {
      list.clear();
      for (final element in event.snapshot.children) {
        list.add(TrialsResponse(key: element.key.toString(),
          start_date: element.child("start_date").value.toString(),
          end_date: element.child("end_date").value.toString(),
          details: element.child("details").value.toString(),
          filename: element.child("filename").value.toString(),
          link: element.child("link").value.toString(),
        ));
      }
      isLoading=false;
      notifyListeners();
    });

  }

  void addTrials(type,val) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('Trails/${selectedProject!.project}/')
        .child(type);
    String key=ref_projectdetails.push().key.toString();
    ref_projectdetails.child(key).update(val);

  }
  void deleteTrials(type,key) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('Trails/${selectedProject!.project}/')
        .child(type==0?"Schedule":type==1?"Completed":"Results").child(key);
    ref_projectdetails.remove();
    notifyListeners();

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
  Future<void> addFile(TrialsResponse response,PlatformFile val) async {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    var ref = FirebaseStorage.instance.ref().child('Trails/${val.name}');
    ref.putFile(File(val.path!)).asStream().listen((event) {
      DatabaseReference ref_projectdetails =
      FirebaseDatabase.instance.ref('Trails/${selectedProject!.project}/').child("Results");
      String key=ref_projectdetails.push().key.toString();
      ref.getDownloadURL().then((value) {
        Map<String,dynamic>map=Map();
        map['start_date']=response.start_date;
        map['end_date']=response.end_date;
        map['details']=response.details;
        map['link']=value.toString();
        map['filename']='${val.name}';
        ref_projectdetails.child(key).update(map);
      });
      LockOverlay().closeOverlay();
    });

  }
  Future<void> downloadFile(TrialsResponse res_file) async {
    print('link==> ${res_file.link}');
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    var uri=Uri.parse(res_file.link);
    var data = await http.get(uri);
    final output = await prepareSaveDir();
    final file = File('${output}/${res_file.filename}');
    print('FilePath ${file.path}');
    if(!file.existsSync()) {
      await file.writeAsBytes(data.bodyBytes);
    }
    LockOverlay().closeOverlay();
    OpenFile.open(file.path);
  }
}
