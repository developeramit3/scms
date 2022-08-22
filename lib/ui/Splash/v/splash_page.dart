import 'package:flutter/material.dart';

import '../../../services/session_repo.dart';

class SplashPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3),() {
      isLogin().then((value){
        if(value??false){
          Navigator.pushNamedAndRemoveUntil(context, '/project_list', (route) => false);
        }else{
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
      });
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
        body:Stack(
          children: [
            Center(
              child: Image.asset('assets/img/top_header_logo.png',height: 40,),
            ),
          ],
        ));
  }
}
