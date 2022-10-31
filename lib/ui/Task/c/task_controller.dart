import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/services/dropdown_model.dart';
import 'package:scms/ui/Task/c/save_file_mobile.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../../Dios/api_dio.dart';
import '../../../Utils/lock_overlay.dart';
import '../../../Utils/tools.dart';
import '../../../globle/m/basic_response.dart';
import '../../../globle/m/error_response.dart';
import '../../../globle/m/project_model.dart';
import '../../../services/session_repo.dart';
import '../../Equipment/m/equipment_response.dart';
import '../../PersonnelPerformance/m/performance_response.dart';
import '../../Stock/m/material_response.dart';
import '../m/task_details_model.dart';
import '../m/task_response.dart';

class TaskController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<TaskList> taskList = [];
  List<DropdownModel> equipmentList = [];
  List<DropdownModel> NameIDofNozzlemanList = [];
  String previousVolume = "0";
  String new_volume = "";
  bool isLoading = true;
  Project? selectedProject;
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
  Materialll materialUsage=Materialll.fromJson({});
  Materialll materialStock=Materialll.fromJson({});

  TaskController() {
    getSelectedProject().then((value) {
      selectedProject = value;
      previousVolume=selectedProject!.volume;
      getMaterialUsage();
    });
  }
  void getMaterialUsage() {
    _ListenerGetMaterial().then((value){
      if(value.status){
        materialUsage=value.list.where((element) => element.type=="Usage").first;
        materialStock=value.list.where((element) => element.type=="Stock").first;
        notifyListeners();
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError(onError);

  }
  void getTask(file_type) {
    isLoading = true;
    notifyListeners();
    _ListenerTaskList().then((value){
      if(value.status){
        taskList=value.list.where((element) => element.file_type==file_type.toString()).toList();
      }
      isLoading = false;
      LockOverlay().closeOverlay();
      notifyListeners();
    }).catchError(onError);

  }
  Future<TaskResponse>_ListenerTaskList() async {
    var response =
    await httpClientWithHeaderToken(await getToken()).get("project-details/${selectedProject!.id}");
    return TaskResponse.fromJson(response.data);
  }
  void deleteTask(key) {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerDeleteTask(key).then((value){
     Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
     LockOverlay().closeOverlay();
     notifyListeners();
    }).catchError(onError);
  }

  void addTask(Map<String,dynamic>val) {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerAddTask(val).then((value){
      getTask(0);
    }).catchError(onError);
  }
  Future<BasicResponse>_ListenerAddTask(Map<String,dynamic>val) async {
    val['project_id']=selectedProject!.id;
    var response =
    await httpClientWithHeaderToken(await getToken()).post("project-details",data: val);
    return BasicResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerDeleteTask(id) async {
    var response =
    await httpClientWithHeaderToken(await getToken()).delete("project-details/${id}");
    return BasicResponse.fromJson(response.data);
  }
  void getEquipment() {
    _ListenerGetEquipment().then((value){
      for (final element in value.list) {
        equipmentList.add(DropdownModel(
          value: element.id,
          title: element.name.toString(),
        ));
        notifyListeners();
      }
    });
  }
  Future<EquipmentResponse>_ListenerGetEquipment() async {
    var response =
    await httpClientWithHeaderToken(await getToken()).get("equiment-performances");
    return EquipmentResponse.fromJson(response.data);
  }
  Future<PerformanceResponse>_ListenerGetPersonallePerformance() async {
    var response =
    await httpClientWithHeaderToken(await getToken()).get("personal-performances");
    return PerformanceResponse.fromJson(response.data);
  }
  void getNameIDOf() {
    _ListenerGetPersonallePerformance().then((value){
      for (final element in value.list) {
        NameIDofNozzlemanList.add(DropdownModel(
          value: element.id,
          title: element.name.toString(),
        ));
        notifyListeners();
      }
    });

  }

  void saveTask(TaskList data) {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    Map<String,dynamic>map=Map();
    map['details']=jsonEncode(data.details!.toMap());
    map['file_type']="1";
    map['project_id']=selectedProject!.id;
    _ListenerUpdateTask(map,data.id).then((value){
      getTask(1);
    }).catchError(onError);
    }

  void submitTask(TaskList data) {
    bool uploadMaterial=false;
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    Map<String,dynamic>map=Map();
    map['project_id']=selectedProject!.id;
    map['file_type']="2";
    if (new_volume.isNotEmpty) {
      String val = (double.parse(previousVolume) + double.parse(new_volume)).toStringAsFixed(0);
      selectedProject!.volume=val;
      updateProject();
    }
    if (data.completion_equipment_cleaning_package.toString()=="1") {
      Map<String,dynamic>ppp=Map();
      ppp['delay']=data.details!.completion_equipment_cleaning_package.delay.toString();
      ppp['delay_date']=data.details!.completion_equipment_cleaning_package.delay_date;
      addDelay(ppp);
    }
    if(data.chemical_added.toString()=="1"){
      ChemicalAddedModel model=data.details!.chemical_added;
      uploadMaterial=true;
        double plaster_sizer=double.parse(materialUsage.super_plaster_size.toString())+double.parse(model.plaster_sizer);
        double hsc=double.parse(materialUsage.hsc.toString())+double.parse(model.hca.toString());
        materialUsage.super_plaster_size=plaster_sizer;
        materialUsage.hsc=hsc.toString();

        double s_plaster_sizer=double.parse(materialStock.super_plaster_size.toString())-double.parse(model.plaster_sizer);
        double _shsc=double.parse(materialStock.hsc.toString())-double.parse(model.hca.toString());
        materialStock.super_plaster_size=s_plaster_sizer;
        materialStock.hsc=_shsc.toString();

    }
    if(data.fiber_added.toString()=="1"){
      uploadMaterial=true;
      FiberAddedModel model=data.details!.fiber_added;
        materialUsage.fiber_1=PlusTotal(materialUsage.fiber_1.toString(),model.mono.toString());
        materialUsage.fiber_2=PlusTotal(materialUsage.fiber_2.toString(),model.duro.toString());
        materialStock.fiber_1=MinusTotal(materialStock.fiber_1.toString(),model.mono.toString());
        materialStock.fiber_2=MinusTotal(materialStock.fiber_2.toString(),model.duro.toString());
    }
    if(data.shotcrete_application_package.toString()=="1"){
      uploadMaterial=true;
      SoftcutApplicationModel model=data.details!.shotcrete_application_package;

        double accelerator=double.parse(materialUsage.accelerator.toString())+double.parse(model.accelerator.toString().isEmpty?"0":model.accelerator.toString());
        materialUsage.accelerator=accelerator.toString();

        double s_accelerator=double.parse(materialStock.accelerator.toString())-double.parse(model.accelerator.toString());
        materialStock.accelerator=s_accelerator.toString();

    }
    if(materialUsage.type!=null&&uploadMaterial) {
      UpdateMaterial(materialUsage);
    }
    else if(uploadMaterial){
      addMaterial(materialUsage);
    }
    if(uploadMaterial) {
      UpdateMaterial(materialStock);
    }
    map['details']=jsonEncode(data.details!.toMap());
    _ListenerUpdateTask(map,data.id).then((value){
      generateInvoice(data);
      Navigator.pop(scaffoldKey.currentContext!,2);
      // getTask(2);
    }).catchError(onError);

  }
  void updateProject() async {
    _ListenerUpdateProject().then((value){
      notifyListeners();
    }).catchError(onError);
  }
   Future<BasicResponse>_ListenerUpdateProject() async {
    var response =
    await httpClientWithHeaderToken(await getToken()).put("projects/${selectedProject!.id}",data: selectedProject!.toMap());
    return BasicResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerUpdateTask(Map<String,dynamic>map,id) async {

    var response =
    await httpClientWithHeaderToken(await getToken()).put("project-details/${id}",data: map);
    return BasicResponse.fromJson(response.data);
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
    PostImage(path: val.path, fileName: val.name, folder_path: 'uploadfile').then((value){
      if(value.status){
        return value.file_path;
      }
      LockOverlay().closeOverlay();
    });
    return "";
  }

  Future<String> addSignature(data,name) async {
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    PostImage(path: data, fileName: name+".png", folder_path: 'uploadfile').then((value){
      LockOverlay().closeOverlay();
      if(value.status){
        return value.file_path;
      }

    }).catchError((e){
      LockOverlay().closeOverlay();
      print(e);
    });
    return "";
  }

  Future<void> generateInvoice(TaskList data) async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    final PdfLayoutResult result = await drawHeader(page, pageSize);
    _drawList(page, pageSize,data);
    final List<int> bytes = document.saveSync();
    document.dispose();
    String name='${data.id}.pdf';
    saveOnly(bytes, name).then((value) async {
      if(await value.exists()) {
        PostImage(path: value.path, fileName: name, folder_path: 'PDF').then((
            value) {
          if (value.status) {
            print('${value.file_path}');
          }
        });
      }else{
        print("FileNotFound");
      }
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
  Future<void> _drawList(page,size,TaskList data) async {
    print("sssss==>${data.shotcrete_application_package.toString()}");
    PdfUnorderedList list = PdfUnorderedList();
    //Set the marker style
    list.marker.style = PdfUnorderedMarkerStyle.none;
    list.stringFormat = PdfStringFormat(lineSpacing: 10);
    if(data.details!.qa_qc_package.length>0){
      for (int i=0; i<data.details!.qa_qc_package.length;i++){
        list.items.add(PdfListItem(text: 'QA/QC Shotcrete Mix Package (Load ${i + 1})',font: PdfStandardFont(PdfFontFamily.helvetica, 14,style: PdfFontStyle.bold)));
        list.items[i].subList = PdfUnorderedList(
            marker: PdfUnorderedMarker(style: PdfUnorderedMarkerStyle.none),
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
            font: PdfStandardFont(PdfFontFamily.helvetica, 10),
            indent: 20);
      }
     }
    if(data.surface_preparation_package.toString()=="1"){
      list.items.add(PdfListItem(text: 'Shotcrete & Surface Preparation Package',subList: PdfUnorderedList(
          marker: PdfUnorderedMarker(style: PdfUnorderedMarkerStyle.none),
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
          font: PdfStandardFont(PdfFontFamily.helvetica, 10),
          textIndent: 10,
          indent: 20),font: PdfStandardFont(PdfFontFamily.helvetica, 14,style: PdfFontStyle.bold),));

    }
    if(data.shotcrete_application_package.toString()=="1"){
      String nameID=data.details!.shotcrete_application_package.name_id_nozzleman.toString().isEmpty?
      NameIDofNozzlemanList.first.title
      :NameIDofNozzlemanList.where((element) => element.value==data.details!.shotcrete_application_package.name_id_nozzleman).first.title;
      list.items.add(PdfListItem(text: 'Shotcrete Application Package',subList: PdfUnorderedList(
          marker: PdfUnorderedMarker(style: PdfUnorderedMarkerStyle.none),
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
          font: PdfStandardFont(PdfFontFamily.helvetica, 10),
          textIndent: 10,
          indent: 20),
        font: PdfStandardFont(PdfFontFamily.helvetica, 14,style: PdfFontStyle.bold),));

    }
    if(data.applied_monitoring_package.toString()=="1"){
          list.items.add(PdfListItem(text: 'Applied Monitoring Package',subList: PdfUnorderedList(
          marker: PdfUnorderedMarker(style: PdfUnorderedMarkerStyle.none),
          items: PdfListItemCollection(<String>[
            'Scanner Used Prior: ${getValidateValue(data.details!.applied_monitoring_package.scanner_used)}',
            'Depth Pins/String Lines: ${getValidateValue(data.details!.applied_monitoring_package.depth_pins)}',
            'Profile Bars: ${getValidateValue(data.details!.applied_monitoring_package.profile_bars)}',
            'Scanner Used After: ${getValidateValue(data.details!.applied_monitoring_package.scanner_used_after)}',
            'Completed & Signed Off: ${getValidateValue(data.details!.applied_monitoring_package.completed_signed)}',
          ]),
              font: PdfStandardFont(PdfFontFamily.helvetica, 10),
          textIndent: 10,
          indent: 20),font: PdfStandardFont(PdfFontFamily.helvetica, 14,style: PdfFontStyle.bold),));

    }
    if(data.completion_equipment_cleaning_package.toString()=="1"){
      list.items.add(PdfListItem(text: 'Completion & Equipment Cleaning Package',subList: PdfUnorderedList(
          marker: PdfUnorderedMarker(
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
          font: PdfStandardFont(PdfFontFamily.helvetica, 10),
          textIndent: 10,
          indent: 20),font: PdfStandardFont(PdfFontFamily.helvetica, 14,style: PdfFontStyle.bold),));

    }
    if(data.chemical_added.toString()=="1"){
      list.items.add(PdfListItem(text: 'Chemical Added',subList: PdfUnorderedList(
          marker: PdfUnorderedMarker(
              style: PdfUnorderedMarkerStyle.none),
          items: PdfListItemCollection(<String>[
            'Superplastersizer (Ltrs): ${data.details!.chemical_added.plaster_sizer}',
            'HCA (Ltrs): ${data.details!.chemical_added.hca}',
          ]),
          font: PdfStandardFont(PdfFontFamily.helvetica, 10),
          textIndent: 10,
          indent: 20),font: PdfStandardFont(PdfFontFamily.helvetica, 14,style: PdfFontStyle.bold),));

    }
    if(data.fiber_added.toString()=="1"){
      list.items.add(PdfListItem(text: 'Fiber Added',subList: PdfUnorderedList(
          marker: PdfUnorderedMarker(
              style: PdfUnorderedMarkerStyle.none),
          items: PdfListItemCollection(<String>[
            'Mono (KG): ${data.details!.fiber_added.mono}',
            'Duro (KG): ${data.details!.fiber_added.duro}',
          ]),
          font: PdfStandardFont(PdfFontFamily.helvetica, 10),
          textIndent: 10,
          indent: 20),font: PdfStandardFont(PdfFontFamily.helvetica, 14,style: PdfFontStyle.bold),));

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
  void UpdateMaterial(Materialll ml){
    _ListenerUpdateMaterial(ml).then((value){
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError(onError);

  }
  void addMaterial(Materialll ml) {
    ml.type="Usage";
    ml.project_id=selectedProject!.id;
    LockOverlay().showClassicLoadingOverlay(scaffoldKey.currentContext);
    _ListenerAddMaterial(ml).then((value){
      if(value.status){
        Tools.ShowSuccessMessage(scaffoldKey.currentContext!, value.message);
      }else{
        Tools.ShowErrorMessage(scaffoldKey.currentContext!, value.message);
      }
    }).catchError(onError);
  }
  void addDelay(map) {
    _ListenerAddDelay(map).then((value){
      print("value==> ${value.toJson()}");
    }).catchError(onError);
  }
  Future<BasicResponse>_ListenerUpdateMaterial(Materialll ml) async {
    var response =
    await httpClientWithHeaderToken(await getToken()).put("materials/${ml.id}",data: ml.toJson());
    return BasicResponse.fromJson(response.data);
  }
  void onError(e){
    if (e is DioError) {
      ErrorResponse errorResponse=ErrorResponse.fromJson(e.response!.data);
      Tools.ShowErrorMessage(scaffoldKey.currentContext, errorResponse.message);
    }
    LockOverlay().closeOverlay();
  }
  Future<MaterialResponse>_ListenerGetMaterial() async {
    var response =
    await httpClientWithHeaderToken(await getToken()).get("materials/${selectedProject!.id}");
    return MaterialResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerAddMaterial(Materialll map) async {
    var response =
    await httpClientWithHeaderToken(await getToken()).post("materials",data: map.toJson());
    return BasicResponse.fromJson(response.data);
  }
  Future<BasicResponse>_ListenerAddDelay(map) async {
    map['project_id']=selectedProject!.id;
    var response =
    await httpClientWithHeaderToken(await getToken()).post("delays",data: map);
    return BasicResponse.fromJson(response.data);
  }
}
