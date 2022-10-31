
class ErrorResponse {
  dynamic code;
  String message;

  ErrorResponse.fromJson(Map<String, dynamic> json)
      : code = json["code"],
        message = json["message"]??"";


}
