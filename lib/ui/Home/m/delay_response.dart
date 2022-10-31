

class DelayResponse {
  bool status;
  String message;
  List<Delay>list;



  DelayResponse.fromJson(Map<String, dynamic> json)
      : status = json["success"]??false,
        message = json["message"]??"",
        list = json['data']==null?[]:json['data'].map<Delay>((value) => Delay.fromJson(value)).toList();

  Map<String, dynamic> toJson() => {
    'success': status,
    'message': message,
  };
}
class Delay {
  dynamic id;
  dynamic user_id;
  dynamic delay;
  dynamic delay_date;



  Delay.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        user_id = json["user_id"],
        delay = json["delay"],
        delay_date = json["delay_date"];

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': user_id,
    'delay': delay,
  };
}

