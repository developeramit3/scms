
class BasicResponse {
  bool status;
  String message;



  BasicResponse.fromJson(Map<String, dynamic> json)
      : status = json["success"],
        message = json["message"];

  Map<String, dynamic> toJson() => {
        'success': status,
        'message': message,
      };
}
