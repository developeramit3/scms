import 'package:flutter/material.dart';

import '../Utils/theme_color.dart';
typedef callback=Function();
class ButtonBlueTxtWidget extends StatelessWidget {
String title;
callback? onTap;
double fontSize;
EdgeInsets? padding;
var leading;
MainAxisAlignment? alignment;
ButtonBlueTxtWidget(this.title,{this.fontSize=16,this.onTap,this.leading,this.alignment,this.padding});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding:padding??const EdgeInsets.all(10),
      margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
      child: InkWell(
        child: Row(
          mainAxisAlignment:alignment?? MainAxisAlignment.center,
          children: [
            if(leading!=null)
              leading,
            if(leading!=null)
            SizedBox(width: 10,),
            Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: fontSize,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontFamily:'Schyler',
                  color: Colors.blue),
            )
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}