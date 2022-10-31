import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:open_file/open_file.dart';
import 'package:scms/globle/m/user_details.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../Dios/api_dio.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../Utils/tools.dart';
import '../../../globle/m/basic_response.dart';
import '../../../globle/m/error_response.dart';
import '../../../globle/m/project_model.dart';
import '../../../services/session_repo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../Trials/m/trials_response.dart';
import '../m/gallery_response.dart';
class GalleryController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Gallery>list=[];
  Project? selectedProject;
  bool isLoading = true;
  UserDetails? user;
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
    String filter=type==0?"photos":"videos";
    list.clear();
    isLoading=true;
    notifyListeners();
    _ListenerGetGalleries().then((value){
      LockOverlay().closeOverlay();
      List<Gallery>temp=value.list.where((element) => element.type==filter).toList();
      if(value.status){
        temp.forEach((element) async {
         String? fileName;
         if(type==1) {
           fileName = await VideoThumbnail.thumbnailFile(
               video: element.link.toString(),
               thumbnailPath: (await getTemporaryDirectory()).path,
         imageFormat: ImageFormat.WEBP,
         maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
         quality: 75,
         );
       }
         element.thumb=fileName;
         list.add(element);
       });
        isLoading=false;
        notifyListeners();
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError((e){
      isLoading=false;
      notifyListeners();
    });

  }
  void addEGallery(val,type) async {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerAddGallery(val).then((value){
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
        getGallery(type);
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError(onError);
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
    PostImage(path: path, fileName: name, folder_path: location).then((value){
      if(value.status){
        LockOverlay().closeOverlay();
        Map<String,dynamic> map =Map();
        map['type']=location;
        map['project_id']=selectedProject!.id;
        map['link']=value.file_path;
        addEGallery(map, type);
      }
    });

  }

  void onError(e){
    if (e is DioError) {
      ErrorResponse errorResponse=ErrorResponse.fromJson(e.response!.data['error']);
      Tools.ShowErrorMessage(scaffoldKey.currentContext, errorResponse.message);
    }
    LockOverlay().closeOverlay();
  }
  Future<GalleryResponse>_ListenerGetGalleries() async {
    var response =
    await httpClientWithHeaderToken(user!.token).get("galleries/${selectedProject!.id}");
    return GalleryResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerAddGallery(Map<String,dynamic> map) async {
    var response =
    await httpClientWithHeaderToken(user!.token).post("galleries",data: map);
    return BasicResponse.fromJson(response.data);
  }
}
