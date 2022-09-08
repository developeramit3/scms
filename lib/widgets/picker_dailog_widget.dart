import 'package:flutter/material.dart';
import 'package:scms/widgets/sub_txt_widget.dart';

import '../generated/l10n.dart';
import 'header_txt_widget.dart';
typedef callback =Function(int type);
class PickerDailogWidget extends StatelessWidget {
  callback? listener;
  PickerDailogWidget({this.listener});


  @override
  Widget build(BuildContext context) =>Material(
    color: Colors.transparent,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200,
          margin:const EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
              borderRadius:const BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300,blurRadius: 5)
              ]
          ),
          padding: EdgeInsets.all(10),child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_sharp,size: 50,),
                  HeaderTxtWidget('Gallery'),
                ],
              ),
              onTap: (){
                Navigator.pop(context);
                listener!.call(1);
              },
            ),
            const SizedBox(width: 50,),
            InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt,size: 50,),
                  HeaderTxtWidget('Camera'),
                ],
              ),
              onTap: (){
                Navigator.pop(context);
                listener!.call(2);
              },
            )
          ],
        ),),
      ],
    ),
  );
}
