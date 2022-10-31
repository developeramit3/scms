import 'dart:convert';
import 'package:scms/ui/Task/m/task_details_model.dart';

class TaskResponse {
  bool status;
  String message;
  List<TaskList> list;

  TaskResponse.fromJson(Map<String, dynamic> json)
      : status = json["success"],
        message = json["message"],
        list = json['data']
            .map<TaskList>((value) => TaskList.fromJson(value))
            .toList();

  Map<String, dynamic> toJson() => {
        'success': status,
        'message': message,
      };
}

class TaskList {
  dynamic id;
  dynamic project_id;
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

  TaskList();

  TaskList.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        project_id = json["project_id"],
        name = json["name"] ?? "",
        file_type = json["file_type"] ?? "",
        qa_qc_package = json["qa_qc_package"] ?? false,
        qa_qc_package_01 = json["qa_qc_package_01"] ?? false,
        qa_qc_package_02 = json["qa_qc_package_02"] ?? false,
        qa_qc_package_03 = json["qa_qc_package_03"] ?? false,
        qa_qc_package_04 = json["qa_qc_package_04"] ?? false,
        surface_preparation_package =
            json["surface_preparation_package"] ?? false,
        shotcrete_application_package =
            json["shortcreate_application_package"] ?? false,
        applied_monitoring_package =
            json["applied_monitoring_package"] ?? false,
        completion_equipment_cleaning_package =
            json["completion_equipment_cleaning_package"] ?? false,
        fiber_added = json["fiber_added"] ?? false,
        chemical_added = json["chemical_added"] ?? false,
        project_name = json["project_name"],
        attachment_link = json["attachment_link"],
        signature = json["signature"],
        details = json["details"] == null
            ? TaskDetailsModel.fromJson({})
            : TaskDetailsModel.fromJson(jsonDecode(json['details'])),
        qa_qc_package_object = json['qa_qc_package_object'] == null
            ? null
            : jsonDecode(json['qa_qc_package_object'])
                .map<DetailsModel>((value) => DetailsModel.fromJson(value))
                .toList();

  List<String> toQA() {
    List<String> list = [];
    qa_qc_package_object!.forEach((element) {
      list.add(jsonEncode(element.toMap()));
    });
    return list;
  }
}
