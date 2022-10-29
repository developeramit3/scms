import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/Utils/tools.dart';
import 'package:scms/widgets/button_primary_widget.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/input_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';

import '../../../widgets/header_txt_widget.dart';
import '../../../widgets/power_txt_widget.dart';
import '../c/home_controller.dart';

typedef callback = Function(String val);

class DumpValueDailogWidget extends StatelessWidget {
  HomeController con;
  DumpValueDailogWidget(this.con);

  @override
  Widget build(BuildContext context) {
    double volumeApplied = double.tryParse(con.projectResponse!.volume.toString())??0;
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
              ),
              color: Colors.white
          ),
          child: Stack(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                    color: ThemeColor.colorPrimary,
                    borderRadius: const BorderRadius.only(
                      topLeft:  Radius.circular(20.0),
                      topRight:  Radius.circular(20.0),
                    ),
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.shade400,
                            width: 20
                        )
                    )
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    HeaderTxtWidget('DUMP VOLUME'.toUpperCase(),color: ThemeColor.hexToColor('#6493C1'),),
                    const SizedBox(height: 10,),
                    PowerTxtWidget("${con.dump_volume}m",color: ThemeColor.colorbtnPrimary,fontSize: 20,),
                    const SizedBox(height: 80,),
                    Stack(
                      children: [
                        PieChart(
                          dataMap: {
                            "Applied": con.dump_volume,
                            "Left": volumeApplied,
                          },
                          animationDuration: Duration(milliseconds: 800),
                          chartLegendSpacing: 100,
                          chartValuesOptions: ChartValuesOptions(
                            showChartValues: false,
                          ),
                          chartRadius: MediaQuery.of(context).size.width / 2.5,
                          colorList: Tools.colorList,
                          initialAngleInDegree: 270,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 120,
                          centerText: "HYBRID",
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
                          top: 20,bottom: 20,left: 1,right: 1,
                          child: Container(
                            alignment: AlignmentDirectional.center,
                            height: 40,width: 40,
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
                            child: HeaderTxtWidget(con.dump_volume>0?"${((con.dump_volume * 100)/volumeApplied).toStringAsFixed(2)}%":"0%",color: ThemeColor.colorbtnPrimary,),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 80,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeaderTxtWidget("DUMP VOLUME:"),
                        const SizedBox(width: 20,),
                        PowerTxtWidget("${con.dump_volume}m",color: ThemeColor.colorbtnPrimary,fontSize: 20,),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeaderTxtWidget("ACTUAL APPLIED:"),
                        const SizedBox(width: 20,),
                        PowerTxtWidget("${volumeApplied}m",color: ThemeColor.colorbtnPrimary,fontSize: 20,),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
