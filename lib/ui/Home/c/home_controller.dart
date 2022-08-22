import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/services/session_repo.dart';
import 'package:scms/ui/Home/m/user_model.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../Utils/tools.dart';
import '../../../generated/l10n.dart';
import '../m/delay_response.dart';
import '../m/project_response.dart';

class HomeController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  ProjectResponse? projectResponse;
  List<DelayResponse> delayList = [];
  UserModel? user;
  String selectedProject="";

  HomeController() {
    getUser().then((value) {
      user = value;
    });
  }

  bool isLoading = true;
  bool isLoadingDelay = true;

  void getProjectDetails() {
    DatabaseReference ref = FirebaseDatabase.instance.ref('project/$selectedProject');
    ref.onValue.listen((DatabaseEvent event) {
      isLoading = false;
      projectResponse = ProjectResponse(
        volume: event.snapshot.child("volume").value,
        start_day: event.snapshot.child("start_day").value,
        volume_complete_day: event.snapshot.child("volume_complete_day").value,
      );
      notifyListeners();
    });
  }

  void getDelay() {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Delay/$selectedProject');
    ref.onValue.listen((event) {
      for (final element in event.snapshot.children) {
        delayList.add(DelayResponse(
          delay: int.parse(element.child('delay').value.toString()),
          delay_date: Tools.changeDateFormat(
              element.child("delay_date").value.toString()),
        ));
      }
      isLoadingDelay=false;
      print('delayList ${delayList.length}');
      notifyListeners();
    }, onError: (error) {
      isLoadingDelay=false;
      notifyListeners();
      print(error);
    });
  }

  void postValDay(String val) {
    projectResponse!.volume_complete_day = val;
    DatabaseReference ref = FirebaseDatabase.instance.ref('project/$selectedProject');
    ref.set(projectResponse!.toMap());
  }

  void reset() {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    projectResponse!.volume_complete_day = "0";
    projectResponse!.volume = "0";
    projectResponse!.start_day = Tools.getCurrentDate();
    DatabaseReference ref = FirebaseDatabase.instance.ref('project/$selectedProject');
    DatabaseReference ref_Delay =
        FirebaseDatabase.instance.ref('Delay/$selectedProject');
    DatabaseReference ref_projectdetails =
        FirebaseDatabase.instance.ref('projectdetails/$selectedProject');
    ref.set(projectResponse!.toMap());
    ref_Delay.remove();
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
          map['volume'] = "0";
          map['dump_volume'] = "0";
          map['euipment_performance_date'] = "";
          ref_projectdetails.child(key).child('details').set(map.toString());

        }
      }
    });
    LockOverlay().closeOverlay();
  }
  void getDumvalue() {
    double dump_volume=0;
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    DatabaseReference ref_projectdetails =
        FirebaseDatabase.instance.ref('projectdetails/$selectedProject');
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
          if(map['dump_volume']!=null){
            double volume = double.tryParse(map['dump_volume'])??0;
            dump_volume = dump_volume + volume;
          }
        }
      }
    });
    LockOverlay().closeOverlay();

  }
}
