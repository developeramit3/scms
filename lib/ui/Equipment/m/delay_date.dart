
class DelayDate {
  dynamic volume;
  dynamic euipment_performance_push_key;
  dynamic euipment_performance_date;
  dynamic equipment_number_of_hours;
  dynamic euipment_performance_name;

  DelayDate.fromJson(Map<String, dynamic> json)
      :volume = double.tryParse(json["volume"])??0,
        euipment_performance_push_key = json["euipment_performance_push_key"]??"",
        euipment_performance_date = json["euipment_performance_date"]??"",
        euipment_performance_name = json["euipment_performance_name"]??"",
        equipment_number_of_hours = double.tryParse(json["equipment_number_of_hours"])??0;
}
