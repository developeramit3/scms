

class TrialsResponse {
  dynamic key;
  dynamic start_date;
  dynamic end_date;
  dynamic details;
  dynamic link;
  dynamic filename;
  TrialsResponse({
     this.key,
     this.start_date,
     this.end_date,
     this.details,
     this.link,
     this.filename,
  });
  Map<String,dynamic>toMap(){
    Map<String,dynamic>map=Map();

    return map;
  }
}
