import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/services/session_repo.dart';
import 'package:scms/ui/Home/m/delay_response.dart';
import 'package:scms/ui/Home/v/dum_value_dailog_widget.dart';
import 'package:scms/ui/Home/v/home_page.dart';
import 'package:scms/ui/Home/v/total_volume_widget.dart';
import 'package:scms/ui/Home/v/vol_day_dailog_widget.dart';
import 'package:scms/ui/Task/m/task_response.dart';
import 'package:scms/ui/Task/v/task_page.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../Utils/tools.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/chip_widget.dart';
import '../../../widgets/confirm_dailog_widget.dart';
import '../../../widgets/power_txt_widget.dart';
import '../../Task/c/save_file_mobile.dart';
import '../c/home_controller.dart';
import 'package:shimmer/shimmer.dart';

import 'drawer_widget.dart';

class DashboardPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();

}

class _PageState extends StateMVC<DashboardPage> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
Widget? child;
String HeaderTitle="";
  @override
  void initState() {
    super.initState();
    requestPermission(Permission.storage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: HeaderTxtWidget(HeaderTitle,fontSize: 18,color: Colors.white,),
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          child: Padding(
            child: Image.asset('assets/img/ic_backward_arrow.png'),
            padding: EdgeInsets.all(15),
          ),
          onTap: () => Navigator.pop(context),
        ),
        actions: [
          InkWell(
            child: Padding(
              child: Image.asset(
                'assets/img/app_menu.png',
                width: 20,
              ),
              padding: EdgeInsets.only(right: 20, left: 10),
            ),
            onTap: () => scaffoldKey.currentState!.openEndDrawer(),
          ),
        ],
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width,
        backgroundColor: Theme.of(context).backgroundColor,
        child: DrawerWidget(onTap:(chd,title){
          setState((){
            child=chd;
            HeaderTitle=title;
          });
        }),
      ),
      body:child??HomePage((chld,title){
        setState(() {
          child=chld;
          HeaderTitle=title;
        });
      })
    );
  }

}
