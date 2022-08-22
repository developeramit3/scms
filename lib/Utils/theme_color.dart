import 'package:flutter/material.dart';

class ThemeColor{
   static Color colorPrimary= hexToColor('#050050');
   static Color colorbtnPrimary= hexToColor('#EF8104');
   static Color colorProgressBG= Colors.transparent;
   static Color colorSecoundry=hexToColor('#050050');
   static Color colorBtnPrimary=hexToColor('#050050');
   static Color colorSelected=hexToColor('#050050');
   static Color colorBtnText=Colors.white;
   static Color colorText=Colors.black;
   static Color colorTextGray=Colors.grey.shade600;
   static Color colorInputText=Colors.black;
   static Color colorDivider=Colors.grey;
   static Color colorTranperent=Colors.transparent;

   static Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
   }
}