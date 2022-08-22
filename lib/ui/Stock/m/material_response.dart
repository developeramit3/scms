

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
    map['accelerator']=accelerator;
    map['super_plaster_size']=super_plaster_size;
    map['fiber_1']=fiber_1;
    map['fiber_2']=fiber_2;
    map['hsc']=hsc;
    return map;
  }
}
