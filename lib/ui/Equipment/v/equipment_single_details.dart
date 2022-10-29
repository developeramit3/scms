import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/ui/Equipment/m/delay_date.dart';
import 'package:scms/ui/Task/v/add_task_dailog_widget.dart';
import 'package:scms/widgets/button_primary_widget.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../Utils/tools.dart';
import '../../../widgets/sub_txt_widget.dart';
import '../c/equipment_controller.dart';
import '../m/equipment_response.dart';

class EquipmentSingleDetails extends StatefulWidget {
  Equipment data;
  @override
  _PageState createState() => _PageState();
  EquipmentSingleDetails(this.data);

}

class _PageState extends StateMVC<EquipmentSingleDetails> {
  EquipmentController? _con;
  int type=0;
  int sub_type=0;
  _PageState() : super(EquipmentController()) {
    _con = controller as EquipmentController?;
  }
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2),() {
      _con!.getDelayDateSingle(widget.data);
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
          'Equipment Performance',
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
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: AlignmentDirectional.center,
                      decoration:BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: type==0?ThemeColor.colorPrimary:Colors.grey.shade400,width: 2),
                          )
                      ),
                      child: HeaderTxtWidget(
                        'Performance',
                        fontSize: 16,
                      ),
                    ),
                    onTap: (){
                      if(type!=0){
                        setState(() { type=0;});
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
                      padding: EdgeInsets.all(10),
                      alignment: AlignmentDirectional.center,
                      decoration:BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: type==1?ThemeColor.colorPrimary:Colors.grey.shade400,width: 2),
                          )
                      ),
                      child: HeaderTxtWidget(
                        'Schedule',
                        fontSize: 16,
                      ),
                    ),
                    onTap: (){
                      if(type!=1){
                        setState(() {
                          type=1;
                        });
                        _con!.getShedule("0");
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
                      padding: EdgeInsets.all(10),
                      alignment: AlignmentDirectional.center,
                      decoration:BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: type==2?ThemeColor.colorPrimary:Colors.grey.shade400,width: 2),
                          )
                      ),
                      child: HeaderTxtWidget(
                        'Report',
                        fontSize: 16,
                      ),
                    ),
                    onTap: (){
                      if(type!=2){
                        type=2;
                        _con!.getShedule("2");
                      }
                    },
                  )
              ),

            ],
          ),
          Visibility(visible: type==0,child:_barChart(),),
          Visibility(visible: type==1,child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        alignment: AlignmentDirectional.center,
                        decoration:BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: sub_type==0?ThemeColor.colorPrimary:Colors.grey.shade400,width: 2),
                            )
                        ),
                        child: HeaderTxtWidget(
                          'Schedule',
                          fontSize: 16,
                        ),
                      ),
                      onTap: (){
                        if(sub_type!=0){
                          sub_type=0;
                          _con!.getShedule("0");
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
                        padding: EdgeInsets.all(10),
                        alignment: AlignmentDirectional.center,
                        decoration:BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: sub_type==1?ThemeColor.colorPrimary:Colors.grey.shade400,width: 2),
                            )
                        ),
                        child: HeaderTxtWidget(
                          'Completed',
                          fontSize: 16,
                        ),
                      ),
                      onTap: (){
                        if(sub_type!=1){
                          sub_type=1;
                          _con!.getShedule('1');
                        }
                      },
                    )
                ),
              ]
          ),),
          Visibility(visible:type!=0,child: _files())
        ],
      ),
      persistentFooterButtons:[
        if((_con!.user!=null&&_con!.user!.user_type=="0")||type==1)
          Center(
            child: ChipWidget(type==0?'RESET':'ADD',width: 150,onTap: () async {
              if(type==0){
                _con!.resetSchedule(widget.data);
              }else if(type==1){
                Navigator.pushNamed(context, '/add_shedule_maintance');
              }else{
                await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['ppt', 'pdf', 'doc'],
                ).then((value){
                  if(value!=null){
                    _con!.addFile(widget.data,value.files.first);
                  }
                });
              }
            },),
          )
      ],
    );
  }
  Widget _barChart(){
    if(_con!.isDelayLoading){
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade500,
        enabled: true,
        child: Container(
            margin:const EdgeInsets.symmetric(vertical: 5),
            height: 150,
            child:Row(
              children: [
                Container(height: 200,width: 20,color: Colors.grey,
                  margin:const EdgeInsets.all(5),),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(color: Colors.grey,height: 100,),
                    Container(height: 20,color: Colors.grey,
                      margin:const EdgeInsets.only(bottom: 5,top: 5),),
                    const SizedBox(height: 10,),
                  ],
                ))
              ],
            )
        ),
      );
    }else{
      return Expanded(child: Column(
        children: [
          HeaderTxtWidget('Performance (Volume)'),
          Expanded(flex: 1,child: Container(
            padding: EdgeInsets.only(top: 20),
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelRotation: 0,
                  maximumLabels: 100,
                  interval: 1,
                  autoScrollingDelta: 10,
                  arrangeByIndex: false,
                  majorGridLines: MajorGridLines(width: 0),
                  majorTickLines: MajorTickLines(width: 0),
                ),
                primaryYAxis: CategoryAxis(

                ),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<DelayDate, String>>[
                  ColumnSeries<DelayDate, String>(
                      dataSource:_con!.performance_list,
                      xValueMapper: (DelayDate sales, _) => Tools.changeDateFormat(sales.euipment_performance_date),
                      yValueMapper: (DelayDate sales, _) => sales.volume,
                      color: ThemeColor.colorbtnPrimary,
                      dataLabelSettings: DataLabelSettings(isVisible: true,))]
            ),
          ),),
          HeaderTxtWidget('Breakdown (Working Hours)'),
          Expanded(flex: 1,child: Container(
            padding: EdgeInsets.only(top: 20),
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelRotation: 0,
                  maximumLabels: 100,
                  arrangeByIndex: false,
                  autoScrollingDelta: 10,
                  majorGridLines: MajorGridLines(width: 0),
                  majorTickLines: MajorTickLines(width: 0),
                ),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<DelayDate, String>>[
                  ColumnSeries<DelayDate, String>(
                      dataSource:_con!.breackdown_list,
                      xValueMapper: (DelayDate sales, _) => Tools.changeDateFormat(sales.euipment_performance_date),
                      yValueMapper: (DelayDate sales, _) => sales.equipment_number_of_hours,
                      color: ThemeColor.colorbtnPrimary,
                      dataLabelSettings: DataLabelSettings(isVisible: true,))]
            ),
          ),),
        ],
      ));
    }
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
                child: InkWell(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SubTxtWidget(
                                  "Start Date: ${_con!.schedule_list[index].start_date}",
                                  fontSize: 16,
                                ),
                                SubTxtWidget(
                                  "End Date: ${_con!.schedule_list[index].end_date}",
                                  fontSize: 16,
                                ),
                                SubTxtWidget(
                                  "Details: ${_con!.schedule_list[index].details}",
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),

                          if(_con!.user!.user_type=="0")
                            IconButton(onPressed: () {
                             _con!.deleteSchedule(type,_con!.schedule_list[index].id);
                            }, icon: Icon(Icons.delete)),
                        ],
                      ),
                      Divider(
                        color: Colors.grey.shade400,
                        height: 20,
                      ),
                    ],
                  ),
                  onTap: (){

                  },
                ),
              );
            },
            itemCount: _con!.schedule_list.length,
          ));
    }
  }
}
