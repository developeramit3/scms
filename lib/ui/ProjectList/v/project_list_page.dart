import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/widgets/button_primary_widget.dart';
import 'package:scms/widgets/input_password_widget.dart';
import 'package:scms/widgets/input_widget.dart';

import '../../../generated/l10n.dart';
import '../../../services/session_repo.dart';
import '../c/project_list_controller.dart';

class ProjectListPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends StateMVC<ProjectListPage> {
  ProjectListController? _con;

  _PageState() : super(ProjectListController()) {
    _con = controller as ProjectListController?;
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
          child: Stack(
            children: [
              Positioned(
                child: Image.asset('assets/img/top_header_logo.png',height: 40,),
                left: 20,
                top: 50,
              ),
              Positioned(
                child: Image.asset('assets/img/compay_logo.png',height: 70,),
                left: 20,
                bottom: 50,
              ),
              Positioned(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonPrimaryWidget(S.of(context).project_1,color: Colors.white,txtColor: ThemeColor.colorPrimary,padding: 12,onTap: (){
                  Map<String,dynamic>map=Map();
                  map['project']="A";
                  map['project_real_name']=S.of(context).project_1;
                  map['project_total_volume']=1069;
                  map['project_total_wastage']=85.52;
                  map['was_per']=0.08;
                  setSelectedProject(map);
                  Navigator.pushNamed(context, '/home',arguments: map);
                  },),
                  const SizedBox(height: 20,),
                  ButtonPrimaryWidget(S.of(context).project_2,color: Colors.white,txtColor: ThemeColor.colorPrimary,padding: 12,onTap: (){
                    Map<String,dynamic>map=Map();
                    map['project']="B";
                    map['project_real_name']=S.of(context).project_2;
                    map['project_total_volume']=1000;
                    map['project_total_wastage']=100;
                    map['was_per']=0.10;
                    setSelectedProject(map);
                    Navigator.pushNamed(context, '/home',arguments: map);
                  },),
                  const SizedBox(height: 20,),
                  ButtonPrimaryWidget(S.of(context).project_3,color: Colors.white,txtColor: ThemeColor.colorPrimary,padding: 12,onTap: (){
                    Map<String,dynamic>map=Map();
                    map['project']="C";
                    map['project_real_name']=S.of(context).project_3;
                    map['project_total_volume']=628160;
                    map['project_total_wastage']=62816;
                    map['was_per']=0.10;
                    setSelectedProject(map);
                    Navigator.pushNamed(context, '/home',arguments: map);
                  },),
                  const SizedBox(height: 20,),
                  ButtonPrimaryWidget(S.of(context).project_4,color: Colors.white,txtColor: ThemeColor.colorPrimary,padding: 12,onTap: (){
                    Map<String,dynamic>map=Map();
                    map['project']="D";
                    map['project_real_name']=S.of(context).project_4;
                    map['project_total_volume']=1000;
                    map['project_total_wastage']=100;
                    map['was_per']=0.10;
                    setSelectedProject(map);
                    Navigator.pushNamed(context, '/home',arguments: map);
                  },),
                ],
              ),left: 20,right: 20,top: 1,bottom: 1,),
            ],
          ),
        )
    );
  }
}
