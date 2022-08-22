import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/ui/Task/v/add_task_dailog_widget.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../c/stock_controller.dart';

class StockManagementPage extends StatefulWidget {

  @override
  _PageState createState() => _PageState();

}

class _PageState extends StateMVC<StockManagementPage> {
  StockController? _con;
  int type=0;
  _PageState() : super(StockController()) {
    _con = controller as StockController?;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: HeaderTxtWidget(
          'Stock Management',
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
        if((_con!.user!=null&&_con!.user!.user_type=="0")||type==1)
         Center(
           child: ChipWidget(type==0?'Reset':'Add Stock',width: 100,onTap: (){
             if(type==0){
               _con!.resetMaterial();
             }else{
               Navigator.pushNamed(context, '/add_stock').then((value){
                 if(value!=null){
                   type=0;
                   _con!.getMaterial(0);
                 }
               });
             }
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
                        'Usage',
                        fontSize: 16,
                      ),
                      padding: EdgeInsets.all(10),
                      alignment: AlignmentDirectional.center,
                      decoration:BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: type==0?ThemeColor.colorPrimary:Colors.grey.shade400,width: 2),
                          )
                      ),
                    ),
                    onTap: (){
                      if(type!=0){
                        type=0;
                        _con!.getMaterial(type);
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
                        'Stock',
                        fontSize: 16,
                      ),
                      padding: EdgeInsets.all(10),
                      alignment: AlignmentDirectional.center,
                      decoration:BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: type==1?ThemeColor.colorPrimary:Colors.grey.shade400,width: 2),
                          )
                      ),
                    ),
                    onTap: (){
                      if(type!=1){
                        type=1;
                        _con!.getMaterial(type);
                      }
                    },
                  )
              ),

            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Table(
              border: TableBorder.all(
                  color: Colors.grey.shade400,
                  style: BorderStyle.solid,
                  width: 1),
              children: [
                TableRow( children: [
                  Padding(padding: EdgeInsets.all(8),
                    child: HeaderTxtWidget(
                      'Materials',
                      fontSize: 16,
                    ),),
                  Padding(padding: EdgeInsets.all(8),
                    child: HeaderTxtWidget(
                      'Usage',
                      fontSize: 16,
                    ),),
                ]),
                TableRow( children: [
                  Padding(padding: EdgeInsets.all(8),
                    child: SubTxtWidget(
                      'Accelerator (IBC)',
                      fontSize: 16,
                    ),),
                  Padding(padding: EdgeInsets.all(8),
                    child:_con!.materialResponse==null?_loadingLine():SubTxtWidget(
                      '${_con!.materialResponse!.accelerator}',
                      fontSize: 16,
                    ),),
                ]),
                TableRow( children: [
                  Padding(padding: EdgeInsets.all(8),
                    child: SubTxtWidget(
                      'Superplastersizer (Ltrs)',
                      fontSize: 16,
                    ),),
                  Padding(padding: EdgeInsets.all(8),
                    child:_con!.materialResponse==null?_loadingLine():SubTxtWidget(
                      '${_con!.materialResponse!.super_plaster_size}',
                      fontSize: 16,
                    ),),
                ]),
                TableRow( children: [
                  Padding(padding: EdgeInsets.all(8),
                    child: SubTxtWidget(
                      'HCA (Ltrs)',
                      fontSize: 16,
                    ),),
                  Padding(padding: EdgeInsets.all(8),
                    child:_con!.materialResponse==null?_loadingLine():SubTxtWidget(
                      '${_con!.materialResponse!.hsc}',
                      fontSize: 16,
                    ),),
                ]),
                TableRow( children: [
                  Padding(padding: EdgeInsets.all(8),
                    child: SubTxtWidget(
                      'Mono (KG)',
                      fontSize: 16,
                    ),),
                  Padding(padding: EdgeInsets.all(8),
                    child:_con!.materialResponse==null?_loadingLine():SubTxtWidget(
                      '${_con!.materialResponse!.fiber_1}',
                      fontSize: 16,
                    ),),
                ]),
                TableRow( children: [
                  Padding(padding: EdgeInsets.all(8),
                    child: SubTxtWidget(
                      'Duro (KG)',
                      fontSize: 16,
                    ),),
                  Padding(padding: EdgeInsets.all(8),
                    child:_con!.materialResponse==null?_loadingLine():SubTxtWidget(
                      '${_con!.materialResponse!.fiber_2}',
                      fontSize: 16,
                    ),),
                ]),
              ],
            ),
          ),
          _barChart(),
        ],
      ),
      
    );
  }
Widget _loadingLine(){
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade500,
      enabled: true,
      child: Container(
        height: 20,
        color: Colors.grey,
      ),
    );
}
  Widget _barChart(){
    if(_con!.materialResponse==null){
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade500,
        enabled: true,
        child: Container(
            margin:const EdgeInsets.symmetric(vertical: 5),
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
      List<TempModel>list=[];
      list.add(TempModel("Accelerator\n (IBC)",double.tryParse(_con!.materialResponse!.accelerator.toString())??0));
      list.add(TempModel("Superplastersizer\n (Ltrs)",double.tryParse(_con!.materialResponse!.super_plaster_size.toString())??0));
      list.add(TempModel("HCA (Ltrs)",double.tryParse(_con!.materialResponse!.hsc.toString())??0));
      list.add(TempModel("Mono (KG)",double.tryParse(_con!.materialResponse!.fiber_1.toString())??0));
      list.add(TempModel("Duro (KG)",double.tryParse(_con!.materialResponse!.fiber_2.toString())??0));
      return SfCartesianChart(
          primaryXAxis: CategoryAxis(
            labelRotation: -45,
            labelAlignment:LabelAlignment.center,
            labelPlacement: LabelPlacement.betweenTicks,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<TempModel, String>>[
            ColumnSeries<TempModel, String>(
                dataSource:list,
                xValueMapper: (TempModel sales, _) => sales.key,
                yValueMapper: (TempModel sales, _) => sales.value,
                color: ThemeColor.colorbtnPrimary,
                dataLabelSettings: DataLabelSettings(isVisible: true,))]
      );
    }
  }
}
class TempModel{
  String key;
  double value;
  TempModel(this.key,this.value);
}
