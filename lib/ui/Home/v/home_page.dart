import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/services/session_repo.dart';
import 'package:scms/ui/Home/m/delay_response.dart';
import 'package:scms/ui/Home/v/dum_value_dailog_widget.dart';
import 'package:scms/ui/Home/v/total_volume_widget.dart';
import 'package:scms/ui/Home/v/vol_day_dailog_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../Utils/tools.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/chip_widget.dart';
import '../../../widgets/confirm_dailog_widget.dart';
import '../../../widgets/power_txt_widget.dart';
import '../c/home_controller.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  Map map;

  @override
  _PageState createState() => _PageState();

  HomePage(this.map);
}

class _PageState extends StateMVC<HomePage> {
  HomeController? _con;
  final bool animate = true;
  final colorList = <Color>[
    const Color(0xffef8104),
    const Color(0xffced4da),
  ];

  _PageState() : super(HomeController()) {
    _con = controller as HomeController?;
  }

  @override
  void initState() {
    super.initState();
    _con!.selectedProject = widget.map['project'];
    _con!.getProjectDetails();
    _con!.getDelay();
    _con!.getDumvalue();
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
          child: Padding(
            child: Image.asset('assets/img/ic_backward_arrow.png'),
            padding: EdgeInsets.all(15),
          ),
          onTap: () => Navigator.pop(context),
        ),
        actions: [
          InkWell(
            child: Padding(
              child: Image.asset(
                'assets/img/app_menu.png',
                width: 20,
              ),
              padding: EdgeInsets.only(right: 20, left: 10),
            ),
            onTap: () => _con!.scaffoldKey.currentState!.openEndDrawer(),
          ),
        ],
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width,
        backgroundColor: Theme.of(context).backgroundColor,
        child: Drawerer(),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height/4.2,
            decoration: BoxDecoration(
                color: ThemeColor.colorPrimary,
                border: Border(
                    bottom:
                        BorderSide(color: Colors.grey.shade400, width: 20))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    HeaderTxtWidget(
                      'Project Overview'.toUpperCase(),
                      color: ThemeColor.hexToColor('#6493C1'),
                      fontSize: 16,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    HeaderTxtWidget(
                      widget.map['project_real_name'],
                      color: Colors.white,
                      fontSize: 25,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: PowerTxtWidget(
                                _con!.projectResponse != null
                                    ? "Total Volume\n ${widget.map['project_total_volume']}m"
                                    : "Total Volume\n 0m",
                                color: Colors.white,fontSize: 16,),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SubTxtWidget('Completion\nTime',
                              color: Colors.white, textAlign: TextAlign.center,fontSize: 16),
                        ),
                        Expanded(
                          flex: 1,
                          child: SubTxtWidget('Wastage\nCalculation',
                              color: Colors.white, textAlign: TextAlign.center,fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: _paiChart(),
              ),
              Container(
                color: ThemeColor.colorPrimary,
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(5),
                child: Stack(
                  children: [
                    Center(
                      child: HeaderTxtWidget(
                        'DELAYS',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Positioned(
                      child: SubTxtWidget(
                        'View More',
                        color: ThemeColor.hexToColor('#969696'),
                      ),
                      right: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: _barChart(),
              )
            ],
          ),
        ],
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: ChipWidget(
                'TASK FORMS',
                fontSize: 12,
                onTap: () {
                  Navigator.pushNamed(context, '/task', arguments: _con!.selectedProject);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: ChipWidget(
                'ALERTS',
                fontSize: 12,
              ),
            ),
            Expanded(
              flex: 1,
              child: ChipWidget(
                'VOL / DAY',
                fontSize: 12,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          content: VolDayDailogWidget(
                              _con!.projectResponse!.volume_complete_day,
                            listener: (val) {
                              _con!.postValDay(val);
                            },
                          ));
                    },
                  );
                },
              ),
            ),

            if (_con!.user != null && _con!.user!.user_type != "2")
              Expanded(
                flex: 1,
                child: ChipWidget(
                  'RESET',
                  fontSize: 12,
                  onTap: () {
                    if (_con!.user!.user_type == "0") {
                      _con!.reset();
                    } else {
                      Tools.ShowErrorMessage(
                          context, 'You does not allow for reset');
                    }
                  },
                ),
              ),
          ]
        )
      ],
    );
  }

  Widget _paiChart() {
    if (_con!.isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade500,
        enabled: true,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 100,
                    decoration: const BoxDecoration(
                        color: Colors.grey, shape: BoxShape.circle),
                    margin: const EdgeInsets.all(5),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 100,
                    decoration: const BoxDecoration(
                        color: Colors.grey, shape: BoxShape.circle),
                    margin: const EdgeInsets.all(5),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 100,
                    decoration: const BoxDecoration(
                        color: Colors.grey, shape: BoxShape.circle),
                    margin: const EdgeInsets.all(5),
                  ),
                ),
              ],
            )),
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: _chartVolume(),
          ),
          Expanded(
            flex: 1,
            child: _dayChart(),
          ),
          Expanded(
            flex: 1,
            child: _chartWastage(),
          ),
        ],
      );
    }
  }

  Widget _dayChart() {
    String start = _con!.projectResponse!.start_day;
    dynamic dayRunnings = 0;
    if (start.isEmpty) {
      dayRunnings = 0;
    } else {
      final birthday = DateTime.parse(start);
      final date2 = DateTime.now();
      dayRunnings = date2.difference(birthday).inDays;
    }
    double volumeAppliedPerDay =
        double.parse(_con!.projectResponse!.volume_complete_day.toString());
    if (volumeAppliedPerDay == 0) volumeAppliedPerDay = 1;
    double volumeApplied =
        double.parse(_con!.projectResponse!.volume.toString());
    double volumeLeft = widget.map['project_total_volume'] - volumeApplied;
    double volumeAppliedPercent = volumeLeft / volumeAppliedPerDay;
    double day_Left = volumeAppliedPercent - dayRunnings;
    double day_complete = volumeAppliedPercent - day_Left;
    String app = day_complete.toStringAsFixed(0);
    String done = volumeAppliedPercent.toStringAsFixed(0);
    double value = day_complete * 100;
    value = value / (volumeAppliedPercent + day_complete);

    return Column(
      children: [
        Stack(
          children: [
            PieChart(
              dataMap: {
                "Complete": day_complete,
                "Left": volumeAppliedPercent,
              },
              animationDuration: Duration(milliseconds: 1400),
              chartLegendSpacing: 32,
              chartValuesOptions: ChartValuesOptions(
                showChartValues: false,
              ),
              chartRadius: MediaQuery.of(context).size.width / 5,
              colorList: colorList,
              initialAngleInDegree: 270,
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
              top: 20,
              bottom: 20,
              left: 1,
              right: 1,
              child: Container(
                alignment: AlignmentDirectional.center,
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 2,
                          spreadRadius: 5),
                    ],
                    color: Colors.grey.shade100),
                child: SubTxtWidget('${value.toStringAsFixed(2)}%'),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SubTxtWidget('DAYS COMPLETED'),
        SubTxtWidget(
          app,
          color: ThemeColor.hexToColor('#EE794E'),
          fontSize: 18,
        ),
        SubTxtWidget('DAYS REMAINING'),
        SubTxtWidget(
          done,
          color: ThemeColor.hexToColor('#EE794E'),
          fontSize: 18,
        ),
      ],
    );
  }

  Widget _chartVolume() {
    double volumeApplied =
        double.parse(_con!.projectResponse!.volume.toString());
    double volumeLeft = widget.map['project_total_volume'] - volumeApplied;
    double value = volumeApplied * 100;
    value = value / widget.map['project_total_volume'];

    return Column(
      children: [
        InkWell(
          child: Stack(
            children: [
              PieChart(
                dataMap: {
                  "Applied": volumeApplied,
                  "Left": volumeLeft,
                },
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartValuesOptions: const ChartValuesOptions(
                  showChartValues: false,
                ),
                chartRadius: MediaQuery.of(context).size.width / 5,
                colorList: colorList,
                initialAngleInDegree: 270,
                chartType: ChartType.ring,
                ringStrokeWidth: 32,
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
                top: 20,
                bottom: 20,
                left: 1,
                right: 1,
                child: Container(
                  alignment: AlignmentDirectional.center,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 2,
                            spreadRadius: 5),
                      ],
                      color: Colors.grey.shade100),
                  child: SubTxtWidget(value.toStringAsFixed(2) + "%"),
                ),
              )
            ],
          ),
          onTap: (){
            showModalBottomSheet<void>(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                enableDrag: true,
                backgroundColor: Colors.white,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius:  const BorderRadius.only(
                        topLeft:  Radius.circular(20.0),
                        topRight:  Radius.circular(20.0),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: TotalVolumeWidget(_con!),
                  );
                });

          },
        ),
        const SizedBox(
          height: 20,
        ),
        SubTxtWidget('APPLIED'),
        PowerTxtWidget(
          volumeApplied.toStringAsFixed(1) + "m",
          color: ThemeColor.hexToColor('#EE794E'),
          fontSize: 18,
        ),
        SubTxtWidget('REMAINING'),
        PowerTxtWidget(
          volumeLeft.toStringAsFixed(1) + "m",
          color: ThemeColor.hexToColor('#EE794E'),
          fontSize: 18,
        ),
      ],
    );
  }

  Widget _chartWastage() {
    double volumeApplied =
        double.parse(_con!.projectResponse!.volume.toString());
    double wastageApplied = volumeApplied * widget.map['was_per'];
    double wastageLeft = widget.map['project_total_wastage'] - wastageApplied;
    double value = wastageApplied * 100;
    value = value / widget.map['project_total_wastage'];

    return Column(
      children: [
        InkWell(
          child: Stack(
            children: [
              PieChart(
                dataMap: {
                  "Applied": wastageApplied,
                  "Left": wastageLeft,
                },
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartValuesOptions: ChartValuesOptions(
                  showChartValues: false,
                ),
                chartRadius: MediaQuery.of(context).size.width / 5,
                colorList: Tools.colorList,
                initialAngleInDegree: 270,
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
                top: 20,
                bottom: 20,
                left: 1,
                right: 1,
                child: Container(
                  alignment: AlignmentDirectional.center,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 2,
                            spreadRadius: 5),
                      ],
                      color: Colors.grey.shade100),
                  child: SubTxtWidget(value.toStringAsFixed(2) + "%"),
                ),
              )
            ],
          ),
          onTap: () {
            showModalBottomSheet<void>(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                enableDrag: true,
                backgroundColor: Colors.white,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius:  const BorderRadius.only(
                        topLeft:  Radius.circular(20.0),
                        topRight:  Radius.circular(20.0),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: DumpValueDailogWidget(_con!),
                  );
                });
          },
        ),
        const SizedBox(
          height: 20,
        ),
        SubTxtWidget('ACTUAL WASTAGE'),
        PowerTxtWidget(
          wastageApplied.toStringAsFixed(0) + "m",
          color: ThemeColor.hexToColor('#EE794E'),
          fontSize: 18,
        ),
        SubTxtWidget('REMAINING'),
        SubTxtWidget(
          wastageLeft.toStringAsFixed(0),
          color: ThemeColor.hexToColor('#EE794E'),
          fontSize: 18,
        ),
      ],
    );
  }

  Widget _barChart() {
    if (_con!.isLoadingDelay) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade500,
        enabled: true,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Container(
                  height: 210,
                  width: 20,
                  color: Colors.grey,
                  margin: const EdgeInsets.all(5),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.grey,
                      height: 200,
                    ),
                    Container(
                      height: 20,
                      color: Colors.grey,
                      margin: const EdgeInsets.only(bottom: 5, top: 5),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ))
              ],
            )),
      );
    } else {
      return SfCartesianChart(
          primaryXAxis: CategoryAxis(
            labelRotation: -45,
            maximumLabels: 100,
            autoScrollingDelta: 10,
            majorGridLines: MajorGridLines(width: 0),
            majorTickLines: MajorTickLines(width: 0),
          ),
          zoomPanBehavior: ZoomPanBehavior(
            enablePanning: true,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<DelayResponse, String>>[
            ColumnSeries<DelayResponse, String>(
                dataSource: _con!.delayList,
                xValueMapper: (DelayResponse sales, _) => sales.delay_date,
                yValueMapper: (DelayResponse sales, _) => sales.delay,
                color: ThemeColor.colorbtnPrimary,
                dataLabelSettings: DataLabelSettings(isVisible: true))
          ]);
    }
  }

  Widget Drawerer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            title: SubTxtWidget(
              'Home',
              color: Colors.white,
              fontSize: 16,
            ),
            onTap: () => Navigator.pop(context),
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Image.asset(
              "assets/img/proj_ico.png",
              height: 25,
              width: 30,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            title: SubTxtWidget(
              'Projects',
              color: Colors.white,
              fontSize: 18,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Image.asset(
              "assets/img/person_ico.png",
              height: 25,
              width: 30,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            title: SubTxtWidget(
              'Personnel Performance',
              color: Colors.white,
              fontSize: 18,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/personnel_performance',
                  arguments: _con!.selectedProject);
            },
          ),
          const Divider(height: 1,),
          ListTile(
            leading: Image.asset("assets/img/eq_ico2.png",height: 25,width: 30,),
            contentPadding: EdgeInsets.symmetric(vertical: 1,horizontal: 10),
            title: SubTxtWidget('Equipment Performance',color: Colors.white,fontSize: 18,),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/equipment');
            },
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            leading: Image.asset(
              "assets/img/mat_ico.png",
              height: 25,
              width: 30,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            title: SubTxtWidget(
              'Stock Management',
              color: Colors.white,
              fontSize: 18,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/stock');
            },
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.bug_report,
              color: Colors.white,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            title: SubTxtWidget(
              'Testing',
              color: Colors.white,
              fontSize: 18,
            ),
            onTap: () {
              Navigator.pop(context);
              // Navigator.pushNamed(context, '/training');
            },
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.school,
              color: Colors.white,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            title: SubTxtWidget(
              'Training',
              color: Colors.white,
              fontSize: 18,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/training');
            },
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.checklist,
              color: Colors.white,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            title: SubTxtWidget(
              'Trials',
              color: Colors.white,
              fontSize: 18,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/trials');
            },
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.image_outlined,
              color: Colors.white,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            title: SubTxtWidget(
              'Gallery',
              color: Colors.white,
              fontSize: 18,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/gallery');
            },
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            title: SubTxtWidget(
              'Logout',
              color: Colors.white,
              fontSize: 18,
            ),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (ctxt) => ConfirmDailogWidget(
                        title: S.of(context).logout,
                        sub_title: S.of(context).areYouSureYou,
                        listener: () {
                          Logout();
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => false);
                        },
                      ));
            },
          ),
        ],
      ),
    );
  }
}
