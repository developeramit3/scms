import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/ui/Gallery/v/view_photo.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../../../widgets/picker_dailog_widget.dart';
import '../c/gallery_controller.dart';

class GalleryPage extends StatefulWidget {

  @override
  _PageState createState() => _PageState();

}

class _PageState extends StateMVC<GalleryPage> {
  GalleryController? _con;
  int type=0;
  final ImagePicker _picker = ImagePicker();
  _PageState() : super(GalleryController()) {
    _con = controller as GalleryController?;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con!.scaffoldKey,
      persistentFooterButtons:[
        if(_con!.user!=null&&_con!.user!.user_type=="1")
         Center(
           child: ChipWidget('Upload',width: 150,onTap: () async {
             showDialog(
                 context: context,
                 builder: (ctxt) => PickerDailogWidget(listener: (t) async {
                   if(type==0){
                  if(t==1){
                    await _picker.pickImage(source: ImageSource.gallery).then((value){
                      if(value!=null){
                        _con!.addFile(name: value.name,path: value.path,type: type);
                      }
                    });
                  }else{
                    await _picker.pickImage(source: ImageSource.camera).then((value){
                      if(value!=null){
                        _con!.addFile(name: value.name,path: value.path,type: type);
                      }
                    });
                  }
                   }else{
                     if(t==1){
                       await _picker.pickVideo(source: ImageSource.gallery).then((value){
                         if(value!=null){
                           _con!.addFile(name: value.name,path: value.path,type: type);
                         }
                       });
                     }else{
                       await _picker.pickVideo(source: ImageSource.camera).then((value){
                         if(value!=null){
                           _con!.addFile(name: value.name,path: value.path,type: type);
                         }
                       });
                     }
                   }
                 },)
             );
           },),
         )
        ],
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Container(
                      child: HeaderTxtWidget(
                        'Photos',
                        fontSize: 16,
                      ),
                      padding: EdgeInsets.all(10),
                      alignment: AlignmentDirectional.center,
                      decoration:BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: type==0?ThemeColor.colorPrimary:Colors.grey.shade400,width: 2),
                          )
                      ),
                    ),
                    onTap: (){
                      if(type!=0){
                        type=0;
                        _con!.getGallery(type);
                      }
                    },
                  )
              ),
              Container(
                color: Colors.grey.shade400,
                width: 1,
                height: 40,
              ),
              Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Container(
                      child: HeaderTxtWidget(
                        'Videos',
                        fontSize: 16,
                      ),
                      padding: EdgeInsets.all(10),
                      alignment: AlignmentDirectional.center,
                      decoration:BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: type==1?ThemeColor.colorPrimary:Colors.grey.shade400,width: 2),
                          )
                      ),
                    ),
                    onTap: (){
                      if(type!=1){
                        type=1;
                        _con!.getGallery(type);
                      }
                    },
                  )
              ),
            ],
          ),
          _files()
        ],
      ),
      
    );
  }
  Widget _files() {
    if (_con!.isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade500,
        enabled: true,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: Container(
                  height: 100,
                  color: Colors.grey,
                  margin: const EdgeInsets.only(bottom: 5, top: 5),
                ),flex: 1,),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: Container(
                  height: 100,
                  color: Colors.grey,
                  margin: const EdgeInsets.only(bottom: 5, top: 5),
                ),flex: 1,),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: Container(
                  height: 100,
                  color: Colors.grey,
                  margin: const EdgeInsets.only(bottom: 5, top: 5),
                ),flex: 1,),
                const SizedBox(
                  width: 10,
                ),
              ],
            )),
      );
    } else {
      return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                itemCount: _con!.list.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6.0,
                    mainAxisSpacing: 6.0),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      if(type==1){
                        Navigator.pushNamed(context, '/video',arguments: _con!.list[index].link);
                      }else{
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) {
                                return ViewPhotos(
                                  imageIndex: index,
                                  imageList: _con!.list,
                                  heroTitle: "image$index",
                                );
                              },
                              fullscreenDialog: true));
                    }
                      },
                    child: Container(
                      child: Hero(
                          tag: "photo$index",
                          child:type==1?Image.file(File(_con!.list[index].thumb)):CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: _con!.list[index].link,
                            placeholder: (context, url) => Container(
                                child: Center(child: CupertinoActivityIndicator())),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                      ),
                    ),
                  );
                }),
          ));
    }
  }
}
