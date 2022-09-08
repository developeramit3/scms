
class ProjectResponse {
  dynamic volume;
  dynamic start_day;
  dynamic volume_complete_day;
  ProjectResponse({this.volume, this.start_day, this.volume_complete_day});


  ProjectResponse.fromJson(Map<String, dynamic> json)
      : volume = json["volume"],
        start_day = json["start_day"]??"",
        volume_complete_day = json["volume_complete_day"]??0;

  Map<String,dynamic>toMap(){
    Map<String,dynamic>map=Map();
    map['volume']=volume;
    map['start_day']=start_day;
    map['volume_complete_day']=volume_complete_day;
    return map;
  }
}
