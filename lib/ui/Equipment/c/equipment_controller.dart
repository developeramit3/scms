import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/globle/m/user_details.dart';
import 'package:scms/ui/Equipment/m/shedule_response.dart';
import '../../../Dios/api_dio.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../Utils/tools.dart';
import '../../../globle/m/basic_response.dart';
import '../../../globle/m/error_response.dart';
import '../../../globle/m/project_model.dart';
import '../../../services/session_repo.dart';
import '../../Task/m/task_details_model.dart';
import '../../Task/m/task_response.dart';
import '../m/delay_date.dart';
import '../m/equipment_response.dart';
class EquipmentController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Project? selectedProject;
  bool isLoading = true;
  bool isDelayLoading = true;
  UserDetails? user;
  EquipmentResponse? equipmentResponse;
  List<DelayDate>delay_list=[];
  List<DelayDate>performance_list=[];
  List<DelayDate>breackdown_list=[];
  List<Shedule>schedule_list=[];
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  List<EquipmentBarchatDate>eq_list=[];
  EquipmentController(){
    getUser().then((value) {
      user = value;
    });
    getSelectedProject().then((value){
      selectedProject=value;
      getEquipment();
    });
  }
//=============================
  void addEquipment(val) async {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerAddEquipment(val).then((value){
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
        getEquipment();
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError(onError);
  }
  void deleteEquipment(val) async {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerDeleteEquipment(val).then((value){
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
        getEquipment();
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError(onError);
  }
  void updateEquipment(id,val) async {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerUpdateEquipment(id,val).then((value){
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
        getEquipment();
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError(onError);
  }
  void getEquipment() async {
    _ListenerGetEquipment().then((value){
      LockOverlay().closeOverlay();
      if(value.status){
        equipmentResponse=value;
        notifyListeners();
       getDelayDate();
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError(onError);
  }

  Future<BasicResponse>_ListenerAddEquipment(val) async {
    Map<String,dynamic> map=Map();
    map["user_id"]=user!.user_id.toString();
    map["name"]=val;
    var response =
    await httpClientWithHeaderToken(user!.token).post("equiment-performances",data: map);
    return BasicResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerUpdateEquipment(id,val) async {
    Map<String,dynamic> map=Map();
    map["name"]=val;
    var response =
    await httpClientWithHeaderToken(user!.token).put("equiment-performances/$id",data: map);
    return BasicResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerDeleteEquipment(val) async {
    var response =
    await httpClientWithHeaderToken(user!.token).delete("equiment-performances/$val");
    return BasicResponse.fromJson(response.data);
  }
  Future<EquipmentResponse>_ListenerGetEquipment() async {
    var response =
    await httpClientWithHeaderToken(user!.token).get("equiment-performances");
    return EquipmentResponse.fromJson(response.data);
  }
  void onError(e){
    if (e is DioError) {
      ErrorResponse errorResponse=ErrorResponse.fromJson(e.response!.data['error']);
      Tools.ShowErrorMessage(scaffoldKey.currentContext, errorResponse.message);
    }
    LockOverlay().closeOverlay();
  }
//=============================


  void getDelayDate() {
    _ListenerTaskList().then((value){
      if(value.status){
        delay_list.clear();
        List<DateTime>date=[];
       List<TaskList> taskList=value.list.where((element) => element.file_type=="2").toList();
       taskList.forEach((element) {
         if(element.shotcrete_application_package.toString()=="1"){
           if(element.details!.shotcrete_application_package.euipment_performance_push_key!=null&&element.details!.shotcrete_application_package.euipment_performance_date!=null){
             delay_list.add(DelayDate.fromJson(element.details!.shotcrete_application_package.toMap()));
             date.add(formatter.parse(element.details!.shotcrete_application_package.euipment_performance_date));
           }
         }
       });
        date.sort((a, b) => a.compareTo(b));
        date.forEach((da) {
          int index = 0;
          EquipmentBarchatDate barchatDate=EquipmentBarchatDate();
          equipmentResponse!.list.forEach((eleme) {
            DelayDate getDelayDate = getDelayDateFliter(formatter.format(da), eleme.id, delay_list);
            if(getDelayDate.volume!=0){
              barchatDate.date=getDelayDate.euipment_performance_date;
              if(index==0){
                barchatDate.name1=eleme.name;
                barchatDate.delay1=getDelayDate.volume;
              }if(index==1){
                barchatDate.name2=eleme.name;
                barchatDate.delay2=getDelayDate.volume;
              }if(index==2){
                barchatDate.name3=eleme.name;
                barchatDate.delay3=getDelayDate.volume;
              }if(index==3){
                barchatDate.name4=eleme.name;
                barchatDate.delay4=getDelayDate.volume;
              }if(index==4){
                barchatDate.name5=eleme.name;
                barchatDate.delay5=getDelayDate.volume;
              }
            }
            index = index + 1;
          });
          eq_list.add(barchatDate);

        });
        isDelayLoading=false;
        notifyListeners();
      }
    }).catchError(onError);

  }
  Future<TaskResponse>_ListenerTaskList() async {
    var response =
    await httpClientWithHeaderToken(await getToken()).get("project-details/${selectedProject!.id}");
    return TaskResponse.fromJson(response.data);
  }
  DelayDate getDelayDateFliter(date,push,List<DelayDate>list){
    Map<String,dynamic>map=Map();
    map['volume']="0";
    map['equipment_number_of_hours']="0";
    DelayDate tem =DelayDate.fromJson(map);
    list.forEach((element) {
      if(element.euipment_performance_push_key==push&&element.euipment_performance_date==date){
        tem=element;
      }
    });
    return tem;
  }
  void getDelayDateSingle(Equipment response) {
    _ListenerTaskList().then((value){
      if(value.status){
        performance_list.clear();
        breackdown_list.clear();
        List<TaskList> taskList=value.list.where((element) => element.file_type=="2").toList();
        taskList.forEach((element) {
          if(element.shotcrete_application_package.toString()=="1"){
            SoftcutApplicationModel shotcrete_application_package=element.details!.shotcrete_application_package;
            print("come===1");
            if(shotcrete_application_package.euipment_performance_push_key!=null&&shotcrete_application_package.euipment_performance_date!=null){
              print("come===2 ${shotcrete_application_package.euipment_performance_push_key}===${response.id}");
              if(shotcrete_application_package.euipment_performance_push_key==response.id){
                print("come===3");
                if(shotcrete_application_package.euipment_performance_date.toString().isNotEmpty){
                 print("come===4");
                 if(shotcrete_application_package.volume!=null&&shotcrete_application_package.volume.toString().isNotEmpty){
                   print("come===5");
                   performance_list.add(DelayDate.fromJson(shotcrete_application_package.toMap()));
                 }
                 if(shotcrete_application_package.equipment_number_of_hours!=null&&shotcrete_application_package.equipment_number_of_hours.toString().isNotEmpty){
                   breackdown_list.add(DelayDate.fromJson(shotcrete_application_package.toMap()));
                 }
               }
             }

            }
          }
        });
        performance_list.sort((a, b) => formatter.parse(a.euipment_performance_date).compareTo(formatter.parse(b.euipment_performance_date)));
        breackdown_list.sort((a, b) => formatter.parse(a.euipment_performance_date).compareTo(formatter.parse(b.euipment_performance_date)));
        isDelayLoading=false;
        notifyListeners();
      }
    }).catchError(onError);


  }


  void deleteSchedule(type,key) {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerDeleteShedule(key).then((value){
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
        getShedule(type);
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError(onError);
  }

  void getShedule(String type) {
    isLoading=true;
    notifyListeners();
    _ListenerGetShedule().then((value){
      LockOverlay().closeOverlay();
      if(value.status){
        schedule_list=value.list.where((element) => element.type.toString()==type.toString()).toList();
        isLoading=false;
        notifyListeners();
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError(onError);
    

  }
  Future<void> addFile(Equipment eqq,PlatformFile val) async {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    PostImage(path: val.path,fileName: val.name,folder_path: "Reports").then((value){
      if(value.status){
        LockOverlay().closeOverlay();
        Map<String,dynamic>map=Map();
        map['link']=value.toString();
        map['file_name']='${val.name}';
        addSchedule(map);
      }
    });
  }
  void resetSchedule(Equipment response) {
    _ListenerTaskList().then((value){
      if(value.status){
        List<TaskList> taskList=value.list.where((element) => element.file_type=="2").toList();
        taskList.forEach((element) {
          if(element.shotcrete_application_package.toString()=="1"){
            SoftcutApplicationModel shotcrete_application_package=element.details!.shotcrete_application_package;
            if(shotcrete_application_package.euipment_performance_push_key!=null&&shotcrete_application_package.euipment_performance_date!=null){
              if(shotcrete_application_package.euipment_performance_push_key==response.id){
                shotcrete_application_package.euipment_performance_date="";
                shotcrete_application_package.equipment_number_of_hours="";
                updateTask(element);
              }
            }
          }
        });
        isDelayLoading=false;
        notifyListeners();
      }
    }).catchError(onError);
    notifyListeners();
  }
  void updateTask(TaskList task) {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerUpdateTask(task).then((value){
      LockOverlay().closeOverlay();
    }).catchError(onError);
  }
  Future<BasicResponse>_ListenerUpdateTask(TaskList task) async {
    Map<String,dynamic>map=Map();
    map['details']=jsonEncode(task.details!.toMap());
    map['file_type']=1;
    var response =
    await httpClientWithHeaderToken(await getToken()).put("project-details/${task.id}",data: map);
    return BasicResponse.fromJson(response.data);
  }

  void addSchedule(val) {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerAddShedule(val).then((value){
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
        getShedule(val['type']);
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError(onError);
  }
  void updateSchedule(Shedule qq) {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerUpdateShedule(qq).then((value){
      LockOverlay().closeOverlay();
    }).catchError(onError);
  }
  Future<BasicResponse>_ListenerAddShedule(val) async {
    val["project_id"]=selectedProject!.id;
    var response =
    await httpClientWithHeaderToken(user!.token).post("schedule-maintenance",data: val);
    return BasicResponse.fromJson(response.data);
  }
  Future<SheduleResponse>_ListenerGetShedule() async {
    var response =
    await httpClientWithHeaderToken(user!.token).get("schedule-maintenance/${selectedProject!.id}");
    return SheduleResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerDeleteShedule(val) async {
    var response =
    await httpClientWithHeaderToken(user!.token).delete("schedule-maintenance/$val");
    return BasicResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerUpdateShedule(Shedule qq) async {
    var response =
    await httpClientWithHeaderToken(await getToken()).put("schedule-maintenance/${qq.id}",data: qq.toJson());
    return BasicResponse.fromJson(response.data);
  }
}
class EquipmentBarchatDate{
  String? date;
  List<double>?list;
  String? name1;
  String? name2;
  String? name3;
  String? name4;
  String? name5;
  dynamic delay1;
  dynamic delay2;
  dynamic delay3;
  dynamic delay4;
  dynamic delay5;
  EquipmentBarchatDate({this.date,this.name1,this.name2,this.name3,this.name4,this.name5,this.delay1,this.delay2,this.delay3,this.delay4,this.delay5,this.list});
}
class BarChartDate{
  String date;
  double value;
  BarChartDate(this.date,this.value);
}