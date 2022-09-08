

class MaterialResponse {
  dynamic accelerator;
  dynamic super_plaster_size;
  dynamic fiber_1;
  dynamic hsc;
  dynamic fiber_2;
  MaterialResponse({
     this.accelerator,
     this.super_plaster_size,
     this.fiber_1,
     this.fiber_2,
     this.hsc});
  Map<String,dynamic>toMap(){
    Map<String,dynamic>map=Map();
    map['accelerator']=accelerator??"0";
    map['super_plaster_size']=super_plaster_size??"0";
    map['fiber_1']=fiber_1??"0";
    map['fiber_2']=fiber_2??"0";
    map['hsc']=hsc??"0";
    return map;
  }
}
