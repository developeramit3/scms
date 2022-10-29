

class PerformanceResponse {
  bool status;
  String message;
  List<Performance>list;



  PerformanceResponse.fromJson(Map<String, dynamic> json)
      : status = json["success"],
        message = json["message"],
        list = json['data'].map<Performance>((value) => Performance.fromJson(value)).toList();

  Map<String, dynamic> toJson() => {
    'success': status,
    'message': message,
  };
}
class Performance {
  dynamic id;
  dynamic project_id;
  dynamic name;
  dynamic position;
  dynamic hkid;
  dynamic cwr;
  dynamic cwrExpiryDate;
  dynamic greenCard;
  dynamic expiryDate;
  Performance.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        project_id = json["project_id"],
        name = json["name"],
        position = json["position"],
        hkid = json["hkid"],
        cwr = json["cwr"],
        cwrExpiryDate = json["cwr_expiry_date"]??"",
        greenCard = json["green_card"]??"",
        expiryDate = json["expiry_date"]??"";

  Map<String,dynamic>toMap(){
    Map<String,dynamic>map=Map();

    return map;
  }
}
