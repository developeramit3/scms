import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/widgets/button_primary_border_widget.dart';
import 'package:scms/widgets/button_primary_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:scms/widgets/input_password_widget.dart';
import 'package:scms/widgets/input_widget.dart';

import '../../../generated/l10n.dart';
import '../c/login_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends StateMVC<LoginPage> {
  LoginController? _con;

  _PageState() : super(LoginController()) {
    _con = controller as LoginController?;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con!.scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
        body:Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/login_bg.png'),
              fit: BoxFit.cover
            )
          ),
          child: Stack(
            children: [
              Positioned(
                left: 20,
                top: 50,
                child: Image.asset('assets/img/top_header_logo.png',height: 40,),
              ),
              Positioned(
                left: 20,
                bottom: 50,
                child: Image.asset('assets/img/compay_logo.png',height: 70,),
              ),
              Positioned(bottom: 150,left: 20,right: 20,child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InputWidget(hint:S.of(context).email,controller: _con!.email,),
                    InputPasswordWidget(S.of(context).password,controller: _con!.password,),
                    ButtonPrimaryWidget(S.of(context).enter,onTap: ()=>_con!.lgoinWithPassword(),),
                    const SizedBox(height: 20,),
                    HeaderTxtWidget("OR",textAlign: TextAlign.center,),
                    const SizedBox(height: 20,),
                    ButtonPrimaryBorderWidget("Register",fontSize: 16,onTap:()=>Navigator.pushNamed(context, "/register"),),
                    const SizedBox(height: 20,),

                  ],),
              ),
              ),
            ],
          ),
        )
    );
  }
}
