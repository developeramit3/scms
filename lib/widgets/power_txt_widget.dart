import 'package:flutter/material.dart';

import '../Utils/theme_color.dart';
import '../generated/l10n.dart';
typedef callback=Function();
class PowerTxtWidget extends StatelessWidget {
  String txt;
  var color;
  double fontSize;
  PowerTxtWidget(this.txt,{this.color,this.fontSize=14});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
            text: txt,
          style: TextStyle(
            fontSize: fontSize,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
            color: color==null?ThemeColor.colorText:color,
            fontFamily:'Schyler',
          ),),
        WidgetSpan(
          child: Transform.translate(
            offset: const Offset(2, -7),
            child: Text(
              '3',
              textScaleFactor: 0.7,
              style: TextStyle(
                fontSize: fontSize,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
                color: color==null?ThemeColor.colorText:color,
                fontFamily:'Schyler',
              ),
            ),
          ),
        )
      ]),
    );
  }
}