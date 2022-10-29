


class MaterialResponse {
  bool status;
  String message;
  List<Materialll>list;



  MaterialResponse.fromJson(Map<String, dynamic> json)
      : status = json["success"],
        message = json["message"],
        list = json['data'].map<Materialll>((value) => Materialll.fromJson(value)).toList();

  Map<String, dynamic> toJson() => {
    'success': status,
    'message': message,
  };
}
class Materialll {
  dynamic id;
  dynamic project_id;
  dynamic type;
  dynamic accelerator;
  dynamic fiber_1;
  dynamic fiber_2;
  dynamic hsc;
  dynamic super_plaster_size;



  Materialll.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        project_id = json["project_id"],
        type = json["type"],
        fiber_1 = json["fiber_1"]??"0",
        fiber_2 = json["fiber_2"]??"0",
        hsc = json["hsc"]??"0",
        super_plaster_size = json["super_plaster_size"]??"0",
        accelerator = json["accelerator"]??"0";

  Map<String, dynamic> toJson() => {
    'id': id,
    'project_id': project_id,
    'type': type,
    'fiber_1': fiber_1,
    'fiber_2': fiber_2,
    'hsc': hsc,
    'super_plaster_size': super_plaster_size,
    'accelerator': accelerator,
  };
}

