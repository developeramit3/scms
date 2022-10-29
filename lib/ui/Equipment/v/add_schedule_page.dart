import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/tools.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:scms/widgets/input_widget.dart';
import '../../../Utils/theme_color.dart';
import '../../../widgets/sub_txt_widget.dart';
import '../c/equipment_controller.dart';
class AddSchedulePage extends StatefulWidget {

  @override
  _PageState createState() => _PageState();

}

class _PageState extends StateMVC<AddSchedulePage> {
  EquipmentController? _con;
  String StartDate="";
  String EndDate="";
  String SelectedValue="Schedule";
  var Details = TextEditingController();
  _PageState() : super(EquipmentController()) {
    _con = controller as EquipmentController?;
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
          'Add Schedule Maintenance',
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
              Row(
                children: [
                  Expanded(flex: 1,child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubTxtWidget("Start Date"),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          height: 50,
                          alignment: AlignmentDirectional.centerStart,
                          child: SubTxtWidget('$StartDate'),
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
                              StartDate= formattedDate; //set output date to TextField value.
                            });
                          }
                        },
                      )
                    ],
                  ),),
                  const SizedBox(width: 20,),
                  Expanded(flex: 1,child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubTxtWidget("End Date"),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          height: 50,
                          alignment: AlignmentDirectional.centerStart,
                          child: SubTxtWidget('$EndDate'),
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
                              EndDate= formattedDate; //set output date to TextField value.
                            });
                          }
                        },
                      )
                    ],
                  ),),
                ],
              ),
              Row(
                children: [
                  Radio(value: SelectedValue, groupValue: '0', onChanged:(v){
                    setState(() {
                      SelectedValue="0";
                    });
                  }),
                  HeaderTxtWidget('Schedule',fontSize: 16,),
                ],
              ),
              Row(
                children: [
                  Radio(value: SelectedValue, groupValue: '1', onChanged:(v){
                    setState(() {
                      SelectedValue="1";
                    });

                  }),
                  HeaderTxtWidget('Completed',fontSize: 16,),
                ],
              ),
              const SizedBox(height: 20,),
              InputWidget(sub_title: "Details :",controller: Details,height: 200,),
              const SizedBox(height: 20,),
              ChipWidget('SUBMIT',width: 150,onTap: (){
                if(Validate()){
                  Map<String,dynamic>map=Map();
                  map['start_date']=StartDate;
                  map['end_date']=EndDate;
                  map['type']=SelectedValue;
                  map['details']=Details.value.text.toString();
                  _con!.addSchedule(map);
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
    if(Details.value.text.isEmpty) {
      Tools.ShowErrorMessage(context, 'Accelerator Required');
      return false;
    }if(StartDate.isEmpty){
      Tools.ShowErrorMessage(context, 'StartDate Required');
      return false;
    }if(EndDate.isEmpty){
      Tools.ShowErrorMessage(context, 'EndDate Required');
      return false;
    }

    return true;
  }

}
