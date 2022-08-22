import 'package:flutter/material.dart';

import '../Utils/theme_color.dart';
import '../generated/l10n.dart';
typedef callback=Function();
class SubTxtWidget extends StatelessWidget {
  String txt;
  var textAlign;
  var maxLines;
  var color;
  double fontSize;
  SubTxtWidget(this.txt,{this.textAlign,this.maxLines,this.color,this.fontSize=14});

  @override
  Widget build(BuildContext context) {
    return Text(txt,
      textAlign: textAlign,
      maxLines:maxLines,
      style: TextStyle(
        fontSize: fontSize,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
        color: color==null?ThemeColor.colorText:color,
        fontFamily:'Schyler',
      ),
    );
  }
}