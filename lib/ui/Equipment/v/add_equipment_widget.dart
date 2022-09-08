import 'package:flutter/material.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/widgets/button_primary_widget.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/input_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';

import '../../../widgets/header_txt_widget.dart';

typedef callback = Function(String val);

class AddEquipmentWidget extends StatelessWidget {
  callback? listener;
  var name = TextEditingController();
  String? error;
  String? val;
  AddEquipmentWidget({this.listener,this.val}){
   if(val!=null){
     name.text=val!;
   }
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
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            HeaderTxtWidget("Add Equipment"),
                            const SizedBox(height: 10,),
                            InputWidget(sub_title:"Name",inputType: TextInputType.text,controller: name,),
                            if(error!=null)
                            SubTxtWidget(error!,color: Colors.red,),
                            const SizedBox(height: 10,),
                          ],
                        ),
                      ),
                     Container(
                       decoration: BoxDecoration(
                           borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                           color: ThemeColor.colorbtnPrimary
                       ),
                       child:  Row(
                         children: [
                           Expanded(
                             flex: 1,
                             child:ButtonPrimaryWidget('YES',padding: 8,onTap: (){
                               if(name.value.text.isEmpty){
                                 setState((){
                                   error='Name is Required';
                                 });
                               }else{
                                 listener!.call(name.value.text.toString());
                                 Navigator.pop(context);
                               }
                             },),
                           ),
                           Container(
                             color: Colors.grey.shade300,
                             height: 40,
                             width: 1,
                           ),
                           Expanded(
                             flex: 1,
                             child:ButtonPrimaryWidget('CANCEL',padding: 8,onTap: ()=>Navigator.pop(context),),
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
