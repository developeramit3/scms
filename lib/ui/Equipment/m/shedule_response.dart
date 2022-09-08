

class SheduleResponse {
  dynamic key;
  dynamic start_date;
  dynamic end_date;
  dynamic details;
  SheduleResponse({
     this.key,
     this.start_date,
     this.end_date,
     this.details,
  });
  Map<String,dynamic>toMap(){
    Map<String,dynamic>map=Map();

    return map;
  }
}
