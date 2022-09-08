import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../generated/l10n.dart';

class Tools{
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static List<Color> colorList = <Color>[
    const Color(0xffef8104),
    const Color(0xffced4da),
  ];

  static void ShowSuccessMessage(context,message){
   if(message==null){
     return;
   }
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message),backgroundColor: Colors.lightGreen,));
}
static void ShowErrorMessage(context,message){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message),backgroundColor: Colors.red,));
}

static bool isEmailValid(email){
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

  static String changeDateFormat(String date){
    final format22 = new DateFormat('yyyy-MM-dd',"en-US");
    DateFormat format=DateFormat("dd MMM");
    DateTime dateTime=format22.parse(date);
    return format.format(dateTime);
  }
  static String changeTimeFormat(String time){
    final format22 = new DateFormat('HH:mm','en-US');
    DateFormat format=DateFormat("hh:mm a");
    DateTime dateTime=format22.parse(time);
    return format.format(dateTime);
  }
  static String changeTimeFormat2(String time){
    final format22 = new DateFormat('HH:mm:ss','en-US');
    DateFormat format=DateFormat("HH:mm");
    DateTime dateTime=format22.parse(time);
    return format.format(dateTime);
  }
  static String getDayName(String date){
    final format22 = new DateFormat('dd/MM/yyyy','en-US');
    DateFormat format=DateFormat("EEEE");
    DateTime dateTime=format22.parse(date);
    return format.format(dateTime);
  }
  static String getCurrentDayName(Locale locale){
    DateFormat format=DateFormat("EEE",locale.languageCode);
    return format.format(DateTime.now());
  }
  static String getCurrentDate(){
    DateFormat format=DateFormat("yyyy-MM-dd",'en-US');
    return format.format(DateTime.now());
  }

}