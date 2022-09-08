import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/ui/Task/v/add_task_dailog_widget.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../../services/session_repo.dart';
import '../c/task_controller.dart';

class TaskPage extends StatefulWidget {
  String selectedProject;

  @override
  _PageState createState() => _PageState();

  TaskPage(this.selectedProject);
}

class _PageState extends StateMVC<TaskPage> {
  TaskController? _con;
  int file_type=0;
  _PageState() : super(TaskController()) {
    _con = controller as TaskController?;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2),() {
      _con!.getTask(file_type);
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: HeaderTxtWidget(
          'Tasks',
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
           child: ChipWidget('Add More',width: 100,onTap: (){
             showDialog(
               context: context,
               builder: (BuildContext context) {
                 return AlertDialog(
                     contentPadding: EdgeInsets.zero,
                     backgroundColor: Colors.transparent,
                     content:AddTaskDailogWidget(listener: (val){
                       _con!.addTask(val);
                     },)
                 );
               },
             );
           },),
         )
        ],
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Container(
                      child: HeaderTxtWidget(
                        'Files',
                        fontSize: 16,
                      ),
                      padding: EdgeInsets.all(10),
                      alignment: AlignmentDirectional.center,
                      decoration:file_type==0? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: ThemeColor.colorPrimary,width: 2),
                          )
                      ):null,
                    ),
                    onTap: (){
                      if(file_type!=0){
                        file_type=0;
                        _con!.getTask(file_type);
                      }
                    },
                  )
              ),
              Container(
                color: Colors.grey.shade400,
                width: 1,
                height: 40,
              ),
              Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Container(
                      child: HeaderTxtWidget(
                        'Saved Files',
                        fontSize: 16,
                      ),
                      padding: EdgeInsets.all(10),
                      alignment: AlignmentDirectional.center,
                      decoration:file_type==1? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: ThemeColor.colorPrimary,width: 2),
                          )
                      ):null,
                    ),
                    onTap: (){
                      if(file_type!=1){
                        file_type=1;
                        _con!.getTask(file_type);
                      }
                    },
                  )
              ),
              Container(
                color: Colors.grey.shade400,
                width: 1,
                height: 40,
              ),
              Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Container(
                      child: HeaderTxtWidget(
                        'Completed',
                        fontSize: 16,
                      ),
                      padding: EdgeInsets.all(10),
                      alignment: AlignmentDirectional.center,
                      decoration:file_type==2? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: ThemeColor.colorPrimary,width: 2),
                          )
                      ):null,
                    ),
                    onTap: (){
                      if(file_type!=2){
                        file_type=2;
                        _con!.getTask(file_type);
                      }
                    },
                  )
              ),

            ],
          ),
          Container(
            color: Colors.grey.shade400,
            width: MediaQuery.of(context).size.width,
            height: 1,
          ),
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
                InkWell(
                  child: Row(
                    children: [
                      Expanded(
                        child: HeaderTxtWidget(
                          "Task details form ${_con!.taskList[index].name}",
                          fontSize: 18,
                        ),
                        flex: 1,
                      ),
                      IconButton(onPressed: () {
                        _con!.deleteTask(file_type,_con!.taskList[index].key);
                        _con!.taskList.removeAt(index);
                      }, icon: Icon(Icons.delete)),
                    ],
                  ),
                  onTap: (){
                  Navigator.pushNamed(context, '/task_details',arguments: _con!.taskList[index]).then((value){
                    if(value!=null){
                      file_type=value as int;
                      _con!.getTask(file_type);
                    }
                  });
                  },
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
