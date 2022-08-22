import 'package:flutter/material.dart';

import '../Utils/theme_color.dart';
import '../generated/l10n.dart';
typedef callback=Function();
class HeaderTxtWidget extends StatelessWidget {
  String txt;
  var textAlign;
  var maxLines;
  var color;
  double fontSize;
  HeaderTxtWidget(this.txt,{this.textAlign,this.maxLines,this.color,this.fontSize=20});

  @override
  Widget build(BuildContext context) {
    return Text(txt,
      textAlign: textAlign,
      maxLines:maxLines,
      style: TextStyle(
        fontSize: fontSize,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        color: color==null?ThemeColor.colorText:color,
        fontFamily:'Schyler',
      ),
    );
  }
}