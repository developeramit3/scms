

class PerformanceResponse {
  dynamic key;
  dynamic name;
  dynamic position;
  dynamic hkid;
  dynamic cwr;
  dynamic cwrExpiryDate;
  dynamic greenCard;
  dynamic expiryDate;
  PerformanceResponse({
     this.key,
     this.name,
     this.position,
     this.cwr,
     this.cwrExpiryDate,
     this.greenCard,
     this.expiryDate,
     this.hkid});
  Map<String,dynamic>toMap(){
    Map<String,dynamic>map=Map();

    return map;
  }
}
