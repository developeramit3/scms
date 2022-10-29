import 'package:flutter/material.dart';

import '../Utils/theme_color.dart';
typedef callback=Function();
class ButtonPrimaryBorderWidget extends StatelessWidget {
String title;
callback? onTap;
double fontSize;
var leading;
var color;
double? width;
double? padding;
double? radius;
double? marginHorizontal;
bool paused;
ButtonPrimaryBorderWidget(this.title,{this.fontSize=16,this.onTap,this.leading,this.color,this.width,this.padding,this.radius,this.paused=false,
this.marginHorizontal});

  @override
  Widget build(BuildContext context) {
    double wi = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: paused?null:onTap,
      child: Container(
        width: width??wi,
        height: 45,
        padding: EdgeInsets.all(padding??8),
        margin:EdgeInsets.symmetric(vertical: 5,horizontal: marginHorizontal??5),
        foregroundDecoration:paused? BoxDecoration(
          color: Colors.grey,
          backgroundBlendMode: BlendMode.screen,
        ):null,
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
          border: Border.all(color: color?? ThemeColor.colorPrimary,),
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
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}