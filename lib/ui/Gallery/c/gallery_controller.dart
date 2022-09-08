import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:open_file/open_file.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../services/project_model.dart';
import '../../../services/session_repo.dart';
import '../../Home/m/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../Trials/m/trials_response.dart';
import '../m/gallery_response.dart';
class GalleryController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<GalleryResponse>list=[];
  ProjectModel? selectedProject;
  bool isLoading = true;
  UserModel? user;
  XFile? image;
  GalleryController(){
    getUser().then((value) {
      user = value;
    });
    getSelectedProject().then((value){
      selectedProject=value;
      getGallery(0);
    });
  }

  void getGallery(int type) {
    list.clear();
    isLoading=true;
    notifyListeners();
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('Gallery/${selectedProject!.project}');
    ref_projectdetails.child(type==0?"photos":"videos")
        .onValue
        .listen((event) async {
      list.clear();
      for (final element in event.snapshot.children) {
        String? fileName;
        if(type==1) {
           fileName = await VideoThumbnail.thumbnailFile(
            video: element.child("link").value.toString(),
            thumbnailPath: (await getTemporaryDirectory()).path,
            imageFormat: ImageFormat.WEBP,
            maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
            quality: 75,
          );
        }
        list.add(GalleryResponse(key: element.key.toString(),
          user_type: element.child("user_type").value.toString(),
          link:element.child("link").value.toString(),
            thumb: fileName
        ));
      }
      isLoading=false;
      notifyListeners();
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
  Future<void> addFile({required String path,required String name, required int type}) async {
    String location=type==0?'photos':'videos';
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    var ref = FirebaseStorage.instance.ref().child('$location/${name}');
    ref.putFile(File(path)).asStream().listen((event) {
      DatabaseReference ref_projectdetails =
      FirebaseDatabase.instance.ref('Gallery/${selectedProject!.project}/${location}/');
      String key=ref_projectdetails.push().key.toString();
      ref.getDownloadURL().then((value) {
        Map<String,dynamic>map=Map();
        map['link']=value.toString();
        map['user_type']=user!.user_type;
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
