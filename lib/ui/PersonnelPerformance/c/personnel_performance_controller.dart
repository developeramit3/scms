import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/services/session_repo.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../services/project_model.dart';
import '../m/performance_response.dart';

class PersonnelPerformanceController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<PerformanceResponse> taskList = [];
  bool isLoading = true;
  double totalVolume=0;
  ProjectModel? selectedProject;
  String id="";
  PersonnelPerformanceController(){
    getSelectedProject().then((value){
      selectedProject=value;
      getValue();
    });
  }

  void getTask() {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('PersonallePerformance');
    ref_projectdetails
        .onValue
        .listen((event) {
      taskList.clear();
      for (final element in event.snapshot.children) {
        taskList.add(PerformanceResponse(key: element.key.toString(),
            name: element.child("name").value.toString(),
            position: element.child("position").value.toString(),
            hkid: element.child("hkid").value.toString(),
            cwr: element.child("cwr").value.toString(),
            cwrExpiryDate: element.child("cwrExpiryDate").value.toString(),
            greenCard: element.child("greenCard").value.toString(),
            expiryDate: element.child("expiryDate").value.toString(),
        ));
      }
      isLoading=false;
      notifyListeners();
    });

  }
  void deletePerformance(key) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('PersonallePerformance/$key');
    ref_projectdetails.remove();

  }
  void addPerformance(val) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('PersonallePerformance/');
    String key=ref_projectdetails.push().key.toString();
    ref_projectdetails.child(key).update(val);

  }
  void updatePerformance(key,val) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('PersonallePerformance');
    ref_projectdetails.child(key).set(val);

  }
  void getValue() {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('projectdetails/${selectedProject!.project}');
    ref_projectdetails
        .orderByChild('file_type')
        .equalTo(2)
        .onValue
        .listen((event) {
      for (final element in event.snapshot.children) {
        dynamic details = element.child("details").value;
        dynamic shotcrete_application_package = element.child("shotcrete_application_package").value;
        if (shotcrete_application_package) {
          Map<String, dynamic> map = jsonDecode(details)['shotcrete_application_package'];
          String nameID=map['name_id_nozzleman_push_key'].toString();
          if(nameID==id && map['volume']!=null){
            double volume = double.tryParse(map['volume'])??0;
            totalVolume = totalVolume + volume;
          }
        }
      }
      isLoading=false;
      notifyListeners();
    });
  }
  void reset() {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('projectdetails/${selectedProject!.project}');
    ref_projectdetails
        .orderByChild('file_type')
        .equalTo(2)
        .onValue
        .listen((event) {
      for (final element in event.snapshot.children) {
        String key = element.key.toString();
        dynamic details = element.child("details").value;
        dynamic shotcrete_application_package =
            element.child("shotcrete_application_package").value;
        if (shotcrete_application_package) {
          Map<String, dynamic> map =
          jsonDecode(details)['shotcrete_application_package'];
          String nameID=map['name_id_nozzleman_push_key'].toString();
          if(nameID==id){
            map['volume'] = "0";
          }
          ref_projectdetails.child(key).child('details').set(map.toString());
        }
      }
    });
    LockOverlay().closeOverlay();
  }
}
