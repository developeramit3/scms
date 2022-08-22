import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/Utils/tools.dart';
import 'package:scms/widgets/button_primary_widget.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/input_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';

import '../../../widgets/header_txt_widget.dart';

typedef callback = Function(String val);

class DumpValueDailogWidget extends StatelessWidget {
  callback? listener;
  String? error;
  DumpValueDailogWidget({this.listener});

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
                  Container(
                    child: Column(
                      children: [
                        HeaderTxtWidget("Volume Completed day"),
                        const SizedBox(height: 10,),
                       /* Stack(
                          children: [
                            PieChart(
                              dataMap: {
                                "Applied": 5,
                                "Left": 1,
                              },
                              animationDuration: Duration(milliseconds: 800),
                              chartLegendSpacing: 32,
                              chartValuesOptions: ChartValuesOptions(
                                showChartValues: false,
                              ),
                              chartRadius: MediaQuery.of(context).size.width / 5,
                              colorList: Tools.colorList,
                              initialAngleInDegree: 0,
                              chartType: ChartType.ring,
                              ringStrokeWidth: 32,
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
                                          color: Colors.grey.shade200,
                                          blurRadius: 5
                                      ),
                                      BoxShadow(
                                          color: Colors.grey.shade300,
                                          blurRadius: 5
                                      ),
                                    ],
                                    color: Colors.grey.shade100
                                ),
                                child: SubTxtWidget("10%"),
                              ),
                            )
                          ],
                        ),*/
                        const SizedBox(height: 10,),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                        color: ThemeColor.colorbtnPrimary
                    ),
                    child:  Row(
                      children: [
                        Expanded(
                          child:ButtonPrimaryWidget('YES',padding: 8,onTap: (){

                          },),
                          flex: 1,
                        ),
                        Container(
                          color: Colors.grey.shade300,
                          height: 40,
                          width: 1,
                        ),
                        Expanded(
                          child:ButtonPrimaryWidget('CANCEL',padding: 8,onTap: ()=>Navigator.pop(context),),
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
}
