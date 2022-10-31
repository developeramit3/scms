
class UserDetails {
  dynamic user_id;
  dynamic token;
  dynamic name;
  dynamic user_type;

  UserDetails.fromJson(Map<String, dynamic> json)
      : token = json["token"],
        user_id = json["user_id"],
        name = json["name"],
        user_type = json["user_type"];



}
