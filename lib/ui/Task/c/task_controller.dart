import 'dart:convert';
import 'dart:io';

import 'package:bitmap/bitmap.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/services/dropdown_model.dart';
import 'package:scms/ui/Task/c/save_file_mobile.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../services/project_model.dart';
import '../../../services/session_repo.dart';
import '../../Stock/m/material_response.dart';
import '../m/task_details_model.dart';
import '../m/task_response.dart';

class TaskController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<TaskResponse> taskList = [];
  List<DropdownModel> equipmentList = [];
  List<DropdownModel> NameIDofNozzlemanList = [];
  String previousVolume = "0";
  String new_volume = "";
  bool isLoading = true;
  ProjectModel? selectedProject;
  List<DropdownModel> MethodsUsedList = [
    DropdownModel(title: "Robotic", value: "Robotic"),
    DropdownModel(title: "Manual", value: "Manual")
  ];
  List<DropdownModel> PositionList = [
    DropdownModel(title: "Invert", value: "Invert"),
    DropdownModel(title: "Walls", value: "Walls"),
    DropdownModel(title: "Crown", value: "Crown"),
    DropdownModel(title: "Walls and Crown", value: "Walls and Crown"),
  ];
  List<DropdownModel> PrimaryorSecondaryLiningList = [
    DropdownModel(title: "Primary lining", value: "Primary lining"),
    DropdownModel(title: "Secondary lining", value: "Secondary lining"),
  ];
  List<DropdownModel> FinishRequirementsList = [
    DropdownModel(title: "Sprayed", value: "Sprayed"),
    DropdownModel(title: "Trowelled", value: "Trowelled"),
  ];
  MaterialResponse? materialUsage;
  MaterialResponse? materialStock;
  TaskController() {
    getSelectedProject().then((value) {
      selectedProject = value;
      getVolume();
      getMaterialUsage();
      getMaterialStock();
    });
  }
  void getMaterialUsage() {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('Matatial/${selectedProject!.project}');
    ref_projectdetails.child("Usage")
        .onValue
        .listen((event) {
      materialUsage=MaterialResponse(accelerator:event.snapshot.child('accelerator').value.toString(),
        fiber_1: event.snapshot.child('fiber_1').value.toString(),
        fiber_2: event.snapshot.child('fiber_2').value.toString(),
        hsc: event.snapshot.child('hsc').value.toString(),
        super_plaster_size: event.snapshot.child('super_plaster_size').value.toString(),
      );
      isLoading=false;
      notifyListeners();
    });

  }
  void getMaterialStock() {
    DatabaseReference ref_projectdetails =
    FirebaseDatabase.instance.ref('Matatial/${selectedProject!.project}');
    ref_projectdetails.child("Stock")
        .onValue
        .listen((event) {
      materialStock=MaterialResponse(accelerator:event.snapshot.child('accelerator').value.toString(),
        fiber_1: event.snapshot.child('fiber_1').value.toString(),
        fiber_2: event.snapshot.child('fiber_2').value.toString(),
        hsc: event.snapshot.child('hsc').value.toString(),
        super_plaster_size: event.snapshot.child('super_plaster_size').value.toString(),
      );
      isLoading=false;
      notifyListeners();
    });

  }

  void getTask(file_type) {
    DatabaseReference ref_projectdetails = FirebaseDatabase.instance
        .ref('projectdetails/${selectedProject!.project}');
    ref_projectdetails
        .orderByChild('file_type')
        .equalTo(file_type)
        .onValue
        .listen((event) {
      taskList.clear();
      for (final element in event.snapshot.children) {
        taskList.add(TaskResponse(
            key: element.key.toString(),
            name: element.child("name").value.toString(),
            file_type: element.child("file_type").value.toString(),
            qa_qc_package: element.child("qa_qc_package").value.toString(),
            qa_qc_package_01:
                element.child("qa_qc_package_01").value.toString(),
            qa_qc_package_02:
                element.child("qa_qc_package_02").value.toString(),
            qa_qc_package_03:
                element.child("qa_qc_package_03").value.toString(),
            qa_qc_package_04:
                element.child("qa_qc_package_04").value.toString(),
            project_name: element.child("project_name").value.toString(),
            surface_preparation_package:
                element.child("surface_preparation_package").value.toString(),
            shotcrete_application_package:
                element.child("shotcrete_application_package").value.toString(),
            applied_monitoring_package:
                element.child("applied_monitoring_package").value.toString(),
            completion_equipment_cleaning_package: element
                .child("completion_equipment_cleaning_package")
                .value
                .toString(),
            fiber_added: element.child("fiber_added").value.toString(),
            chemical_added: element.child("chemical_added").value.toString(),
            attachment_link: element.child("attachment_link").value.toString(),
            signature: element.child("signature").value.toString(),
            qa_qc_package_object: getValueQC(element),
            details: element.child("details").value == null
                ? TaskDetailsModel.fromJson({})
                : TaskDetailsModel.fromJson(getValue(element))));
      }
      isLoading = false;
      notifyListeners();
    });
  }

  Map<String, dynamic> getValue(element) {
    try {
      return jsonDecode(element.child("details").value.toString());
    } catch (e, s) {
      return {};
    }
  }

  List<DetailsModel> getValueQC(element) {
    try {
      return jsonDecode(element.child("qa_qc_package_object").value.toString())
          .map<DetailsModel>((value) => DetailsModel.fromJson(value))
          .toList();
    } catch (e, s) {
      return [];
    }
  }

  void deleteTask(file_type, key) {
    DatabaseReference ref_projectdetails = FirebaseDatabase.instance
        .ref('projectdetails/${selectedProject!.project}/$key');
    ref_projectdetails.remove();
  }

  void addTask(val) {
    DatabaseReference ref_projectdetails = FirebaseDatabase.instance
        .ref('projectdetails/${selectedProject!.project}/');
    String key = ref_projectdetails.push().key.toString();
    ref_projectdetails.child(key).update(val);
  }

  void getEquipment() {
    DatabaseReference ref_projectdetails =
        FirebaseDatabase.instance.ref('EquipmentPerformance');
    ref_projectdetails.onValue.listen((event) {
      for (final element in event.snapshot.children) {
        equipmentList.add(DropdownModel(
          value: element.key,
          title: element.child("name").value.toString(),
        ));
      }
      notifyListeners();
    });
  }

  void getVolume() {
    DatabaseReference ref_projectdetails =
        FirebaseDatabase.instance.ref('project/${selectedProject!.project}');
    ref_projectdetails.onValue.listen((event) {
      previousVolume = event.snapshot.child('volume').value.toString();
    });
  }

  void getNameIDOf() {
    DatabaseReference ref_projectdetails =
        FirebaseDatabase.instance.ref('PersonallePerformance');
    ref_projectdetails.onValue.listen((event) {
      for (final element in event.snapshot.children) {
        NameIDofNozzlemanList.add(DropdownModel(
          value: element.key.toString(),
          title: element.child("name").value.toString(),
        ));
      }
      notifyListeners();
    });
  }

  void saveTask(TaskResponse data, val) {
    DatabaseReference ref_projectdetails = FirebaseDatabase.instance
        .ref('projectdetails/${selectedProject!.project}/');
    ref_projectdetails.child(data.key).child('details').set(jsonEncode(val));
    ref_projectdetails.child(data.key).child('file_type').set(1);
    }

  void submitTask(TaskResponse data) {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    print(data.details!.toMap());
    DatabaseReference ref_projectdetails = FirebaseDatabase.instance
        .ref('projectdetails/${selectedProject!.project}/');
    ref_projectdetails.child(data.key).child('details').set(jsonEncode(data.details!.toMap()));
    ref_projectdetails.child(data.key).child('file_type').set(2);
    if (new_volume.isNotEmpty) {
      DatabaseReference project =
          FirebaseDatabase.instance.ref('project/${selectedProject!.project}/');
      String val = (double.parse(previousVolume) + double.parse(new_volume))
          .toStringAsFixed(0);
      project.child('volume').set(val);
    }
    if (data.completion_equipment_cleaning_package.toString()=="true"&&data.details!.completion_equipment_cleaning_package.delay.toString().isNotEmpty&&data.details!.completion_equipment_cleaning_package.delay_date.toString().isNotEmpty) {
      Map<String,dynamic>map=Map();
      map['delay']=data.details!.completion_equipment_cleaning_package.delay.toString();
      map['delay_date']=data.details!.completion_equipment_cleaning_package.delay_date;
      DatabaseReference delay =
      FirebaseDatabase.instance.ref('Delay/${selectedProject!.project}/');
      String key = delay.push().key.toString();
      delay.child(key).update(map);
    }
    if(data.chemical_added.toString()=="true"){
      ChemicalAddedModel model=data.details!.chemical_added;
      if(materialUsage!=null){
        double plaster_sizer=double.parse(materialUsage!.super_plaster_size.toString())+double.parse(model.plaster_sizer);
        double hsc=double.parse(materialUsage!.hsc.toString())+double.parse(model.hca.toString());
        UpdateMaterial("Usage","super_plaster_size",plaster_sizer.toString());
        UpdateMaterial("Usage","hsc",hsc.toString());
      }
      if(materialStock!=null){
        double plaster_sizer=double.parse(materialStock!.super_plaster_size.toString())-double.parse(model.plaster_sizer);
        double hsc=double.parse(materialStock!.hsc.toString())-double.parse(model.hca.toString());
        UpdateMaterial("Stock","super_plaster_size",plaster_sizer.toString());
        UpdateMaterial("Stock","hsc",hsc.toString());
      }
    }
    if(data.fiber_added.toString()=="true"){
      FiberAddedModel model=data.details!.fiber_added;
      if(materialUsage!=null){
        UpdateMaterial("Usage","fiber_1",PlusTotal(materialUsage!.fiber_1.toString(),model.mono.toString()));
        UpdateMaterial("Usage","fiber_2",PlusTotal(materialUsage!.fiber_2.toString(),model.duro.toString()));
      }
      if(materialStock!=null){
        UpdateMaterial("Stock","fiber_1",MinusTotal(materialStock!.fiber_1.toString(),model.mono.toString()));
        UpdateMaterial("Stock","fiber_2",MinusTotal(materialStock!.fiber_2.toString(),model.duro.toString()));
      }
    }
    if(data.shotcrete_application_package.toString()=="true"){
      SoftcutApplicationModel model=data.details!.shotcrete_application_package;
      if(materialUsage!=null){
        double accelerator=double.parse(materialUsage!.accelerator.toString())+double.parse(model.accelerator.toString().isEmpty?"0":model.accelerator.toString());
        UpdateMaterial("Usage","accelerator",accelerator.toString());
      }
      if(materialStock!=null){
        double accelerator=double.parse(materialStock!.accelerator.toString())-double.parse(model.accelerator.toString());
        UpdateMaterial("Stock","accelerator",accelerator.toString());
      }
    }
    LockOverlay().closeOverlay();
    generateInvoice(data);
    Navigator.pop(scaffoldKey.currentContext!,2);
  }
  String PlusTotal(String old,String New){
    double x=double.tryParse(old)??0;
    double y=double.tryParse(New)??0;
    return (x+y).toString();
  }
  String MinusTotal(String old,String New){
    double x=double.tryParse(old)??0;
    double y=double.tryParse(New)??0;
    return (x-y).toString();
  }
  Future<String> addFile(PlatformFile val) async {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    var ref = FirebaseStorage.instance.ref().child('uploadfile/${val.name}');
    ref.putFile(File(val.path!)).asStream().listen((event) {
      ref.getDownloadURL().then((value) {
        return value.toString();
      });
      LockOverlay().closeOverlay();
    });
    return "";
  }

  Future<String> addSignature(data) async {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    String fileName = DateTime.now().toString() + ".png";
    var ref = FirebaseStorage.instance.ref().child('uploadfile/${fileName}');
    ref.putData(data).asStream().listen((event) {
      ref.getDownloadURL().then((value) {
        return value.toString();
      });
      LockOverlay().closeOverlay();
    });
    return "";
  }

  Future<void> generateInvoice(data) async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    /*page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219)));
    *///Draw the header section by creating text element
    final PdfLayoutResult result = await drawHeader(page, pageSize);
    //Draw grid
    _drawList(page, pageSize,data);
    //Save the PDF document
    final List<int> bytes = document.saveSync();
    //Dispose the document.
    document.dispose();
    //Save and launch the file.
    String name='${DateTime.now()}.pdf';
   String path=await saveOnly(bytes, name);
    var ref = FirebaseStorage.instance.ref().child('uploadpdf/${name}');
    ref.putFile(File(path)).asStream().listen((event) {
      ref.getDownloadURL().then((value) {
        print('${value.toString()}');
      });
    });
  }

  Future<PdfLayoutResult> drawHeader(PdfPage page, Size pageSize) async {
    page.graphics.drawImage(
        PdfBitmap(await _readImageData()), Rect.fromLTWH(107, 5, 280, 100));
    final PdfPen linePen =
        PdfPen(PdfColor(142, 170, 219), dashStyle: PdfDashStyle.solid);
    // linePen.dashPattern = <double>[3, 3];
    page.graphics.drawLine(linePen, Offset(0, 120) , Offset(pageSize.width, 120));
    return PdfTextElement().draw(
        page: page,
        bounds: Rect.fromLTWH(30, 10, pageSize.width, pageSize.height - 120))!;
  }

  void drawLine(PdfPage page, pageSize) {
    page.graphics.drawString("Hell0", PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(pageSize.width, pageSize.height - 70, 0, 0));
  }
  void drawSpace(PdfPage page) {
    page.graphics.drawString("", PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(10, 20, 0, 0));
  }
  Future<void> _drawList(page,size,TaskResponse data) async {
    PdfUnorderedList list = PdfUnorderedList();
    //Set the marker style
    list.marker.style = PdfUnorderedMarkerStyle.none;
    list.font = PdfStandardFont(PdfFontFamily.helvetica, 16);
    list.stringFormat = PdfStringFormat(lineSpacing: 10);
    list.indent = 8;
    list.textIndent = 8;
    if(data.details!.qa_qc_package.length>0){
      for (int i=0; i<data.details!.qa_qc_package.length;i++){
        list.items.add(PdfListItem(text: 'QA/QC Shotcrete Mix Package (Load ${i + 1})',));
        list.items[i].subList = PdfUnorderedList(
            marker: PdfUnorderedMarker(
                font: PdfStandardFont(PdfFontFamily.helvetica, 10),
                style: PdfUnorderedMarkerStyle.none),
            items: PdfListItemCollection(<String>[
              'Date: ${data.details!.qa_qc_package[i].date}',
              'Time: ${data.details!.qa_qc_package[i].time}',
              'Name & ID: ${data.details!.qa_qc_package[i].name_id_name}',
              'Docket Number: ${data.details!.qa_qc_package[i].docket_number}',
              'Mix Design: ${data.details!.qa_qc_package[i].mix_design}',
              'Mix Temperature: ${data.details!.qa_qc_package[i].mix_temperature}',
              'Flow/Slump Test Results: ${data.details!.qa_qc_package[i].flow_slump_results}',
            ]),
            textIndent: 10,
            indent: 20);
      }
     }
    if(data.surface_preparation_package.toString()=="true"){
      list.items.add(PdfListItem(text: 'Shotcrete & Surface Preparation Package',subList: PdfUnorderedList(
          marker: PdfUnorderedMarker(
              font: PdfStandardFont(PdfFontFamily.helvetica, 10),
              style: PdfUnorderedMarkerStyle.none),
          items: PdfListItemCollection(<String>[
            'Water Control/Management Completed: ${getValidateValue(data.details!.surface_preparation_package.control_management)}',
            'Membrane Applied: ${getValidateValue(data.details!.surface_preparation_package.membrane)}',
            'Surface Scaled (removal of overspray or debris): ${getValidateValue(data.details!.surface_preparation_package.surface_scaled)}',
            'Bolts Installed: ${getValidateValue(data.details!.surface_preparation_package.bolts_installed)}',
            'Anchors Installed or Extended: ${getValidateValue(data.details!.surface_preparation_package.anchors)}',
            'Mesh Installed: ${getValidateValue(data.details!.surface_preparation_package.mesh_installed)}',
            'Surface Washed: ${getValidateValue(data.details!.surface_preparation_package.surface_washed)}',
            'Starter Bars Cleaned: ${getValidateValue(data.details!.surface_preparation_package.starter_bars)}',
            'Barriers & Signage in Place: ${getValidateValue(data.details!.surface_preparation_package.barriers)}',
            'Depth Pins: ${getValidateValue(data.details!.surface_preparation_package.depth.toString())}',
          ]),
          textIndent: 10,
          indent: 20)));

    }
    if(data.shotcrete_application_package.toString()=="true"){
      String nameID=data.details!.shotcrete_application_package.name_id_nozzleman.isEmpty?
      NameIDofNozzlemanList.first.title
      :NameIDofNozzlemanList.where((element) => element.value==data.details!.shotcrete_application_package.name_id_nozzleman).first.title;
      list.items.add(PdfListItem(text: 'Shotcrete Application Package',subList: PdfUnorderedList(
          marker: PdfUnorderedMarker(
              font: PdfStandardFont(PdfFontFamily.helvetica, 10),
              style: PdfUnorderedMarkerStyle.none),
          items: PdfListItemCollection(<String>[
            'Equipment Pre-Starts: ${getValidateValue(data.details!.shotcrete_application_package.equipment.toString())}',
            'Equipment: ${equipmentList[int.parse(data.details!.shotcrete_application_package.euipment_performance_postion.toString())].title}',
            'Equipment use Date: ${data.details!.shotcrete_application_package.euipment_performance_date}',
            'Equipment number of hours: ${data.details!.shotcrete_application_package.equipment_number_of_hours}',
            'Name & ID of Nozzleman: ${nameID}',
            'Ambient Temperature (Celsius): ${data.details!.shotcrete_application_package.ambient_temperature}',
            'Methods Used (Celsius): ${MethodsUsedList[int.parse(data.details!.shotcrete_application_package.methods_used)].title}',
            'Location Sprayed: ${data.details!.shotcrete_application_package.location_sprayed}',
            'Chainage (Start to Finish): ${data.details!.shotcrete_application_package.chainage}',
            'Bays: ${data.details!.shotcrete_application_package.bays}',
            'Position: ${PositionList[int.parse(data.details!.shotcrete_application_package.position)].title}',
            'Volume Applied: ${data.details!.shotcrete_application_package.volume}',
            'Dump volume: ${data.details!.shotcrete_application_package.dump_volume}',
            'Time Completion: ${data.details!.shotcrete_application_package.time_completion}',
            'Primary or Secondary Lining: ${PrimaryorSecondaryLiningList[int.parse(data.details!.shotcrete_application_package.primary)].title}',
            'Thickness Applied: ${data.details!.shotcrete_application_package.Thickness}',
            'Start Time: ${data.details!.shotcrete_application_package.start_time}',
            'Completion Time: ${data.details!.shotcrete_application_package.time_completion}',
            'Finish Requirements: ${FinishRequirementsList[int.parse(data.details!.shotcrete_application_package.finish_requirements)].title}',
          ]),
          textIndent: 10,
          indent: 20)));

    }
    if(data.applied_monitoring_package.toString()=="true"){
      list.items.add(PdfListItem());
          list.items.add(PdfListItem(text: 'Applied Monitoring Package',subList: PdfUnorderedList(
          marker: PdfUnorderedMarker(
              font: PdfStandardFont(PdfFontFamily.helvetica, 10),
              style: PdfUnorderedMarkerStyle.none),
          items: PdfListItemCollection(<String>[
            'Scanner Used Prior: ${getValidateValue(data.details!.applied_monitoring_package.scanner_used)}',
            'Depth Pins/String Lines: ${getValidateValue(data.details!.applied_monitoring_package.depth_pins)}',
            'Profile Bars: ${getValidateValue(data.details!.applied_monitoring_package.profile_bars)}',
            'Scanner Used After: ${getValidateValue(data.details!.applied_monitoring_package.scanner_used_after)}',
            'Completed & Signed Off: ${getValidateValue(data.details!.applied_monitoring_package.completed_signed)}',
          ]),
          textIndent: 10,
          indent: 20)));

    }
    if(data.completion_equipment_cleaning_package.toString()=="true"){
      list.items.add(PdfListItem());
      list.items.add(PdfListItem(text: 'Completion & Equipment Cleaning Package',subList: PdfUnorderedList(
          marker: PdfUnorderedMarker(
              font: PdfStandardFont(PdfFontFamily.helvetica, 10),
              style: PdfUnorderedMarkerStyle.none),
          items: PdfListItemCollection(<String>[
            'Barriers & Signage in Place: ${getValidateValue(data.details!.completion_equipment_cleaning_package.barriers_signage)}',
            'Lines Cleaned: ${getValidateValue(data.details!.completion_equipment_cleaning_package.lines_cleaned.toString())}',
            'Hopper Cleaned: ${getValidateValue(data.details!.completion_equipment_cleaning_package.hopper_cleaned)}',
            'Machine Cleaned: ${getValidateValue(data.details!.completion_equipment_cleaning_package.machine_Cleaned)}',
            'Faults/Repairs Reported: ${getValidateValue(data.details!.completion_equipment_cleaning_package.faults_repairs)}',
            'Date: ${data.details!.completion_equipment_cleaning_package.delay_date}',
            'Delay: ${data.details!.completion_equipment_cleaning_package.delay}',
            'Note: ${data.details!.completion_equipment_cleaning_package.note}',
          ]),
          textIndent: 10,
          indent: 20)));

    }
    if(data.chemical_added.toString()=="true"){
      list.items.add(PdfListItem());
      list.items.add(PdfListItem(text: 'Chemical Added',subList: PdfUnorderedList(
          marker: PdfUnorderedMarker(
              font: PdfStandardFont(PdfFontFamily.helvetica, 10),
              style: PdfUnorderedMarkerStyle.none),
          items: PdfListItemCollection(<String>[
            'Superplastersizer (Ltrs): ${data.details!.chemical_added.plaster_sizer}',
            'HCA (Ltrs): ${data.details!.chemical_added.hca}',
          ]),
          textIndent: 10,
          indent: 20)));

    }
    if(data.fiber_added.toString()=="true"){
      list.items.add(PdfListItem());
      list.items.add(PdfListItem(text: 'Fiber Added',subList: PdfUnorderedList(
          marker: PdfUnorderedMarker(
              font: PdfStandardFont(PdfFontFamily.helvetica, 10),
              style: PdfUnorderedMarkerStyle.none),
          items: PdfListItemCollection(<String>[
            'Mono (KG): ${data.details!.fiber_added.mono}',
            'Duro (KG): ${data.details!.fiber_added.duro}',
          ]),
          textIndent: 10,
          indent: 20)));

    }
    //Draw a list
    list.draw(
        page: page, bounds: Rect.fromLTWH(0, 150, size.width, size.height-150));
  }

  Future<List<int>> _readImageData() async {
    final ByteData data = await rootBundle.load('assets/img/app_logo.png');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
  dynamic getValidateValue(dynamic val){
    return val.toString().isEmpty?"Yes":val=="0"?"Yes":"No";
  }
  void UpdateMaterial(child,key,val){
    DatabaseReference material =
    FirebaseDatabase.instance.ref('Matatial/${selectedProject!.project}/').child(child).child(key);
    material.set(val);

  }
}
