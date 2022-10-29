import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/ui/PersonnelPerformance/m/performance_response.dart';
import 'package:scms/ui/PersonnelPerformance/v/performance_details_page.dart';
import 'package:scms/ui/Task/v/add_task_dailog_widget.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../c/personnel_performance_controller.dart';
typedef callback=Function(
    Widget child,
    String tilte,
    );

class PersonnelPerformancePage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
  callback onTap;

  PersonnelPerformancePage(this.onTap);

}

class _PageState extends StateMVC<PersonnelPerformancePage> {
  PersonnelPerformanceController? _con;
  _PageState() : super(PersonnelPerformanceController()) {
    _con = controller as PersonnelPerformanceController?;
  }

  @override
  void initState() {
    super.initState();
    _con!.PersonalPerformancesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con!.scaffoldKey,
      persistentFooterButtons:[
        Center(
          child: ChipWidget('ADD',width: 150,onTap: (){
           Navigator.pushNamed(context, '/add_personnel_performance').then((value){
             if(value!=null){
               _con!.PersonalPerformancesList();
             }
           });
          },),
        )
      ],
      body: Column(
        children: [
          _files(),
        ],
      ),
      
    );
  }

  Widget _files() {
    if (_con!.performanceResponse==null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade500,
        enabled: true,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  color: Colors.grey,
                  margin: const EdgeInsets.only(bottom: 5, top: 5),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )),
      );
    } else {
      return Expanded(
          child: ListView.builder(
        itemBuilder: (context, index) {
          Performance performance=_con!.performanceResponse!.list[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: HeaderTxtWidget(
                          "Task details form ${performance.name}",
                          fontSize: 18,
                        ),
                        onTap: (){
                          widget.onTap.call(PerformanceDetailsPage(performance),"");
                         /* Navigator.pushNamed(context, '/details_personnel_performance',arguments: performance).then((value){
                            _con!.PersonalPerformancesList();
                          });*/
                        },
                      ),
                    ),
                    IconButton(onPressed: () {
                      Navigator.pushNamed(context, '/update_personnel_performance',arguments: performance).then((value){
                        if(value!=null){
                          _con!.PersonalPerformancesList();
                        }
                      });
                    }, icon: Icon(Icons.edit),),
                    IconButton(onPressed: () {
                      _con!.deletePerformance(performance);
                    }, icon: Icon(Icons.delete)),
                  ],
                ),
                Divider(
                  color: Colors.grey.shade400,
                  height: 1,
                ),
              ],
            ),
          );
        },
        itemCount: _con!.performanceResponse!.list.length,
      ));
    }
  }
}
