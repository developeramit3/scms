import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/tools.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:scms/widgets/input_widget.dart';
import '../../../Utils/theme_color.dart';
import '../../../widgets/sub_txt_widget.dart';
import '../c/trials_controller.dart';
class AddTrialsPage extends StatefulWidget {

  @override
  _PageState createState() => _PageState();

}

class _PageState extends StateMVC<AddTrialsPage> {
  TrialsController? _con;
  String StartDate="";
  String EndDate="";
  String SelectedValue="Schedule";
  var Details = TextEditingController();
  _PageState() : super(TrialsController()) {
    _con = controller as TrialsController?;
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
          'Add Trial',
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
                  Expanded(child: Column(
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
                  ),flex: 1,),
                  const SizedBox(width: 20,),
                  Expanded(child: Column(
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
                  ),flex: 1,),
                ],
              ),
              Row(
                children: [
                  Radio(value: SelectedValue, groupValue: 'Schedule', onChanged:(v){
                    setState(() {
                      SelectedValue="Schedule";
                    });
                  }),
                  HeaderTxtWidget('Schedule',fontSize: 16,),
                ],
              ),
              Row(
                children: [
                  Radio(value: SelectedValue, groupValue: 'Completed', onChanged:(v){
                    setState(() {
                      SelectedValue="Completed";
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
                  map['details']=Details.value.text.toString();
                  map['type']=SelectedValue=="Completed"?1:0;
                  _con!.addTrials(map);
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
