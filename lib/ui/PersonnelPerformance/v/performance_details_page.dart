import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:scms/widgets/power_txt_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';
import '../../../Utils/tools.dart';
import 'package:shimmer/shimmer.dart';
import '../../../widgets/chip_widget.dart';
import '../c/personnel_performance_controller.dart';
import '../m/performance_response.dart';

class PerformanceDetailsPage extends StatefulWidget {
  Performance response;

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
    _con!.id = widget.response.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con!.scaffoldKey,
      backgroundColor: Colors.white,
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChipWidget(
              'UPDATE',
              width: 150,
              onTap: () {
                Navigator.pushNamed(context, '/update_personnel_performance', arguments: widget.response).then((value){
                  Navigator.pop(context);
                });
              },
            ),
            ChipWidget(
              'RESET',
              width: 150,
              onTap: () {
                _con!.reset();
              },
            ),
          ],
        )
      ],
      body: Stack(
        children: [
          Container(
            height: 350,
            decoration: BoxDecoration(
                color: ThemeColor.colorPrimary,
                border: Border(
                    bottom:
                        BorderSide(color: Colors.grey.shade400, width: 20))),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeaderTxtWidget(
                  'Performance overview'.toUpperCase(),
                  color: ThemeColor.hexToColor('#6493C1'),
                  fontSize: 16,
                ),
                const SizedBox(
                  height: 10,
                ),
                HeaderTxtWidget(
                  widget.response.name,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 5,
                ),
                SubTxtWidget(
                  widget.response.position.toString().toUpperCase(),
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: HeaderTxtWidget(
                        'CWR',
                        color: Colors.white,
                        textAlign: TextAlign.center,
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: HeaderTxtWidget('HK ID NO',
                          color: Colors.white, textAlign: TextAlign.center,fontSize: 16,),
                    ),
                    Expanded(
                      flex: 1,
                      child: HeaderTxtWidget('GREEN CARD',
                          color: Colors.white, textAlign: TextAlign.center,fontSize: 16,),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SubTxtWidget(
                        '${widget.response.cwr}',
                        color: ThemeColor.colorbtnPrimary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SubTxtWidget(
                        '${widget.response.hkid}',
                        color: ThemeColor.colorbtnPrimary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SubTxtWidget(
                        '${widget.response.greenCard}',
                        color: ThemeColor.colorbtnPrimary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: HeaderTxtWidget(
                        'CWR EXPIRY',
                        color: Colors.white,
                        textAlign: TextAlign.center,
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: HeaderTxtWidget('EFNARC',
                          color: Colors.white, textAlign: TextAlign.center,fontSize: 16,),
                    ),
                    Expanded(
                      flex: 1,
                      child: HeaderTxtWidget('GC EXPIRY',
                          color: Colors.white, textAlign: TextAlign.center,fontSize: 16,),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SubTxtWidget(
                        Tools.changeDate(widget.response.cwrExpiryDate,"dd-MM-yyyy"),
                        color: ThemeColor.colorbtnPrimary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SubTxtWidget(
                        'YES',
                        color: ThemeColor.colorbtnPrimary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SubTxtWidget(
                        Tools.changeDate(widget.response.expiryDate,"dd-MM-yyyy"),
                        color: ThemeColor.colorbtnPrimary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 70,
                ),
                _chartVolume(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartVolume() {
    if (_con!.isLoading) {
      return Container(
        height: 100,
        decoration:
            const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
        margin: const EdgeInsets.all(5),
      );
    } else {
      double volume =
          double.parse(_con!.selectedProject!.project_total_volume.toString());
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
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 60,
                chartValuesOptions: const ChartValuesOptions(
                  showChartValues: false,
                ),
                chartRadius: MediaQuery.of(context).size.width / 3,
                colorList: Tools.colorList,
                initialAngleInDegree: 270,
                chartType: ChartType.ring,
                ringStrokeWidth: 100,
                legendOptions: const LegendOptions(
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
                top: 15,
                bottom: 15,
                left: 1,
                right: 1,
                child: Container(
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 2,
                            spreadRadius: 5),
                      ],
                      color: Colors.grey.shade100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SubTxtWidget(
                        'PERFORMANCE',
                        fontSize: 14,
                      ),
                      SubTxtWidget(
                        "${value.toStringAsFixed(2)}%",
                        color: ThemeColor.colorbtnPrimary,
                        fontSize: 18,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    HeaderTxtWidget(
                      'APPLIED',
                      fontSize: 18,
                    ),
                    PowerTxtWidget(
                      '${_con!.totalVolume}m',
                      color: ThemeColor.colorbtnPrimary,
                      fontSize: 16,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    HeaderTxtWidget(
                      'TOTAL',
                      fontSize: 18,
                    ),
                    PowerTxtWidget(
                      '${_con!.totalVolume}m',
                      color: ThemeColor.colorbtnPrimary,
                      fontSize: 16,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      );
    }
  }
}
