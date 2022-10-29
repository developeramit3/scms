import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/Utils/tools.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:scms/widgets/input_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';

import '../c/stock_controller.dart';
class AddStockPage extends StatefulWidget {
  StockController con;
  @override
  _PageState createState() => _PageState();
  AddStockPage(this.con);
}
class _PageState extends State<AddStockPage> {
  var Accelerator = TextEditingController();
  var Superplastersizer = TextEditingController();
  var HCA = TextEditingController();
  var Mono = TextEditingController();
  var Duro = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: HeaderTxtWidget(
          'Add Stock',
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

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InputWidget(sub_title: "Accelerator (IBC)",controller: Accelerator,inputType: TextInputType.number,),
              InputWidget(sub_title: "Superplastersizer (Ltrs)",controller: Superplastersizer,inputType: TextInputType.number,),
              InputWidget(sub_title: "HCA (Ltrs)",controller: HCA,inputType: TextInputType.number,),
              InputWidget(sub_title: "Mono (Kg)",controller: Mono,inputType: TextInputType.number,),
              InputWidget(sub_title: "Duro (Kg)",controller: Duro,inputType: TextInputType.number,),
              const SizedBox(height: 20,),
              ChipWidget('SAVE',width: 150,onTap: (){
                if(Validate()){
                  widget.con.materialResponse!.accelerator=getVal(widget.con.materialResponse!.accelerator,Accelerator.value.text.toString());
                  widget.con.materialResponse!.super_plaster_size=getVal(widget.con.materialResponse!.super_plaster_size,Superplastersizer.value.text.toString());
                  widget.con.materialResponse!.hsc=getVal(widget.con.materialResponse!.hsc,HCA.value.text.toString());
                  widget.con.materialResponse!.fiber_1=getVal(widget.con.materialResponse!.fiber_1,Mono.value.text.toString());
                  widget.con.materialResponse!.fiber_2=getVal(widget.con.materialResponse!.fiber_2,Duro.value.text.toString());
                  if(widget.con.materialResponse!.id==null) {
                    widget.con.addMaterial(widget.con.materialResponse!);
                  }else{
                    widget.con.updateMaterial(widget.con.materialResponse!);
                  }
                  Navigator.pop(context,true);
                }
              },),
              const SizedBox(height: 50,),
            ],
          ),
        ),
      ),

    );
  }
  bool Validate(){
    if(Accelerator.value.text.isEmpty){
      Tools.ShowErrorMessage(context, 'Accelerator Required');
      return false;
    }if(Superplastersizer.value.text.isEmpty){
      Tools.ShowErrorMessage(context, 'Superplastersizer Required');
      return false;
    }if(HCA.value.text.isEmpty){
      Tools.ShowErrorMessage(context, 'HCA Required');
      return false;
    }if(Mono.value.text.isEmpty){
      Tools.ShowErrorMessage(context, 'Mono Required');
      return false;
    }if(Duro.value.text.isEmpty){
      Tools.ShowErrorMessage(context, 'Duro Required');
      return false;
    }

    return true;
  }
  String getVal(String old, String New){
    if(New.isEmpty){
      return old;
    }else {
      double val=double.tryParse(old)??0;
      double val_new=double.tryParse(New)??0;
      return (val+val_new).toString();
    }
  }

}
