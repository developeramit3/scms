import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/ui/Equipment/m/delay_date.dart';
import 'package:scms/ui/Task/v/add_task_dailog_widget.dart';
import 'package:scms/widgets/button_primary_widget.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../c/equipment_controller.dart';
import '../m/equipment_response.dart';
import 'add_equipment_widget.dart';

class EquipmentDetails extends StatefulWidget {
  @override
  _PageState createState() => _PageState();

}

class _PageState extends StateMVC<EquipmentDetails> {
  EquipmentController? _con;
  _PageState() : super(EquipmentController()) {
    _con = controller as EquipmentController?;
  }
  @override
  void initState() {
    super.initState();
    _con!.getEquipment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con!.scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _files(),
          Expanded(child: _barChart(),flex: 1,),
          Container(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          color: Colors.white,
          child: Row(
            children: [
              Icon(Icons.brightness_1,color: Color.fromRGBO(255, 0, 0, 1),size: 15,),
              const SizedBox(width: 2,),
              SubTxtWidget('Sprayer 1',fontSize: 12,),
              const SizedBox(width: 2,),
              Icon(Icons.brightness_1,color: Color.fromRGBO(0, 255, 0,1),size: 15,),
              const SizedBox(width: 2,),
              SubTxtWidget('Sprayer 2',fontSize: 12,),
              const SizedBox(width: 2,),
              Icon(Icons.brightness_1,color: Color.fromRGBO(0, 0, 255,1),size: 15,),
              const SizedBox(width: 2,),
              SubTxtWidget('Sprayer 3',fontSize: 12,),
              const SizedBox(width: 2,),
              Icon(Icons.brightness_1,color: Color.fromRGBO(255, 51, 255,1),size: 15,),
              const SizedBox(width: 2,),
              SubTxtWidget('Sprayer 4',fontSize: 12,),
              const SizedBox(width: 2,),
              Icon(Icons.brightness_1,color: Color.fromRGBO(51, 255, 255, 1),size: 15,),
              const SizedBox(width: 2,),
              SubTxtWidget('Sprayer 5',fontSize: 12,),

            ],
          ),)
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
            height: MediaQuery.of(context).size.height/2,
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
          flex: 1,
          child: ListView.builder(
        itemBuilder: (context, index) {
          EquipmentResponse response=_con!.list[index];
          return Padding(padding: const EdgeInsets.symmetric(horizontal: 20),child: ButtonPrimaryWidget(response.name,onTap: (){
            Navigator.pushNamed(context, '/equipment_single_details',arguments: response);
          },),);
        },
        itemCount: _con!.list.length,shrinkWrap: true,
      ),);
    }
  }
  Widget _barChart(){
    if(_con!.isDelayLoading){
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade500,
        enabled: true,
        child: Container(
            margin:const EdgeInsets.symmetric(vertical: 5),
            height: MediaQuery.of(context).size.height/2,
            child:Row(
              children: [
                Container(height: 210,width: 20,color: Colors.grey,
                  margin:const EdgeInsets.all(5),),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(color: Colors.grey,height: 200,),
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
      return Container(
        padding: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300,width: 20)),
          color: Colors.white,
        ),
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              labelRotation: -45,
              autoScrollingDelta: 10,
              arrangeByIndex: false,
              interval: 1,
              maximumLabels: 100,
              majorGridLines: MajorGridLines(width: 0),
              majorTickLines: MajorTickLines(width: 0),
            ),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
            ),

            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<EquipmentBarchatDate, String>>[
              ColumnSeries<EquipmentBarchatDate, String>(
                  dataSource:_con!.eq_list,
                  xValueMapper: (EquipmentBarchatDate sales, _) => sales.delay1==0?null:sales.date,
                  yValueMapper: (EquipmentBarchatDate sales, _){
                    return sales.delay1==0?null:sales.delay1;
                  },color: Color.fromRGBO(255, 0, 0, 1),
                  dataLabelSettings: DataLabelSettings(isVisible: true,)),
              ColumnSeries<EquipmentBarchatDate, String>(
                  dataSource:_con!.eq_list,
                  xValueMapper: (EquipmentBarchatDate sales, _) => sales.date,
                  yValueMapper: (EquipmentBarchatDate sales, _){
                    return sales.delay2;
                  }, color: Color.fromRGBO(0, 255, 0,1),

              ),
              ColumnSeries<EquipmentBarchatDate, String>(
                  dataSource:_con!.eq_list,
                  xValueMapper: (EquipmentBarchatDate sales, _) => sales.date,
                  yValueMapper: (EquipmentBarchatDate sales, _){
                    return sales.delay3;
                  },color: Color.fromRGBO(0, 0, 255,1),
              ),
              ColumnSeries<EquipmentBarchatDate, String>(
                  dataSource:_con!.eq_list,
                  xValueMapper: (EquipmentBarchatDate sales, _) => sales.date,
                  yValueMapper: (EquipmentBarchatDate sales, _){
                    return sales.delay4;
                  },
                  color: Color.fromRGBO(255, 51, 255,1),

              ),
              ColumnSeries<EquipmentBarchatDate, String>(
                  dataSource:_con!.eq_list,
                  xValueMapper: (EquipmentBarchatDate sales, p) => sales.date,
                  yValueMapper: (EquipmentBarchatDate sales, _){
                    return sales.delay5;
                  },
                  color: Color.fromRGBO(51, 255, 255, 1),
              ),
            ],

        ),
      );
    }
  }
}
