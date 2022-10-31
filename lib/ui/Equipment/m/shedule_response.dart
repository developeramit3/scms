

class SheduleResponse {
  bool status;
  String message;
  List<Shedule>list;



  SheduleResponse.fromJson(Map<String, dynamic> json)
      : status = json["success"],
        message = json["message"],
        list = json['data'].map<Shedule>((value) => Shedule.fromJson(value)).toList();

  Map<String, dynamic> toJson() => {
    'success': status,
    'message': message,
  };
}
class Shedule {
  dynamic id;
  dynamic start_date;
  dynamic end_date;
  dynamic project_id;
  dynamic details;
  dynamic link;
  dynamic file_name;
  dynamic type;



  Shedule.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        start_date = json["start_date"],
        end_date = json["end_date"],
        details = json["details"],
        link = json["link"],
        file_name = json["file_name"],
        type = json["type"]??1,
        project_id = json["project_id"];

  Map<String, dynamic> toJson() => {
    'id': id,
    'start_date': start_date,
    'end_date': end_date,
    'details': details,
    'file_name': file_name,
    'project_id': project_id,
    'link': link,
    'type': type,
  };
}

