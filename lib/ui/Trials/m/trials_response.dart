


class TrialsResponse {
  bool status;
  String message;
  List<Trials>list;



  TrialsResponse.fromJson(Map<String, dynamic> json)
      : status = json["success"],
        message = json["message"],
        list = json['data'].map<Trials>((value) => Trials.fromJson(value)).toList();

  Map<String, dynamic> toJson() => {
    'success': status,
    'message': message,
  };
}
class Trials {
  dynamic id;
  dynamic project_id;
  dynamic type;
  dynamic link;
  dynamic file_name;
  dynamic start_date;
  dynamic end_date;
  dynamic details;



  Trials.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        project_id = json["project_id"],
        type = json["type"],
        link = json["link"],
        end_date = json["end_date"],
        start_date = json["start_date"],
        details = json["details"],
        file_name = json["file_name"];

  Map<String, dynamic> toJson() => {
    'id': id,
    'project_id': project_id,
    'type': type,
    'link': link,
    'start_date': start_date,
    'end_date': end_date,
    'details': details,
    'file_name': file_name,
  };
}



