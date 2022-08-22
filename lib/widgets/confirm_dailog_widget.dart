import 'package:flutter/material.dart';
import 'package:scms/widgets/sub_txt_widget.dart';

import '../generated/l10n.dart';
import 'header_txt_widget.dart';
typedef callback =Function();
class ConfirmDailogWidget extends StatelessWidget {
  String title;
  String sub_title;
  callback? listener;
  ConfirmDailogWidget({required this.title,required this.sub_title,this.listener});


  @override
  Widget build(BuildContext context) =>Material(
    color: Colors.transparent,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin:const EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
              borderRadius:const BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300,blurRadius: 5)
              ]
          ),
          padding: EdgeInsets.all(10),child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeaderTxtWidget(title),
            const SizedBox(height: 10,),
            SubTxtWidget(sub_title,textAlign: TextAlign.center,),
            const SizedBox(height: 10,),
            const Divider(color: Colors.grey,),
            Row(
              children: [
                Expanded(child: InkWell(
                  child: HeaderTxtWidget(S.of(context).ok,textAlign: TextAlign.center,fontSize: 14,),
                  onTap: (){
                    Navigator.pop(context);
                    if(listener!=null)listener!.call();
                  },
                ),flex: 1,),
                Container(color: Colors.grey,height: 30,width: 1,),
                Expanded(child: InkWell(
                  child: HeaderTxtWidget(S.of(context).cancel,textAlign: TextAlign.center,fontSize: 14,),
                  onTap: ()=>Navigator.pop(context),
                ),flex: 1,),
              ],
            )
          ],
        ),),
      ],
    ),
  );
}
