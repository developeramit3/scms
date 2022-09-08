import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:scms/widgets/input_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';
import 'package:signature/signature.dart';
import '../../../services/dropdown_model.dart';
import '../../../widgets/chip_border_widget.dart';
import '../../../widgets/dropdown_widget.dart';
import '../c/task_controller.dart';
import '../m/task_details_model.dart';
import '../m/task_response.dart';

class UpdateTaskDetailsPage extends StatefulWidget {
  TaskResponse response;

  @override
  _PageState createState() => _PageState();

  UpdateTaskDetailsPage(this.response);
}

class _PageState extends StateMVC<UpdateTaskDetailsPage> {
  TaskController? _con;
  var TimeCompletion = TextEditingController();
  List<DropdownModel> yesNoList = [
    DropdownModel(title: "Yes", value: "0"),
    DropdownModel(title: "No", value: "1")
  ];

  TimeOfDay selectedTime = TimeOfDay.now();

  _PageState() : super(TaskController()) {
    _con = controller as TaskController?;
  }

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _con!.getEquipment();
    _con!.getNameIDOf();
  }
  dynamic getValidateValue(String val){
    return val.isEmpty?yesNoList.first:val=="0"?yesNoList.first:yesNoList.last;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con!.scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: HeaderTxtWidget(
          'Task Details',
          color: Colors.white,
        ),
        centerTitle: true,
        leading: InkWell(
          child: Padding(
            child: Image.asset('assets/img/ic_backward_arrow.png'),
            padding: EdgeInsets.all(15),
          ),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _QaPackage(),

              Visibility(
                child: _ShotcreteSurfacePreparationPackage(),
                visible:
                    widget.response.surface_preparation_package.toString() ==
                        "true",
              ),
              Visibility(
                child: _ApplicationPackage(),
                visible:
                    widget.response.shotcrete_application_package.toString() ==
                        "true",
              ),
              Visibility(
                child: _MonitoringPackage(),
                visible:
                    widget.response.applied_monitoring_package.toString() ==
                        "true",
              ),
              Visibility(
                child: _CompletationPackage(),
                visible: widget.response.completion_equipment_cleaning_package
                        .toString() ==
                    "true",
              ),
              Visibility(
                child: _ChemicalAdded(),
                visible: widget.response.chemical_added.toString() == "true",
              ),
              Visibility(
                child: _fiberAdd(),
                visible: widget.response.fiber_added.toString() == "true",
              ),
              Visibility(
                child: _Attachment(),
                visible: widget.response.attachment_link.toString() == "true",
              ),
              Visibility(
                child: _Signature(),
                visible: widget.response.signature.toString() == "true",
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: ChipBorderWidget(
                'Cancel',
                fontSize: 12,
                onTap: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
            ),
            Expanded(
              flex: 1,
              child: ChipBorderWidget(
                'Save',
                fontSize: 12,
                color: Colors.white,
                onTap: (){
                  if(widget.response.details!.qa_qc_package.length==0){
                    widget.response.details!.qa_qc_package.addAll(widget.response.qa_qc_package_object!);
                  }
                  _con!.saveTask(widget.response, widget.response.details!.toMap());
                  Navigator.pop(context,1);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: ChipBorderWidget('Submit',
                  fontSize: 12, color: Colors.white, onTap: () {
                    if(widget.response.details!.qa_qc_package.length==0){
                      widget.response.details!.qa_qc_package.addAll(widget.response.qa_qc_package_object!);
                    }
                    _con!.submitTask(widget.response);
                   }),
            ),
          ],
        )
      ],
    );
  }

  Widget _ShotcreteSurfacePreparationPackage() {
    SurfaceModel surfaceModel = widget.response.details!.surface_preparation_package;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderTxtWidget(
          'Shotcrete & Surface Preparation Package',
          color: Colors.white,
        ),
        const SizedBox(
          height: 10,
        ),
        DropdownWidget(
          "Water Control/Management Completed.",
          list: yesNoList,
          selected: getValidateValue(surfaceModel.control_management),
          onChanged: (v) {
            setState(() {
              surfaceModel.control_management = v.value;
            });
          },
        ),
        DropdownWidget(
          "Membrane Applied",
          list: yesNoList,
          selected: getValidateValue(surfaceModel.membrane),
          onChanged: (v) {
            setState(() {
              surfaceModel.membrane = v.value;
            });
          },
        ),
        DropdownWidget(
          "Surface Scaled (removal of overspray or debris)",
          list: yesNoList,
          selected: getValidateValue(surfaceModel.surface_scaled),
          onChanged: (v) {
            setState(() {
              surfaceModel.surface_scaled = v.value;
            });
          },
        ),
        DropdownWidget(
          "Bolts Installed",
          list: yesNoList,
          selected: getValidateValue(surfaceModel.bolts_installed),
          onChanged: (v) {
            setState(() {
              surfaceModel.bolts_installed = v.value;
            });
          },
        ),
        DropdownWidget(
          "Anchors Installed or Extended",
          list: yesNoList,
          selected: getValidateValue(surfaceModel.anchors),
          onChanged: (v) {
            setState(() {
              surfaceModel.anchors = v.value;
            });
          },
        ),
        DropdownWidget(
          "Mesh Installed",
          list: yesNoList,
          selected: getValidateValue(surfaceModel.mesh_installed),
          onChanged: (v) {
            setState(() {
              surfaceModel.mesh_installed = v.value;
            });
          },
        ),
        DropdownWidget(
          "Surface Washed",
          list: yesNoList,
          selected: getValidateValue(surfaceModel.surface_washed),
          onChanged: (v) {
            setState(() {
              surfaceModel.surface_washed = v.value;
            });
          },
        ),
        DropdownWidget(
          "Starter Bars Cleaned",
          list: yesNoList,
          selected: getValidateValue(surfaceModel.starter_bars),
          onChanged: (v) {
            setState(() {
              surfaceModel.starter_bars = v.value;
            });
          },
        ),
        DropdownWidget(
          "Barriers & Signage in Place",
          list: yesNoList,
          selected: getValidateValue(surfaceModel.barriers),
          onChanged: (v) {
            setState(() {
              surfaceModel.barriers = v.value;
            });
          },
        ),
        DropdownWidget(
          "Depth Pins",
          list: yesNoList,
          selected: getValidateValue(surfaceModel.depth),
          onChanged: (v) {
            setState(() {
              surfaceModel.depth = v.value;
            });
          },
        ),
      ],
    );
  }

  Widget _CompletationPackage() {
    EquipmentCleaningModel model=widget.response.details!.completion_equipment_cleaning_package;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderTxtWidget(
          'Completion & Equipment Cleaning Package',
          color: Colors.white,
        ),
        const SizedBox(
          height: 10,
        ),
        DropdownWidget(
          "Barriers & Signage in Place",
          list: yesNoList,
          selected: getValidateValue(model.barriers_signage),
          onChanged: (v) {
            setState(() {
              model.barriers_signage = v.value;
            });
          },
        ),
        DropdownWidget(
          "Lines Cleaned",
          list: yesNoList,
          selected: getValidateValue(model.lines_cleaned),
          onChanged: (v) {
            setState(() {
              model.lines_cleaned = v.value;
            });
          },
        ),
        DropdownWidget(
          "Hopper Cleaned",
          list: yesNoList,
          selected: getValidateValue(model.hopper_cleaned),
          onChanged: (v) {
            setState(() {
              model.hopper_cleaned = v.value;
            });
          },
        ),
        DropdownWidget(
          "Machine Cleaned",
          list: yesNoList,
          selected: getValidateValue(model.machine_Cleaned),
          onChanged: (v) {
            setState(() {
              model.machine_Cleaned = v.value;
            });
          },
        ),
        DropdownWidget(
          "Faults/Repairs Reported",
          list: yesNoList,
          selected: getValidateValue(model.faults_repairs),
          onChanged: (v) {
            setState(() {
              model.faults_repairs = v.value;
            });
          },
        ),
        SubTxtWidget(
          "Date",
          color: Colors.white,
        ),
        InkWell(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 50,
            alignment: AlignmentDirectional.centerStart,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
                border: Border.all(color: ThemeColor.colorPrimary)),
            child: SubTxtWidget('${model.delay_date}'),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2100));
            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
              setState(() {
                model.delay_date =
                    formattedDate; //set output date to TextField value.
              });
            }
          },
        ),
        InputWidget(
          sub_title: "Delay",
          onChanged: (v) {
            model.delay = v.toString();
          },
          controller: TextEditingController()..text = model.delay,
          color: Colors.white,
          inputType: TextInputType.number,
        ),
        InputWidget(
          sub_title: "Note",
          onChanged: (v) {
            model.note = v.toString();
          },
          controller: TextEditingController()..text = model.note,
          color: Colors.white,
          height: 150,
        ),
      ],
    );
  }

  Widget _ApplicationPackage() {
    SoftcutApplicationModel model=widget.response.details!.shotcrete_application_package;
    if(_con!.equipmentList.isNotEmpty){
      if(model.euipment_performance_push_key.toString()=="0"){
        model.euipment_performance_push_key=_con!.equipmentList.first.value;
      }
    }
    if(_con!.NameIDofNozzlemanList.isNotEmpty){
      if(model.name_id_nozzleman.isEmpty){
        model.name_id_nozzleman=_con!.NameIDofNozzlemanList.first.value;
      }
    }
    if(TimeCompletion.value.text.isEmpty){
      TimeCompletion.text=model.accelerator;
    }
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderTxtWidget(
          'Shotcrete Application Package',
          color: Colors.white,
        ),
        const SizedBox(
          height: 10,
        ),
        DropdownWidget(
          "Equipment Pre-Starts",
          list: yesNoList,
          selected: getValidateValue(model.equipment),
          onChanged: (v) {
            setState(() {
              model.equipment = v.value;
            });
          },
        ),
        if(_con!.equipmentList.isNotEmpty)
        DropdownWidget(
          "Equipment",
          list: _con!.equipmentList,
          selected: _con!.equipmentList[int.parse(model.euipment_performance_postion)],
          onChanged: (v) {
            setState(() {
              model.euipment_performance_postion = _con!.equipmentList.indexOf(v).toString();
              model.euipment_performance_push_key=v.value;
            });
          },
        ),
        SubTxtWidget(
          "Equipment use Date",
          color: Colors.white,
        ),
        InkWell(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 50,
            alignment: AlignmentDirectional.centerStart,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
                border: Border.all(color: ThemeColor.colorPrimary)),
            child: SubTxtWidget('${model.euipment_performance_date}'),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2100));
            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
              setState(() {
                model.euipment_performance_date =
                    formattedDate; //set output date to TextField value.
              });
            }
          },
        ),
        InputWidget(
          sub_title: "Equipment number of hours",
          onChanged: (v) {
            model.equipment_number_of_hours = v.toString();
          },
          controller: TextEditingController()..text = model.equipment_number_of_hours,
          color: Colors.white,
          inputType: TextInputType.number,
        ),
        if(_con!.NameIDofNozzlemanList.isNotEmpty)
        DropdownWidget(
          "Name & ID of Nozzleman.",
          list: _con!.NameIDofNozzlemanList,
          selected: _con!.NameIDofNozzlemanList.where((element) => element.value==model.name_id_nozzleman).first,
          onChanged: (v) {
            setState(() {
              model.name_id_nozzleman = v.value;
            });
          },
        ),
        InputWidget(
          sub_title: "Ambient Temperature (Celsius)",
          onChanged: (v) {
            model.ambient_temperature = v.toString();
          },
          controller: TextEditingController()..text = model.ambient_temperature,
          color: Colors.white,
        ),
        DropdownWidget(
          "Methods Used",
          list: _con!.MethodsUsedList,
          selected: _con!.MethodsUsedList[int.parse(model.methods_used)],
          onChanged: (v) {
            setState(() {
              model.methods_used = _con!.MethodsUsedList.indexOf(v).toString();
            });
          },
        ),
        InputWidget(
          sub_title: "Location Sprayed",
          onChanged: (v) {
            model.location_sprayed = v.toString();
          },
          controller: TextEditingController()..text = model.location_sprayed,
          color: Colors.white,
        ),
        InputWidget(
          sub_title: "Chainage (Start to Finish)",
          onChanged: (v) {
            model.chainage = v.toString();
          },
          controller: TextEditingController()..text = model.chainage,
          color: Colors.white,
        ),
        InputWidget(
          sub_title: "Bays",
          onChanged: (v) {
            model.bays = v.toString();
          },
          controller: TextEditingController()..text = model.bays,
          color: Colors.white,
          inputType: TextInputType.number,
        ),
        DropdownWidget(
          "Position",
          list: _con!.PositionList,
          selected: _con!.PositionList[int.parse(model.position)],
          onChanged: (v) {
            setState(() {
              model.position = _con!.PositionList.indexOf(v).toString();
            });
          },
        ),
        InputWidget(
          sub_title: "Volume Applied",
          onChanged: (v) {
            model.volume = v.toString();
            _con!.new_volume=v.toString();
          },
          controller: TextEditingController()..text = model.volume.toString(),
          color: Colors.white,
          inputType: TextInputType.number,
        ),
        InputWidget(
          sub_title: "Dump volume",
          onChanged: (v) {
            model.dump_volume = v.toString();
          },
          controller: TextEditingController()..text = model.dump_volume,
          color: Colors.white,
        ),
        SubTxtWidget(
          'Accelerator Dosage (%)',
          color: Colors.white,
        ),
        SubTxtWidget(
          'Time Completion',
          color: Colors.white,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: InputWidget(
                controller: TimeCompletion,
                color: Colors.white,
                inputType: TextInputType.number,
                onChanged: (v) {
                  setState(() {
                    model.accelerator=TimeCompletion.value.text.toString();
                  });
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 50,
                alignment: AlignmentDirectional.centerStart,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey.shade300,
                    border: Border.all(color: ThemeColor.colorPrimary)),
                child: SubTxtWidget(TimeCompletion.value.text.toString().isEmpty
                    ? "0.0"
                    : double.parse(TimeCompletion.value.text.toString())
                        .toStringAsFixed(1)),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SubTxtWidget(
              '(IBC)',
              color: Colors.white,
            ),
          ],
        ),
        DropdownWidget(
          "Primary or Secondary Lining",
          list: _con!.PrimaryorSecondaryLiningList,
          selected: _con!.PrimaryorSecondaryLiningList[int.parse(model.primary)],
          onChanged: (v) {
            setState(() {
              model.primary = _con!.PrimaryorSecondaryLiningList.indexOf(v).toString();
            });
          },
        ),
        InputWidget(
          sub_title: "Thickness Applied",
          onChanged: (v) {
            model.Thickness = v.toString();
          },
          controller: TextEditingController()..text = model.Thickness,
          color: Colors.white,
          inputType: TextInputType.number,
        ),
        SubTxtWidget(
          'Time Completion',
          color: Colors.white,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubTxtWidget(
                    "Start Time",
                    color: Colors.white,
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      height: 50,
                      alignment: AlignmentDirectional.centerStart,
                      child: SubTxtWidget('${model.start_time}'),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          border: Border.all(color: ThemeColor.colorPrimary)),
                    ),
                    onTap: () async {
                      TimeOfDay? timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                        initialEntryMode: TimePickerEntryMode.dial,
                      );
                      if (timeOfDay != null && timeOfDay != selectedTime) {
                        String formattedDate = timeOfDay
                            .format(context)
                            .toString(); // DateFormat('hh:mm').format(selectedTime.);
                        setState(() {
                          model.start_time =
                              formattedDate; //set output date to TextField value.
                        });
                      }
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubTxtWidget(
                    "Completion Time",
                    color: Colors.white,
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      height: 50,
                      alignment: AlignmentDirectional.centerStart,
                      child: SubTxtWidget('${model.time_completion}'),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          border: Border.all(color: ThemeColor.colorPrimary)),
                    ),
                    onTap: () async {
                      TimeOfDay? timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                        initialEntryMode: TimePickerEntryMode.dial,
                      );
                      if (timeOfDay != null && timeOfDay != selectedTime) {
                        String formattedDate = timeOfDay
                            .format(context)
                            .toString(); // DateFormat('hh:mm').format(selectedTime.);
                        setState(() {
                          model.time_completion =
                              formattedDate; //set output date to TextField value.
                        });
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        DropdownWidget(
          "Finish Requirements",
          list: _con!.FinishRequirementsList,
          selected: _con!.FinishRequirementsList[int.parse(model.finish_requirements)],
          onChanged: (v) {
            setState(() {
              model.finish_requirements = _con!.FinishRequirementsList.indexOf(v).toString();
            });
          },
        ),
      ],
    );
  }

  Widget _MonitoringPackage() {
    MonitoringModel model=widget.response.details!.applied_monitoring_package;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderTxtWidget(
          'Applied Monitoring Package',
          color: Colors.white,
        ),
        const SizedBox(
          height: 10,
        ),
        DropdownWidget(
          "Scanner Used Prior",
          list: yesNoList,
          selected: getValidateValue(model.scanner_used),
          onChanged: (v) {
            setState(() {
              model.scanner_used = v.value;
            });
          },
        ),
        DropdownWidget(
          "Depth Pins/String Lines",
          list: yesNoList,
          selected: getValidateValue(model.depth_pins),
          onChanged: (v) {
            setState(() {
              model.depth_pins = v.value;
            });
          },
        ),
        DropdownWidget(
          "Profile Bars",
          list: yesNoList,
          selected: getValidateValue(model.profile_bars),
          onChanged: (v) {
            setState(() {
              model.profile_bars = v.value;
            });
          },
        ),
        DropdownWidget(
          "Scanner Used After",
          list: yesNoList,
          selected: getValidateValue(model.scanner_used_after),
          onChanged: (v) {
            setState(() {
              model.scanner_used_after = v.value;
            });
          },
        ),
        DropdownWidget(
          "Completed & Signed Off",
          list: yesNoList,
          selected: getValidateValue(model.completed_signed),
          onChanged: (v) {
            setState(() {
              model.completed_signed = v.value;
            });
          },
        ),
      ],
    );
  }

  Widget _ChemicalAdded() {
    ChemicalAddedModel model=widget.response.details!.chemical_added;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderTxtWidget(
          'Chemical Added',
          color: Colors.white,
        ),
        const SizedBox(
          height: 10,
        ),
        InputWidget(
          sub_title: "Superplastersizer (Ltrs)",
          onChanged: (v) {
            model.plaster_sizer = v.toString();
          },
          controller: TextEditingController()..text = model.plaster_sizer,
          color: Colors.white,
          inputType: TextInputType.number,
        ),
        InputWidget(
          sub_title: "HCA (Ltrs)",
          onChanged: (v) {
            model.hca = v.toString();
          },
          controller: TextEditingController()..text = model.hca,
          color: Colors.white,
          inputType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _fiberAdd() {
    FiberAddedModel model=widget.response.details!.fiber_added;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderTxtWidget(
          'Fiber Added',
          color: Colors.white,
        ),
        const SizedBox(
          height: 10,
        ),
        InputWidget(
          sub_title: "Mono (KG)",
          onChanged: (v) {
            model.mono = v.toString();
          },
          controller: TextEditingController()..text = model.mono,
          color: Colors.white,
          inputType: TextInputType.number,
        ),
        InputWidget(
          sub_title: "Duro (KG)",
          onChanged: (v) {
            model.duro = v.toString();
          },
          controller: TextEditingController()..text = model.duro,
          color: Colors.white,
          inputType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _Attachment() {
    TaskDetailsModel detailsModel = widget.response.details!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderTxtWidget(
          'Attachment(Pdf/Doc/Xls)',
          color: Colors.white,
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          child: Row(
            children: [
              Icon(
                Icons.attach_file,
                color: Colors.white,
                size: 30,
              ),
              SubTxtWidget(
                "${detailsModel.attachment_link}",
                color: Colors.white,
              ),
            ],
          ),
          onTap: () async {
            await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['ppt', 'pdf', 'doc'],
            ).then((value){
              if(value!=null){
                _con!.addFile(value.files.first).then((value){
                  setState(() {
                    widget.response.attachment_link=value;
                  });
                });
              }
            });
          },
        )
      ],
    );
  }

  Widget _Signature() {
    TaskDetailsModel detailsModel = widget.response.details!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        HeaderTxtWidget(
          'Signature',
          color: Colors.white,
        ),
        const SizedBox(
          height: 10,
        ),
        Signature(
          controller: _controller,
          width: 300,
          height: 300,
          backgroundColor: Colors.white,
        ),
        const SizedBox(
          height: 10,
        ),
        SubTxtWidget(detailsModel.signature),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChipBorderWidget(
              'Done',
              fontSize: 12,
              onTap: () async {
              var image= await _controller.toPngBytes();
                _con!.addSignature(image).then((value){
                  setState(() {
                    widget.response.attachment_link=value;
                    widget.response.signature=value;
                  });
                });
              },
              color: Colors.white,
              width: 100,
            ),
            ChipBorderWidget(
              'Clear',
              fontSize: 12,
              color: Colors.white,
              width: 100,
              onTap: (){
                _controller.clear();
              },
            ),

          ],
        ),
      ],
    );
  }

  Widget _QaPackage() {
    if(widget.response.details!.qa_qc_package.length>0) {
      TaskDetailsModel detailsModel = widget.response.details!;

      return ListView.builder(
        itemBuilder: (context, index) {
          DetailsModel model = detailsModel.qa_qc_package[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderTxtWidget(
                'QA/QC Shotcrete Mix Package (Load ${index + 1})',
                color: Colors.white,
              ),
              const SizedBox(
                height: 10,
              ),
              SubTxtWidget(
                "Date",
                color: Colors.white,
              ),
              InkWell(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 50,
                  alignment: AlignmentDirectional.centerStart,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border: Border.all(color: ThemeColor.colorPrimary)),
                  child: SubTxtWidget('${model.date}'),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2100));
                  if (pickedDate != null) {
                    String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      model.date =
                          formattedDate; //set output date to TextField value.
                    });
                  }
                },
              ),
              SubTxtWidget(
                "Time",
                color: Colors.white,
              ),
              InkWell(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 50,
                  alignment: AlignmentDirectional.centerStart,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border: Border.all(color: ThemeColor.colorPrimary)),
                  child: SubTxtWidget('${model.time}'),
                ),
                onTap: () async {
                  TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                    initialEntryMode: TimePickerEntryMode.dial,
                  );
                  if (timeOfDay != null && timeOfDay != selectedTime) {
                    String formattedDate = timeOfDay
                        .format(context)
                        .toString(); // DateFormat('hh:mm').format(selectedTime.);
                    setState(() {
                      model.time =
                          formattedDate; //set output date to TextField value.
                    });
                  }
                },
              ),
              if(_con!.NameIDofNozzlemanList.isNotEmpty)
                DropdownWidget(
                  "Name & ID",
                  selected:model.name_id_name.toString().isEmpty?null: _con!
                      .NameIDofNozzlemanList
                      .where((element) => element.title == model.name_id_name)
                      .first,
                  list: _con!.NameIDofNozzlemanList,
                  onChanged: (v) {
                    setState(() {
                      model.name_id_name = v.title;
                    });
                  },
                ),
              InputWidget(
                sub_title: "Location",
                onChanged: (v) {
                  model.location = v.toString();
                },
                controller: TextEditingController()
                  ..text = model.location,
                color: Colors.white,
              ),
              InputWidget(
                sub_title: "Docket Number",
                onChanged: (v) {
                  model.docket_number = v.toString();
                },
                controller: TextEditingController()
                  ..text = model.docket_number,
                color: Colors.white,
              ),
              InputWidget(
                sub_title: "Mix Design",
                onChanged: (v) {
                  model.mix_design = v.toString();
                },
                controller: TextEditingController()
                  ..text = model.mix_design,
                color: Colors.white,
              ),
              InputWidget(
                sub_title: "Mix Temperature (Celsius)",
                onChanged: (v) {
                  model.mix_temperature = v.toString();
                },
                controller: TextEditingController()
                  ..text = model.mix_temperature,
                color: Colors.white,
              ),
              InputWidget(
                sub_title: "Flow/Slump Test Results (mm)",
                onChanged: (v) {
                  model.flow_slump_results = v.toString();
                },
                controller: TextEditingController()
                  ..text = model.flow_slump_results,
                color: Colors.white,
              ),
            ],
          );
        },
        itemCount: detailsModel.qa_qc_package.length,
        primary: false,
        shrinkWrap: true,
      );
    }else if(widget.response.qa_qc_package_object!=null){
      return ListView.builder(
        itemBuilder: (context, index) {
          DetailsModel model = widget.response.qa_qc_package_object![index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderTxtWidget(
                'QA/QC Shotcrete Mix Package (Load ${index + 1})',
                color: Colors.white,
              ),
              const SizedBox(
                height: 10,
              ),
              SubTxtWidget(
                "Date",
                color: Colors.white,
              ),
              InkWell(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 50,
                  alignment: AlignmentDirectional.centerStart,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border: Border.all(color: ThemeColor.colorPrimary)),
                  child: SubTxtWidget('${model.date}'),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2100));
                  if (pickedDate != null) {
                    String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      model.date =
                          formattedDate; //set output date to TextField value.
                    });
                  }
                },
              ),
              SubTxtWidget(
                "Time",
                color: Colors.white,
              ),
              InkWell(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 50,
                  alignment: AlignmentDirectional.centerStart,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border: Border.all(color: ThemeColor.colorPrimary)),
                  child: SubTxtWidget('${model.time}'),
                ),
                onTap: () async {
                  TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                    initialEntryMode: TimePickerEntryMode.dial,
                  );
                  if (timeOfDay != null && timeOfDay != selectedTime) {
                    String formattedDate = timeOfDay
                        .format(context)
                        .toString(); // DateFormat('hh:mm').format(selectedTime.);
                    setState(() {
                      model.time =
                          formattedDate; //set output date to TextField value.
                    });
                  }
                },
              ),
              if(_con!.NameIDofNozzlemanList.isNotEmpty)
                DropdownWidget(
                  "Name & ID",
                  selected:model.name_id_name.toString().isEmpty?null: _con!
                      .NameIDofNozzlemanList
                      .where((element) => element.title == model.name_id_name)
                      .first,
                  list: _con!.NameIDofNozzlemanList,
                  onChanged: (v) {
                    setState(() {
                      model.name_id_name = v.title;
                    });
                  },
                ),
              InputWidget(
                sub_title: "Location",
                onChanged: (v) {
                  model.location = v.toString();
                },
                controller: TextEditingController()
                  ..text = model.location,
                color: Colors.white,
              ),
              InputWidget(
                sub_title: "Docket Number",
                onChanged: (v) {
                  model.docket_number = v.toString();
                },
                controller: TextEditingController()
                  ..text = model.docket_number,
                color: Colors.white,
              ),
              InputWidget(
                sub_title: "Mix Design",
                onChanged: (v) {
                  model.mix_design = v.toString();
                },
                controller: TextEditingController()
                  ..text = model.mix_design,
                color: Colors.white,
              ),
              InputWidget(
                sub_title: "Mix Temperature (Celsius)",
                onChanged: (v) {
                  model.mix_temperature = v.toString();
                },
                controller: TextEditingController()
                  ..text = model.mix_temperature,
                color: Colors.white,
              ),
              InputWidget(
                sub_title: "Flow/Slump Test Results (mm)",
                onChanged: (v) {
                  model.flow_slump_results = v.toString();
                },
                controller: TextEditingController()
                  ..text = model.flow_slump_results,
                color: Colors.white,
              ),
            ],
          );
        },
        itemCount: widget.response.qa_qc_package_object!.length,
        primary: false,
        shrinkWrap: true,
      );
    }
    return Container();
  }
}
