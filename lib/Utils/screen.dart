import 'dart:io' show Platform;

import 'package:flutter/material.dart';
class MyScreen{
  Size? size;
  MyScreen(cotx){
    size=MediaQuery.of(cotx).size;
  }
  double getDP(double si){
    if(Platform.isAndroid||Platform.isIOS){
      return si;
    }if(Platform.isWindows||Platform.isMacOS){
      return si*size!.aspectRatio;
    }
    return si;
  }
  double getWidth(){
    return size!.width;
  }
  bool isDesktop(){
    return Platform.isWindows||Platform.isMacOS;
}
}