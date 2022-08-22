import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';
import '../../../Utils/tools.dart';
import 'package:shimmer/shimmer.dart';
import '../../../widgets/chip_widget.dart';
import '../c/personnel_performance_controller.dart';
import '../m/performance_response.dart';

class PerformanceDetailsPage extends StatefulWidget {
  PerformanceResponse response;
  @override
  _PageState createState() => _PageState();
  PerformanceDetailsPage(this.response);
}

class _PageState extends StateMVC<PerformanceDetailsPage> {
  PersonnelPerformanceController? _con;
  _PageState() : super(PersonnelPerformanceController()) {
    _con = controller as PersonnelPerformanceController?;
  }

  @override
  void initState() {
    super.initState();
    _con!.id=widget.response.key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con!.scaffoldKey,
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          leading: InkWell(
            child: Padding(child: Image.asset('assets/img/ic_backward_arrow.png'),padding: EdgeInsets.all(15),),
            onTap: ()=>Navigator.pop(context),
          ),
        ),
      persistentFooterButtons:[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChipWidget('UPDATE',width: 100,onTap: (){
              Navigator.pushNamed(context, '/add_personnel_performance');
            },),
            ChipWidget('RESET',width: 100,onTap: (){
              _con!.reset();
              },),
          ],
        )

      ],

      body:Stack(
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                  color: ThemeColor.colorPrimary,
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey.shade400,
                          width: 20
                      )
                  )
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HeaderTxtWidget('Performance overview'.toUpperCase(),color: ThemeColor.hexToColor('#6493C1'),),
                  const SizedBox(height: 10,),
                  HeaderTxtWidget(widget.response.name,color: Colors.white,),
                  SubTxtWidget('TUNNEL WORKER'),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(child: SubTxtWidget('CWR',color: Colors.white,textAlign: TextAlign.center,),flex: 1,),
                      Expanded(child: SubTxtWidget('HK ID NO',color: Colors.white,textAlign: TextAlign.center),flex: 1,),
                      Expanded(child: SubTxtWidget('GREEN CARD',color: Colors.white,textAlign: TextAlign.center),flex: 1,),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(child: SubTxtWidget('${widget.response.cwr}',color: Colors.white,textAlign: TextAlign.center,),flex: 1,),
                      Expanded(child: SubTxtWidget('${widget.response.hkid}',color: Colors.white,textAlign: TextAlign.center,),flex: 1,),
                      Expanded(child: SubTxtWidget('${widget.response.greenCard}',color: Colors.white,textAlign: TextAlign.center,),flex: 1,),
                    ],
                  ),
                  const SizedBox(height: 20,),

                  Row(
                    children: [
                      Expanded(child: SubTxtWidget('CWR EXPIRY',color: Colors.white,textAlign: TextAlign.center,),flex: 1,),
                      Expanded(child: SubTxtWidget('EFNARC',color: Colors.white,textAlign: TextAlign.center),flex: 1,),
                      Expanded(child: SubTxtWidget('GC EXPIRY',color: Colors.white,textAlign: TextAlign.center),flex: 1,),
                    ],
                  ),
                  const SizedBox(height: 10,),

                  Row(
                    children: [
                      Expanded(child: SubTxtWidget('${widget.response.cwrExpiryDate}',color: Colors.white,textAlign: TextAlign.center,),flex: 1,),
                      Expanded(child: SubTxtWidget('YES',color: Colors.white,textAlign: TextAlign.center,),flex: 1,),
                      Expanded(child: SubTxtWidget('${widget.response.expiryDate}',color: Colors.white,textAlign: TextAlign.center,),flex: 1,),
                    ],
                  ),
                  const SizedBox(height: 70,),
                  _chartVolume(),

                ],
              ),
            ),
          ],
        ),
    );
  }
  Widget _chartVolume(){
    if(_con!.isLoading){
      return Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle
        ),
        margin:const EdgeInsets.all(5),
      );
    }else{
    double volume = double.parse(_con!.selectedProject!.project_total_volume.toString());
    double volumeLeft = volume - _con!.totalVolume;
    double value = _con!.totalVolume * 100;
    value = value / volume;
    return Column(
      children: [
        Stack(
          children: [
            PieChart(
              dataMap: {
                "Applied": _con!.totalVolume,
                "Left": volumeLeft,
              },
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 60,
              chartValuesOptions: ChartValuesOptions(
                showChartValues: false,
              ),
              chartRadius: MediaQuery.of(context).size.width / 3,
              colorList: Tools.colorList,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 100,
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                // legendPosition: LegendPosition.right,
                showLegends: false,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: 15,bottom: 15,left: 1,right: 1,
              child: Container(
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 2,
                        spreadRadius: 5
                      ),
                     ],
                    color: Colors.grey.shade100
                ),
                child: SubTxtWidget("PERFORMANCE\n${value.toStringAsFixed(2)}%",textAlign: TextAlign.center,),
              ),
            )
          ],
        ),
        const SizedBox(height: 150,),
        Row(
          children: [
            Expanded(child: Column(
              children: [
                SubTxtWidget('APPLIED',fontSize: 18,),
                SubTxtWidget('${_con!.totalVolume}'),
              ],
            ),flex: 1,),
            Expanded(child: Column(children: [
              SubTxtWidget('TOTAL',fontSize: 18,),
              SubTxtWidget('${_con!.totalVolume}'),
            ],
            ),flex: 1,),
          ],
        )

      ],
    );
  }
  }

}