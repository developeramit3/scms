import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/ui/Task/v/add_task_dailog_widget.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../c/equipment_controller.dart';
import '../m/equipment_response.dart';
import 'add_equipment_widget.dart';

class EquipmentListPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();

}

class _PageState extends StateMVC<EquipmentListPage> {
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
      persistentFooterButtons:[
         Center(
           child: ChipWidget('ADD',width: 150,onTap: (){
             showDialog(
               context: context,
               builder: (BuildContext context) {
                 return AlertDialog(
                     contentPadding: EdgeInsets.zero,
                     backgroundColor: Colors.transparent,
                     content:AddEquipmentWidget(listener: (val){
                       _con!.addEquipment(val);
                     },)
                 );
               },
             );
           },),
         )
        ],
      body: Column(
        children: [
          _files(),
        ],
      ),
      
    );
  }

  Widget _files() {
    if (_con!.equipmentResponse==null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade500,
        enabled: true,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  color: Colors.grey,
                  margin: const EdgeInsets.only(bottom: 5, top: 5),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )),
      );
    } else {
      return Expanded(
          child: ListView.builder(
        itemBuilder: (context, index) {
          Equipment response=_con!.equipmentResponse!.list[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              children: [
                InkWell(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: HeaderTxtWidget(
                          "${response.name}",
                          fontSize: 18,
                        ),
                      ),
                      IconButton(onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                contentPadding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                content:AddEquipmentWidget(listener: (val){
                                 _con!.updateEquipment(response.id,val);
                                },val: response.name,)
                            );
                          },
                        );
                      }, icon: Icon(Icons.edit)),
                      IconButton(onPressed: () {
                       _con!.deleteEquipment(response.id);
                      }, icon: Icon(Icons.delete)),
                    ],
                  ),
                  onTap: (){

                  },
                ),
                Divider(
                  color: Colors.grey.shade400,
                  height: 1,
                ),
              ],
            ),
          );
        },
        itemCount: _con!.equipmentResponse!.list.length,
      ));
    }
  }
}
