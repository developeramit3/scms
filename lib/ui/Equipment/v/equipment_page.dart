import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import '../c/equipment_controller.dart';

class EquipmentPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();

}

class _PageState extends StateMVC<EquipmentPage> {
  EquipmentController? _con;
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
          'Equipment Performance',
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
      body: Column(
        children: [
          const SizedBox(height: 20,),
          ListTile(
            title: HeaderTxtWidget('Add Equipment Performance'),
            trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey.shade500,size: 25,),
            onTap: (){
              Navigator.pushNamed(context, '/equipment_list');
            },
          ),
          ListTile(
            title: HeaderTxtWidget('Equipment Performance'),
            trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey.shade500,size: 25,),
            onTap: (){
              Navigator.pushNamed(context, '/equipment_details');
            },
          ),
        ],
      ),
      
    );
  }

}
