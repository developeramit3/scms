

class GalleryResponse {
  dynamic key;
  dynamic user_type;
  dynamic link;
  dynamic thumb;
  GalleryResponse({
     this.key,
     this.link,
     this.user_type,
     this.thumb,
  });
  Map<String,dynamic>toMap(){
    Map<String,dynamic>map=Map();

    return map;
  }
}
