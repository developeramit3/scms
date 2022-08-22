import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/ui/Task/v/add_task_dailog_widget.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../c/personnel_performance_controller.dart';
class PersonnelPerformancePage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends StateMVC<PersonnelPerformancePage> {
  PersonnelPerformanceController? _con;
  _PageState() : super(PersonnelPerformanceController()) {
    _con = controller as PersonnelPerformanceController?;
  }

  @override
  void initState() {
    super.initState();
    _con!.getTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: HeaderTxtWidget(
          'Personnel Performance',
          color: Colors.white,
        ),
        centerTitle: true,
        leading: InkWell(
          child: Padding(
            child: Image.asset('assets/img/ic_backward_arrow.png'),
            padding: EdgeInsets.all(15),
          ),
          onTap: () => Navigator.pop(context),
        ),
      ),
      persistentFooterButtons:[
        Center(
          child: ChipWidget('ADD',width: 100,onTap: (){
           Navigator.pushNamed(context, '/add_personnel_performance');
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
    if (_con!.isLoading) {
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
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: HeaderTxtWidget(
                          "Task details form ${_con!.taskList[index].name}",
                          fontSize: 18,
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, '/details_personnel_performance',arguments: _con!.taskList[index]);
                        },
                      ),
                      flex: 1,
                    ),
                    IconButton(onPressed: () {
                      Navigator.pushNamed(context, '/update_personnel_performance',arguments: _con!.taskList[index]);
                    }, icon: Icon(Icons.edit),),
                    IconButton(onPressed: () {
                      _con!.deletePerformance(_con!.taskList[index].key);
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
        itemCount: _con!.taskList.length,
      ));
    }
  }
}
