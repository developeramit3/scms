
class ProjectModel {
  bool status;
  String message;
  List<Project>list;



  ProjectModel.fromJson(Map<String, dynamic> json)
      : status = json["success"],
        message = json["message"],
        list = json['data'].map<Project>((value) => Project.fromJson(value)).toList();

  Map<String, dynamic> toJson() => {
    'success': status,
    'message': message,
  };
}
class Project {
  dynamic id;
  dynamic user_id;
  dynamic project_real_name;
  dynamic project_total_volume;
  dynamic project_total_wastage;
  dynamic was_per;
  dynamic volume;
  dynamic start_day;
  dynamic volume_complete_day;
  Project();

  Project.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        user_id = json["user_id"],
        project_real_name = json["project_real_name"]??"",
        project_total_volume = double.tryParse(json["project_total_volume"].toString())??0,
        project_total_wastage = double.tryParse(json["project_total_wastage"].toString())??0,
        was_per = double.tryParse(json["was_per"].toString())??0,
        volume = json["volume"]??"0",
        start_day = json["start_day"]??"",
        volume_complete_day = json["volume_complete_day"]??"0";

  Map<String,dynamic>toMap(){
    Map<String,dynamic>map=Map();
    map['id']=id;
    map['user_id']=user_id;
    map['project_real_name']=project_real_name;
    map['project_total_volume']=project_total_volume;
    map['project_total_wastage']=project_total_wastage;
    map['volume']=volume;
    map['was_per']=was_per;
    map['start_day']=start_day;
    map['volume_complete_day']=volume_complete_day;
    return map;
  }
}
