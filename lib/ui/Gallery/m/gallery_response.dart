

class GalleryResponse {
  bool status;
  String message;
  List<Gallery>list;



  GalleryResponse.fromJson(Map<String, dynamic> json)
      : status = json["success"],
        message = json["message"],
        list = json['data'].map<Gallery>((value) => Gallery.fromJson(value)).toList();

  Map<String, dynamic> toJson() => {
    'success': status,
    'message': message,
  };
}
class Gallery {
  dynamic id;
  dynamic project_id;
  dynamic type;
  dynamic link;
  dynamic thumb;



  Gallery.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        project_id = json["project_id"],
        type = json["type"],
        link = json["link"];

  Map<String, dynamic> toJson() => {
    'id': id,
    'project_id': project_id,
    'type': type,
    'link': link,
  };
}

