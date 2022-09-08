
import 'dart:convert';

import 'package:scms/generated/l10n.dart';
import 'package:scms/ui/Task/m/task_details_model.dart';

class TaskResponse {
  dynamic key;
  dynamic name;
  dynamic file_type;
  TaskDetailsModel? details;
  dynamic qa_qc_package;
  dynamic qa_qc_package_01;
  dynamic qa_qc_package_02;
  dynamic qa_qc_package_03;
  dynamic qa_qc_package_04;
  dynamic project_name;
  dynamic surface_preparation_package;
  dynamic shotcrete_application_package;
  dynamic applied_monitoring_package;
  dynamic completion_equipment_cleaning_package;
  dynamic fiber_added;
  dynamic chemical_added;
  dynamic attachment_link;
  dynamic signature;
  List<DetailsModel>? qa_qc_package_object;

  TaskResponse({
     this.key,
     this.name,
     this.file_type,
     this.qa_qc_package,
     this.qa_qc_package_01,
     this.qa_qc_package_02,
     this.qa_qc_package_03,
     this.qa_qc_package_04,
     this.project_name,
     this.surface_preparation_package,
     this.shotcrete_application_package,
     this.applied_monitoring_package,
     this.completion_equipment_cleaning_package,
     this.fiber_added,
     this.chemical_added,
     this.attachment_link,
     this.signature,
    this.qa_qc_package_object,
     this.details});

  List<String> toQA() {
    List<String> list = [];
    qa_qc_package_object!.forEach((element) {
      list.add(jsonEncode(element.toMap()));
    });
    return list;
  }
}
