import 'package:flutter/material.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/widgets/sub_txt_widget.dart';
import 'header_txt_widget.dart';

class InputWidget extends StatelessWidget {
String? sub_title;
var controller;
bool enabled;
var inputType;
Color? color;
String? sufix;
String? hint;
double? height;
InputWidget({this.controller,this.inputType=TextInputType.text,this.sufix,this.enabled=true,this.color,this.sub_title,this.height,this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(sub_title!=null)
          SubTxtWidget(sub_title!),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 8),
          height: height??50,
          alignment: AlignmentDirectional.topCenter,
          child: Row(
            children: [
              Expanded(child: TextFormField(
                enabled:enabled ,
                controller: controller!=null?controller:TextEditingController(),
                keyboardType: inputType,
                maxLines: 4,
                style: TextStyle(
                  fontFamily:'Schyler',
                ),
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  filled: true,
                  hoverColor: Colors.transparent,
                  hintText: hint??"",
                  counterText: ""
                ),
                validator: (value) {
                  /*if (value == null || value.isEmpty) {
                    return S.of(context).fieldRequired;
                  }*/
                  return null;
                },
              ), flex: 1,),
              Visibility(child: SubTxtWidget("${sufix}"),visible: sufix!=null,)
            ],
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: color??Colors.white,
              border: Border.all(color: ThemeColor.colorPrimary)
          ),
        )
      ],
    );
  }
}