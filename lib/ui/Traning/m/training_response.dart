


class TrainingResponse {
  bool status;
  String message;
  List<Training>list;



  TrainingResponse.fromJson(Map<String, dynamic> json)
      : status = json["success"],
        message = json["message"],
        list = json['data'].map<Training>((value) => Training.fromJson(value)).toList();

  Map<String, dynamic> toJson() => {
    'success': status,
    'message': message,
  };
}
class Training {
  dynamic id;
  dynamic project_id;
  dynamic type;
  dynamic link;
  dynamic file_name;



  Training.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        project_id = json["project_id"],
        type = json["type"],
        link = json["link"],
        file_name = json["file_name"];

  Map<String, dynamic> toJson() => {
    'id': id,
    'project_id': project_id,
    'type': type,
    'link': link,
    'file_name': file_name,
  };
}

