import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/ui/Equipment/m/shedule_response.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../services/project_model.dart';
import '../../../services/session_repo.dart';
import '../../Home/m/user_model.dart';
import '../m/delay_date.dart';
import '../m/equipment_response.dart';
class EquipmentController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  ProjectModel? selectedProject;
  bool isLoading = true;
  bool isDelayLoading = true;
  UserModel? user;
  List<EquipmentResponse>list=[];
  List<DelayDate>delay_list=[];
  List<DelayDate>performance_list=[];
  List<DelayDate>breackdown_list=[];
  List<SheduleResponse>schedule_list=[];
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  List<EquipmentBarchatDate>eq_list=[];
  EquipmentController(){
    getUser().then((value) {
      user = value;
    });
    getSelectedProject().then((value){
      selectedProject=value;

    });
  }


  void getEquipment() {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('EquipmentPerformance');
    ref_projectdetails.onValue.listen((event) {
      list.clear();
      for (final element in event.snapshot.children) {
        list.add(EquipmentResponse(key: element.key.toString(),
            name: element.child("name").value.toString()));
      }
      getDelayDate();
      isLoading=false;
      notifyListeners();
    });

  }
  void getDelayDate() {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('projectdetails/${selectedProject!.project}');
    ref_projectdetails.orderByChild('file_type').equalTo(2)
        .onValue.listen((event) {
      delay_list.clear();
      List<DateTime>date=[];
      for (final element in event.snapshot.children) {
        dynamic shotcrete_application_package = element.child("shotcrete_application_package").value;
        if (shotcrete_application_package) {
          Map<String, dynamic> map_a = getValue(element);
          if(map_a['shotcrete_application_package']!=null){
            Map<String, dynamic> map = map_a['shotcrete_application_package'];
            print(map);
            if(map['euipment_performance_push_key']!=null&&map['euipment_performance_date']!=null&&map['euipment_performance_date'].toString().isNotEmpty){
              if(map['volume']!=null){
                delay_list.add(DelayDate.fromJson(map));
                date.add(formatter.parse(map['euipment_performance_date']));
              }
            }
          }
        }
      }
      date.toSet().toList().forEach((da) {
        int index = 0;
        EquipmentBarchatDate barchatDate=EquipmentBarchatDate();
        list.forEach((eleme) {
          String push_key = eleme.key;
          DelayDate getDelayDate = getDelayDateFliter(formatter.format(da), push_key, delay_list);
          if(getDelayDate.volume!=0){
            print("getDelayDate.euipment_performance_date ${getDelayDate.euipment_performance_date}");
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
    });
  }

  DelayDate getDelayDateFliter(date,push,List<DelayDate>list){
    Map<String,dynamic>map=Map();
    map['volume']="0";
    map['equipment_number_of_hours']="0";
    DelayDate tem =DelayDate.fromJson(map);
    list.forEach((element) {
      print('MatchKey== ${element.euipment_performance_push_key} push $push volume ${element.volume}');
      print('MatchKey== ${element.euipment_performance_date} date $date volume ${element.volume}');
      if(element.euipment_performance_push_key==push&&element.euipment_performance_date==date){
        tem=element;
      }
    });
    return tem;
  }
  void getDelayDateSingle(EquipmentResponse response) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('projectdetails/${selectedProject!.project}');
    ref_projectdetails.orderByChild('file_type').equalTo(2)
        .onValue.listen((event) {
      performance_list.clear();
      breackdown_list.clear();
      for (final element in event.snapshot.children) {
        dynamic shotcrete_application_package = element.child("shotcrete_application_package").value;
        if (shotcrete_application_package) {
          Map<String, dynamic> map_a = getValue(element);
          if(map_a['shotcrete_application_package']!=null){
            Map<String, dynamic> map = map_a['shotcrete_application_package'];
            if(map['euipment_performance_push_key']!=null&&map['euipment_performance_date']!=null){
              if(map['euipment_performance_push_key']==response.key){
                if(map['euipment_performance_date'].toString().isNotEmpty){
                  if(map['volume']!=null&&map['volume'].toString().isNotEmpty){
                    performance_list.add(DelayDate.fromJson(map));
                  }
                  if(map['equipment_number_of_hours']!=null&&map['equipment_number_of_hours'].toString().isNotEmpty){
                    breackdown_list.add(DelayDate.fromJson(map));
                  }
                  }
            }
            }
          }
        }
      }
      performance_list.sort((a, b) => formatter.parse(a.euipment_performance_date).compareTo(formatter.parse(b.euipment_performance_date)));
      breackdown_list.sort((a, b) => formatter.parse(a.euipment_performance_date).compareTo(formatter.parse(b.euipment_performance_date)));
      isDelayLoading=false;
      notifyListeners();
    });

  }
  Map<String,dynamic>getValue(element){
    try {
      return jsonDecode(element.child("details").value.toString());
    } catch (e, s) {
      return {};
    }

  }
  void addEquipment(val) {
    Map<String,dynamic>map=Map();
    map['name']=val;
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('EquipmentPerformance');
    String key=ref_projectdetails.push().key.toString();
    ref_projectdetails.child(key).update(map);

  }
  void updateEquipment(key,val) {
    Map<String,dynamic>map=Map();
    map['name']=val;
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('EquipmentPerformance');
    ref_projectdetails.child(key).set(map);

  }
  void deleteEquipment(key) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('EquipmentPerformance').child(key);
    ref_projectdetails.remove();
    notifyListeners();

  }
  void deleteSchedule(type,key) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('ScheduleMaintenance/${selectedProject!.project}').child(key);
    ref_projectdetails.child(type==0?"Schedule":type==1?"Completed":"Reports").child(key).remove();
    notifyListeners();

  }

  void getShedule(int type) {
    isLoading=true;
    notifyListeners();
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('ScheduleMaintenance/${selectedProject!.project}');
    ref_projectdetails.child(type==0?"Schedule":type==1?"Completed":"Reports")
        .onValue
        .listen((event) {
      schedule_list.clear();
      for (final element in event.snapshot.children) {
        schedule_list.add(SheduleResponse(key: element.key.toString(),
          start_date: element.child("start_date").value.toString(),
          end_date: element.child("end_date").value.toString(),
          details: element.child("details").value.toString(),
        ));
      }
      isLoading=false;
      notifyListeners();
    });

  }
  Future<void> addFile(EquipmentResponse response,PlatformFile val) async {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    var ref = FirebaseStorage.instance.ref().child('Reports/${val.name}');
    ref.putFile(File(val.path!)).asStream().listen((event) {
      DatabaseReference ref_projectdetails =
      FirebaseDatabase.instance.ref('ScheduleMaintenance/${selectedProject!.project}/').child(response.key);
      String key=ref_projectdetails.push().key.toString();
      ref.getDownloadURL().then((value) {
        Map<String,dynamic>map=Map();
        map['link']=value.toString();
        map['file_name']='${val.name}';
        ref_projectdetails.child(key).update(map);
      });
      LockOverlay().closeOverlay();
    });

  }
  void resetSchedule(EquipmentResponse response) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('projectdetails/${selectedProject!.project}');
    ref_projectdetails.orderByChild('file_type').equalTo(2).onValue.listen((event) {
      for (final element in event.snapshot.children) {
        dynamic shotcrete_application_package = element.child("shotcrete_application_package").value;
        if (shotcrete_application_package) {
          Map<String, dynamic> map_a = getValue(element);
          if(map_a['shotcrete_application_package']!=null){
            Map<String, dynamic> map = map_a['shotcrete_application_package'];
            if(map['euipment_performance_push_key']!=null&&map['euipment_performance_date']!=null){
              if(map['euipment_performance_push_key']==response.key){
                map_a['shotcrete_application_package']['euipment_performance_date']="";
                map_a['shotcrete_application_package']['equipment_number_of_hours']="";
                DatabaseReference projectdetails =
                FirebaseDatabase.instance.ref('projectdetails/${selectedProject!.project}').child(element.key.toString());
                projectdetails.child('details').set(map_a);
              }
            }
          }
        }
      }
    });
    notifyListeners();
  }
  void addSchedule(type,val) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('ScheduleMaintenance/${selectedProject!.project}/')
        .child(type);
    String key=ref_projectdetails.push().key.toString();
    ref_projectdetails.child(key).update(val);

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