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

class TotalVolumeWidget extends StatelessWidget {
  HomeController con;
  TotalVolumeWidget(this.con);

  @override
  Widget build(BuildContext context) {
    double volumeApplied =
    double.parse(con.projectResponse!.volume.toString());
    double volumeLeft = con.projectResponse!.project_total_volume - volumeApplied;
    double value = volumeApplied * 100;
    value = value / con.projectResponse!.project_total_volume;
    double wastageApplied = volumeApplied * con.projectResponse!.was_per;
    double wastageLeft = con.projectResponse!.project_total_wastage - wastageApplied;

    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10),
          height: MediaQuery.of(context).size.height,
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
                height: MediaQuery.of(context).size.height/4,
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
                    HeaderTxtWidget('Actual total volume'.toUpperCase(),color: Colors.white,),
                    const SizedBox(height: 10,),
                    PowerTxtWidget("${con.projectResponse!.project_total_volume+con.projectResponse!.project_total_wastage}m",color: ThemeColor.colorbtnPrimary,fontSize: 20,),
                    const SizedBox(height: 80,),
                    Stack(
                      children: [
                        PieChart(
                          dataMap: {
                            "Applied": double.parse(con.projectResponse!.volume)+wastageApplied,
                            "Left": volumeLeft+wastageLeft,
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
                          centerText: "",
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
                            child: HeaderTxtWidget("${value.toStringAsFixed(2)}%",color: ThemeColor.colorbtnPrimary,),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 80,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeaderTxtWidget("ACTUAL APPLIED:"),
                        const SizedBox(width: 20,),
                        PowerTxtWidget("${double.parse(con.projectResponse!.volume)+wastageApplied}m",color: ThemeColor.colorbtnPrimary,fontSize: 20,),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeaderTxtWidget("ACTUAL REMAINING:"),
                        const SizedBox(width: 20,),
                        PowerTxtWidget("${volumeLeft+wastageLeft}m",color: ThemeColor.colorbtnPrimary,fontSize: 20,),
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
