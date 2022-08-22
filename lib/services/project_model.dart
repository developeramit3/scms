
import 'package:scms/generated/l10n.dart';

class ProjectModel {
  dynamic project;
  dynamic project_real_name;
  dynamic project_total_wastage;
  dynamic project_total_volume;
  dynamic was_per;

  ProjectModel.fromJson(Map<String, dynamic> json)
      : project = json["project"],
        project_real_name = json["project_real_name"]??"",
        project_total_volume = json["project_total_volume"]??"",
        was_per = json["was_per"]??"",
        project_total_wastage = json["project_total_wastage"]??"";

}
