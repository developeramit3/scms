import 'package:flutter/material.dart';

import '../Utils/theme_color.dart';
typedef callback=Function();
class ChipWidget extends StatelessWidget {
String title;
callback? onTap;
double fontSize;
var leading;
var color;
var txtColor;
double? radius;
double? width;
ChipWidget(this.title,{this.fontSize=16,this.onTap,this.leading,this.color,this.txtColor,this.radius,this.width});

  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 12),
        margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
        decoration: BoxDecoration(
          color: color?? ThemeColor.colorbtnPrimary,
            borderRadius:  BorderRadius.all(Radius.circular(radius??20))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(leading!=null)
              leading,
            if(leading!=null)
            const SizedBox(width: 10,),
            Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: fontSize,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontFamily:'Schyler',
                  color: txtColor??Colors.white),
            )
          ],
        ),
      ),
    );
  }
}