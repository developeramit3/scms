
import 'package:scms/generated/l10n.dart';

class UserModel {
  dynamic uid;
  dynamic name;
  dynamic email;
  dynamic password;
  dynamic user_type;
  UserModel({required this.name,required this.email,required this.uid, required this.password,required this.user_type});

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        name = json["name"]??"",
        password = json["password"]??"",
        user_type = json["user_type"]??"",
        email = json["email"]??"";
  Map<String,dynamic>toMap(){
    Map<String,dynamic>map=Map();
    map['uid']=uid;
    map['name']=name;
    map['email']=email;
    map['password']=password;
    map['user_type']=user_type;
    return map;
  }
}
