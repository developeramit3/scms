import '../../../globle/m/user_details.dart';

class LoginResponse {
  bool status;
  String message;
  UserDetails userDetails;



  LoginResponse.fromJson(Map<String, dynamic> json)
      : status = json["success"],
        message = json["message"],
        userDetails = UserDetails.fromJson(json['data']);

  Map<String, dynamic> toJson() => {
        'success': status,
        'message': message,
      };
}
