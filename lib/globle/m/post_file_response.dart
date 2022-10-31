
class PostFileResponse {
  bool status;
  String message;
  String file_path;



  PostFileResponse.fromJson(Map<String, dynamic> json)
      : status = json["success"],
        message = json["message"],
        file_path = json["data"]!=null?json["data"]['file_path']:"";

  Map<String, dynamic> toJson() => {
        'success': status,
        'message': message,
      };
}
