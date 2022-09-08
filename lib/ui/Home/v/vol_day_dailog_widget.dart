import 'package:flutter/material.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/widgets/button_primary_widget.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/input_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';

import '../../../widgets/header_txt_widget.dart';

typedef callback = Function(String val);

class VolDayDailogWidget extends StatelessWidget {
  callback? listener;
  var number = TextEditingController();
  String? error;
  String oldVal;
  VolDayDailogWidget(this.oldVal,{this.listener}){
   number.text=oldVal;
  }

  @override
  Widget build(BuildContext context) => Wrap(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            HeaderTxtWidget("Volume Completed day"),
                            const SizedBox(height: 10,),
                            InputWidget(inputType: TextInputType.number,controller: number,),
                            if(error!=null)
                            SubTxtWidget(error!,color: Colors.red,),
                            const SizedBox(height: 10,),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                     Container(
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                           color: ThemeColor.colorbtnPrimary
                       ),
                       child:  Row(
                         children: [
                           Expanded(
                             child:ButtonPrimaryWidget('YES',padding: 8,onTap: (){
                               if(number.value.text.isEmpty){
                                 setState((){
                                   error='Volume is Required';
                                 });
                               }else{
                                 listener!.call(number.value.text.toString());
                                 Navigator.pop(context);
                               }
                             },),
                             flex: 1,
                           ),
                           Container(
                             color: Colors.grey.shade300,
                             height: 40,
                             width: 1,
                           ),
                           Expanded(
                             child:ButtonPrimaryWidget('CANCEL',padding: 8,onTap: ()=>Navigator.pop(context),),
                             flex: 1,
                           ),

                         ],
                       ),
                     )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      );
}
