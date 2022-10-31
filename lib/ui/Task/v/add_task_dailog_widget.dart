import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/Utils/tools.dart';
import 'package:scms/widgets/button_primary_widget.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/input_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';

import '../../../widgets/header_txt_widget.dart';
import '../m/task_response.dart';

typedef callback = Function(Map<String,dynamic> val);

class AddTaskDailogWidget extends StatelessWidget {
  callback? listener;
  String? error;
  TaskList? model=TaskList();
  Map<String,dynamic>map=Map();
  Map<String,dynamic>temp_map=Map();
  var name = TextEditingController();
  AddTaskDailogWidget({this.listener}){
    map['file_type']=0;
    map['details']="";
    map['qa_qc_package']=false;
    map['qa_qc_package_01']=false;
    map['qa_qc_package_02']=false;
    map['qa_qc_package_03']=false;
    map['qa_qc_package_04']=false;
    map['chemical_added']=false;
    map['surface_preparation_package']=false;
    map['shortcreate_application_package']=false;
    map['applied_monitoring_package']=false;
    map['completion_equipment_cleaning_package']=false;
    map['attachment_link']=false;
    map['signature']=false;
    map['chemical_added']=false;
    map['fiber_added']=false;
    temp_map['qa_qc_package_05']=false;
    temp_map['qa_qc_package_06']=false;
    temp_map['qa_qc_package_07']=false;
    temp_map['qa_qc_package_08']=false;
    temp_map['qa_qc_package_09']=false;
  }

  @override
  Widget build(BuildContext context) => Wrap(
    children: [
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HeaderTxtWidget("Add Form"),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height*0.65,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10,),
                          SubTxtWidget('Form Name'),
                          InputWidget(controller: name,),
                          if(error!=null)
                          SubTxtWidget(error!,color: Colors.red,),
                          Row(
                            children: [
                              Checkbox(value: map['qa_qc_package'], onChanged:(v){
                                setState((){
                                  map['qa_qc_package']=v;
                                });
                              }),
                              SubTxtWidget('QA/QC Shotcrete Mix Package(Load 1)'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: map['qa_qc_package_01'], onChanged:(v){
                                setState((){
                                  map['qa_qc_package_01']=v;
                                });
                              }),
                              SubTxtWidget('QA/QC Shotcrete Mix Package(Load 2)'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: map['qa_qc_package_02'], onChanged:(v){
                                setState((){
                                  map['qa_qc_package_02']=v;
                                });
                              }),
                              SubTxtWidget('QA/QC Shotcrete Mix Package(Load 3)'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: map['qa_qc_package_03'], onChanged:(v){
                                setState((){
                                  map['qa_qc_package_03']=v;
                                });
                              }),
                              SubTxtWidget('QA/QC Shotcrete Mix Package(Load 4)'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: map['qa_qc_package_04'], onChanged:(v){
                                setState((){
                                  map['qa_qc_package_04']=v;
                                });
                              }),
                              SubTxtWidget('QA/QC Shotcrete Mix Package(Load 5)'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: temp_map['qa_qc_package_05'], onChanged:(v){
                                setState((){
                                  temp_map['qa_qc_package_05']=v;
                                });
                              }),
                              SubTxtWidget('QA/QC Shotcrete Mix Package(Load 6)'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: temp_map['qa_qc_package_06'], onChanged:(v){
                                setState((){
                                  temp_map['qa_qc_package_06']=v;
                                });
                              }),
                              SubTxtWidget('QA/QC Shotcrete Mix Package(Load 7)'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: temp_map['qa_qc_package_07'], onChanged:(v){
                                setState((){
                                  temp_map['qa_qc_package_07']=v;
                                });
                              }),
                              SubTxtWidget('QA/QC Shotcrete Mix Package(Load 8)'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: temp_map['qa_qc_package_08'], onChanged:(v){
                                setState((){
                                  temp_map['qa_qc_package_08']=v;
                                });
                              }),
                              SubTxtWidget('QA/QC Shotcrete Mix Package(Load 9)'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: temp_map['qa_qc_package_09'], onChanged:(v){
                                setState((){
                                  temp_map['qa_qc_package_09']=v;
                                });
                              }),
                              SubTxtWidget('QA/QC Shotcrete Mix Package(Load 10)'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: map['chemical_added'], onChanged:(v){
                                setState((){
                                  map['chemical_added']=v;
                                });
                              }),
                              SubTxtWidget('Chemical Added'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: map['fiber_added'], onChanged:(v){
                                setState((){
                                  map['fiber_added']=v;
                                });
                              }),
                              SubTxtWidget('Fiber Added'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: map['surface_preparation_package'], onChanged:(v){
                                setState((){
                                  map['surface_preparation_package']=v;
                                });
                              }),
                             Flexible(child:  SubTxtWidget('Shotcrete & Surface Preparation Package'),)
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: map['shortcreate_application_package'], onChanged:(v){
                                setState((){
                                  map['shortcreate_application_package']=v;
                                });
                              }),
                              SubTxtWidget('Shotcrete Application Package'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: map['applied_monitoring_package'], onChanged:(v){
                                setState((){
                                  map['applied_monitoring_package']=v;
                                });
                              }),
                              SubTxtWidget('Applied Monitoring Package'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: map['completion_equipment_cleaning_package'], onChanged:(v){
                                setState((){
                                  map['completion_equipment_cleaning_package']=v;
                                });
                              }),
                              Flexible(child: SubTxtWidget('Completion & Equipment Cleaning Package'),)
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: map['attachment_link'], onChanged:(v){
                                setState((){
                                  map['attachment_link']=v;
                                });
                              }),
                              SubTxtWidget('Attachment'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(value: map['signature'], onChanged:(v){
                                setState((){
                                  map['signature']=v;
                                });
                              }),
                              SubTxtWidget('Signature'),
                            ],
                          ),
                          const SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                        color: ThemeColor.colorPrimary
                    ),
                    child:  Row(
                      children: [
                        Expanded(
                          child:ButtonPrimaryWidget('YES',padding: 8,onTap: (){
                          if(name.value.text.toString().isEmpty){
                            setState((){
                              error="Please Enter Form Name";
                            });
                          }else{
                            bindData(context);
                          }
                          },color: ThemeColor.colorPrimary,),
                          flex: 1,
                        ),
                        Container(
                          color: Colors.grey.shade300,
                          height: 40,
                          width: 1,
                        ),
                        Expanded(
                          child:ButtonPrimaryWidget('CANCEL',padding: 8,onTap: ()=>Navigator.pop(context),color: ThemeColor.colorPrimary,),
                          flex: 1,
                        ),

                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      )
    ],
  );
  void bindData(context){
    map['name']=name.value.text.toString();
    List<String>array=[];
    if(map['qa_qc_package']){
      Map<String,dynamic>temp=Map();
      temp['load']=1;
      temp['data']="";
      array.add(jsonEncode(temp));
    }
    if(map['qa_qc_package_01']){
      Map<String,dynamic>temp=Map();
      temp['load']=2;
      temp['data']="";
      array.add(jsonEncode(temp));
    }
    if(map['qa_qc_package_02']){
      Map<String,dynamic>temp=Map();
      temp['load']=3;
      temp['data']="";
      array.add(jsonEncode(temp));
    }
    if(map['qa_qc_package_03']){
      Map<String,dynamic>temp=Map();
      temp['load']=4;
      temp['data']="";
      array.add(jsonEncode(temp));
    }
    if(map['qa_qc_package_04']){
      Map<String,dynamic>temp=Map();
      temp['load']=5;
      temp['data']="";
      array.add(jsonEncode(temp));
    }
    if(temp_map['qa_qc_package_05']){
      Map<String,dynamic>temp=Map();
      temp['load']=6;
      temp['data']="";
      array.add(jsonEncode(temp));
    }
    if(temp_map['qa_qc_package_06']){
      Map<String,dynamic>temp=Map();
      temp['load']=7;
      temp['data']="";
      array.add(jsonEncode(temp));
    }
    if(temp_map['qa_qc_package_07']){
      Map<String,dynamic>temp=Map();
      temp['load']=8;
      temp['data']="";
      array.add(jsonEncode(temp));
    }
    if(temp_map['qa_qc_package_08']){
      Map<String,dynamic>temp=Map();
      temp['load']=9;
      temp['data']="";
      array.add(jsonEncode(temp));
    }
    if(temp_map['qa_qc_package_09']){
      Map<String,dynamic>temp=Map();
      temp['load']=10;
      temp['data']="";
      array.add(jsonEncode(temp));
    }
    map['qa_qc_package_object']=array.toString();
    print("map ${map.toString()}");
    listener!.call(map);
    Navigator.pop(context);
  }
}
