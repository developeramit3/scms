import 'package:flutter/material.dart';
import 'package:scms/widgets/sub_txt_widget.dart';
import 'header_txt_widget.dart';
typedef callback =Function (String country_code);
class InputMobileWidget extends StatelessWidget {
String title;
String? hint;
String? sub_title;
var controller;
String? code;
callback? listner;
bool? enabled;
InputMobileWidget(this.title,{this.controller,this.code,this.listner,this.sub_title,this.enabled,this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderTxtWidget(title,fontSize: 15,),
        if(sub_title!=null)
          SubTxtWidget(sub_title!),
        Row(
          children: [
            /*Container(
              height: 50,
              margin: EdgeInsets.only(top: 10,bottom: 10,right: 10),
              alignment: AlignmentDirectional.center,
              child: CountryCodePicker(
                enabled: enabled??true,
                onChanged: (value) {
                  listner!.call(value.dialCode.toString());
                },
                countryFilter: [
                  "US","IN","EC"
                ],
                initialSelection: getInitial(),
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Colors.white,
              ),
            ),*/
            Expanded(child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 8),
              alignment: AlignmentDirectional.centerStart,
              child: TextFormField(
                controller: controller!=null?controller:TextEditingController(),
                keyboardType: TextInputType.phone,
                textAlignVertical: TextAlignVertical.center,
                maxLength: 12,
                buildCounter: null,
                style: TextStyle(
                  fontFamily:'Schyler',
                ),
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  filled: true,
                  counterText: "",
                  enabled: enabled??true,
                  hintText: getHint(),
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400
                  ),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Colors.white,
              ),
            ))
          ],
        ),
      ],
    );
  }
  String getHint(){
    if(hint!=null){
      return hint!;
    }
    if(code=="+91"){
      return "xxxxx-xxxxx";
    }if(code=="+1"){
      return "(704) 000-0000";
    }if(code=="+593"){
      return "x-xxx-xxx";
    }
    return "(704) 000-0000";
  }
  String getInitial(){
    if(code=="+91"){
      return "IN";
    }if(code=="+1"){
      return "US";
    }if(code=="+593"){
      return "EC";
    }
    return "EC";
  }
}