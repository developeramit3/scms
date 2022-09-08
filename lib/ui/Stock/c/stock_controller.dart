import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../services/project_model.dart';
import '../../../services/session_repo.dart';
import '../../Home/m/user_model.dart';
import '../m/material_response.dart';

class StockController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  MaterialResponse? materialResponse;
  ProjectModel? selectedProject;
  bool isLoading = true;
  UserModel? user;
  StockController(){
    getUser().then((value) {
      user = value;
    });
    getSelectedProject().then((value){
      selectedProject=value;
      getMaterial(0);
    });
  }

  void getMaterial(int type) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('Matatial/${selectedProject!.project}');
    ref_projectdetails.child(type==0?"Usage":"Stock")
        .onValue
        .listen((event) {
      materialResponse=MaterialResponse(accelerator:event.snapshot.child('accelerator').value.toString(),
      fiber_1: event.snapshot.child('fiber_1').value.toString(),
      fiber_2: event.snapshot.child('fiber_2').value.toString(),
      hsc: event.snapshot.child('hsc').value.toString(),
      super_plaster_size: event.snapshot.child('super_plaster_size').value.toString(),
      );
      isLoading=false;
      notifyListeners();
    });

  }
  void resetMaterial() {
    materialResponse!.accelerator="0";
    materialResponse!.fiber_1="0";
    materialResponse!.fiber_2="0";
    materialResponse!.hsc="0";
    materialResponse!.super_plaster_size="0";
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('Matatial/${selectedProject!.project}');
    ref_projectdetails.child("Usage").set(materialResponse!.toMap());
      notifyListeners();
  }

  void addMaterial(int type,val) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('Matatial/${selectedProject!.project}/').child(type==0?"Usage":"Stock");
    ref_projectdetails.set(val);

  }

}
