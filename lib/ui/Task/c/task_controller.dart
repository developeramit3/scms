import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../m/task_response.dart';

class TaskController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<TaskResponse> taskList = [];
  String selectedProject="";
  bool isLoading = true;

  void getTask(file_type) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('projectdetails/$selectedProject');
    ref_projectdetails
        .orderByChild('file_type')
        .equalTo(file_type)
        .onValue
        .listen((event) {
      taskList.clear();
      for (final element in event.snapshot.children) {
        taskList.add(TaskResponse(key: element.key.toString(),
            name: element.child("name").value.toString(),
            file_type: element.child("file_type").value.toString(),
            qa_qc_package: element.child("qa_qc_package").value.toString(),
            qa_qc_package_01: element.child("qa_qc_package_01").value.toString(),
            qa_qc_package_02: element.child("qa_qc_package_02").value.toString(),
            qa_qc_package_03: element.child("qa_qc_package_03").value.toString(),
            qa_qc_package_04: element.child("qa_qc_package_04").value.toString(),
            project_name: element.child("project_name").value.toString(),
            surface_preparation_package: element.child("surface_preparation_package").value.toString(),
            shotcrete_application_package: element.child("shotcrete_application_package").value.toString(),
            applied_monitoring_package: element.child("applied_monitoring_package").value.toString(),
            completion_equipment_cleaning_package: element.child("completion_equipment_cleaning_package").value.toString(),
            fiber_added: element.child("fiber_added").value.toString(),
            chemical_added: element.child("chemical_added").value.toString(),
            attachment_link: element.child("attachment_link").value.toString(),
            signature: element.child("signature").value.toString(),
            qa_qc_package_object: element.child("qa_qc_package_object").value.toString(),
            details: element.child("details").value.toString()));
      }
      isLoading=false;
      notifyListeners();
    });

  }
  void deleteTask(file_type,key) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('projectdetails/$selectedProject/$key');
    ref_projectdetails.remove();

  }
  void addTask(val) {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('projectdetails/$selectedProject/');
    String key=ref_projectdetails.push().key.toString();
    ref_projectdetails.child(key).update(val);

  }

}
