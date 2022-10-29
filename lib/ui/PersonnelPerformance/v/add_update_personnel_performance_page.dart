import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/Utils/tools.dart';
import 'package:scms/ui/PersonnelPerformance/m/performance_response.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:scms/widgets/input_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';
import '../c/personnel_performance_controller.dart';
class AddUpdatePersonnelPerformancePage extends StatefulWidget {
  Performance? response;

  @override
  _PageState createState() => _PageState();

  AddUpdatePersonnelPerformancePage({this.response});
}

class _PageState extends StateMVC<AddUpdatePersonnelPerformancePage> {
  PersonnelPerformanceController? _con;
  var name = TextEditingController();
  var position = TextEditingController();
  var hk_id = TextEditingController();
  var cwr = TextEditingController();
  var green_card = TextEditingController();
  String GreenCardExpiryDate="";
  String CWRExpiryDate="";
  _PageState() : super(PersonnelPerformanceController()) {
    _con = controller as PersonnelPerformanceController?;
  }

  @override
  void initState() {
    super.initState();
    if(widget.response!=null){
      name.text=widget.response!.name;
      position.text=widget.response!.position;
      hk_id.text=widget.response!.hkid;
      cwr.text=widget.response!.cwr;
      green_card.text=widget.response!.greenCard;
      GreenCardExpiryDate=widget.response!.expiryDate;
      CWRExpiryDate=widget.response!.cwrExpiryDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: HeaderTxtWidget(
          widget.response==null?'Add Personnel Performance':'Update Personnel Performance',
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
              InputWidget(sub_title: "Name",controller: name,),
              InputWidget(sub_title: "Position",controller: position,),
              InputWidget(sub_title: "Hk ID",controller: hk_id,),
              InputWidget(sub_title: "CWR",controller: cwr,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubTxtWidget("CWR ExpiryDate"),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      height: 50,
                      alignment: AlignmentDirectional.centerStart,
                      child: SubTxtWidget('$CWRExpiryDate'),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          border: Border.all(color: ThemeColor.colorPrimary)
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2100));
                      if (pickedDate != null) {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          CWRExpiryDate= formattedDate; //set output date to TextField value.
                        });
                      }
                    },
                  )
                ],
              ),
              InputWidget(sub_title: "Green Card",controller: green_card,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubTxtWidget("Green Card ExpiryDate"),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      height: 50,
                      alignment: AlignmentDirectional.centerStart,
                      child: SubTxtWidget('$GreenCardExpiryDate'),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          border: Border.all(color: ThemeColor.colorPrimary)
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2100));
                      if (pickedDate != null) {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          GreenCardExpiryDate= formattedDate; //set output date to TextField value.
                        });
                      }
                    },
                  )
                ],
              ),
              const SizedBox(height: 20,),
              ChipWidget('SUBMIT',width: 150,onTap: (){
                if(Validate()){
                  Map<String,dynamic>map=Map();
                  map['name']=name.value.text.toString();
                  map['position']=position.value.text.toString();
                  map['hkid']=hk_id.value.text.toString();
                  map['cwr']=cwr.value.text.toString();
                  map['green_card']=green_card.value.text.toString();
                  map['cwr_expiry_date']=CWRExpiryDate;
                  map['expiry_date']=GreenCardExpiryDate;
                  map['project_id']=_con!.selectedProject!.id;
                  if(widget.response==null) {
                    _con!.addPerformance(map);
                  }else{
                    map['id']=widget.response!.id;
                    _con!.updatePerformance(map);
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
    if(name.value.text.isEmpty){
      Tools.ShowErrorMessage(context, 'Name Required');
      return false;
    }if(position.value.text.isEmpty){
      Tools.ShowErrorMessage(context, 'Position Required');
      return false;
    }if(hk_id.value.text.isEmpty){
      Tools.ShowErrorMessage(context, 'Hk ID Required');
      return false;
    }if(cwr.value.text.isEmpty){
      Tools.ShowErrorMessage(context, 'CWR Required');
      return false;
    }if(CWRExpiryDate.isEmpty){
      Tools.ShowErrorMessage(context, 'CWR Expiry Date Required');
      return false;
    }if(green_card.value.text.isEmpty){
      Tools.ShowErrorMessage(context, 'Green Card Required');
      return false;
    }
    if(GreenCardExpiryDate.isEmpty){
      Tools.ShowErrorMessage(context, 'Green Card Expiry Date Required');
      return false;
    }
    return true;
  }

}
