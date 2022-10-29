

class EquipmentResponse {
  bool status;
  String message;
  List<Equipment>list;



  EquipmentResponse.fromJson(Map<String, dynamic> json)
      : status = json["success"],
        message = json["message"],
  list = json['data'].map<Equipment>((value) => Equipment.fromJson(value)).toList();

  Map<String, dynamic> toJson() => {
    'success': status,
    'message': message,
  };
}
class Equipment {
  dynamic id;
  dynamic user_id;
  dynamic name;
  dynamic created_at;



  Equipment.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        user_id = json["user_id"],
        name = json["name"],
        created_at = json["created_at"];

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': user_id,
    'name': name,
  };
}
