import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/ui/Equipment/v/equipment_details.dart';
import 'package:scms/ui/Equipment/v/equipment_list_page.dart';
import 'package:scms/widgets/header_txt_widget.dart';
typedef callback=Function(
    Widget child,
    String tilte,
    );

class EquipmentPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
  callback onTap;

  EquipmentPage(this.onTap);

}

class _PageState extends StateMVC<EquipmentPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20,),
          ListTile(
            title: HeaderTxtWidget('Add Equipment Performance'),
            trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey.shade500,size: 25,),
            onTap: (){
              widget.onTap.call(EquipmentListPage(),"Equipment Performance");
              // Navigator.pushNamed(context, '/equipment_list');
            },
          ),
          ListTile(
            title: HeaderTxtWidget('Equipment Performance'),
            trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey.shade500,size: 25,),
            onTap: (){
              widget.onTap.call(EquipmentDetails(),"Equipment Performance");
              // Navigator.pushNamed(context, '/equipment_details');
            },
          ),
        ],
      ),
      
    );
  }

}
