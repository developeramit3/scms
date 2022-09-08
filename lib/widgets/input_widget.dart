import 'package:flutter/material.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/widgets/sub_txt_widget.dart';
import 'header_txt_widget.dart';

class InputWidget extends StatelessWidget {
String? sub_title;
var controller;
bool enabled;
var inputType;
var onChanged;
Color? color;
String? sufix;
String? hint;
double? height;
InputWidget({this.controller,this.inputType=TextInputType.text,this.sufix,this.enabled=true,this.color,this.sub_title,this.height,this.hint,this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(sub_title!=null)
          SubTxtWidget(sub_title!,color: color,),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: height??50,
          alignment: AlignmentDirectional.topCenter,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: color??Colors.white,
              border: Border.all(color: ThemeColor.colorPrimary)
          ),
          child: Row(
            children: [
              Expanded(flex: 1,child: TextFormField(
                enabled:enabled ,
                controller: controller ??TextEditingController(),
                keyboardType: inputType,
                maxLines: 4,
                onChanged:onChanged,
                style: const TextStyle(
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
              ),),
              Visibility(visible: sufix!=null,child: SubTxtWidget("${sufix}"),)
            ],
          ),
        )
      ],
    );
  }
}