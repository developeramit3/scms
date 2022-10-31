import 'package:flutter/material.dart';
import 'package:scms/widgets/sub_txt_widget.dart';
import '../../../globle/m/project_model.dart';
import '../../../widgets/button_primary_widget.dart';
import '../../../widgets/header_txt_widget.dart';
import '../../../widgets/input_widget.dart';
import '../c/project_list_controller.dart';

class AddProjectWidget extends StatelessWidget {
  ProjectListController con;
  String? error;

  AddProjectWidget(this.con);

  @override
  Widget build(BuildContext context) => StatefulBuilder(builder: (context, setState) => Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height*0.7,
    padding: EdgeInsets.only(top: 20,left:20,right:20,bottom: MediaQuery.of(context).viewInsets.bottom),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeaderTxtWidget("Add Project"),
          if(error!=null)
          SubTxtWidget("$error",color: Colors.red,),
          InputWidget(hint:"Project real name",controller: con.project_real_name,),
          InputWidget(hint:"Project total volume",controller: con.project_total_volume,inputType: TextInputType.number,),
          InputWidget(hint:"Project total wastage",controller: con.project_total_wastage,inputType: TextInputType.number,),
          InputWidget(hint:"Was per",controller: con.was_per,inputType: TextInputType.number,),
          ButtonPrimaryWidget("Add",onTap: (){
            Project project=Project();
            error=null;
            if(con.project_real_name.value.text.isEmpty){
              error="All field required";
              setState((){});
              return;
            }if(con.project_total_volume.value.text.isEmpty){
              error="All field required";
              setState((){});
              return;
            }if(con.project_total_wastage.value.text.isEmpty){
              error="All field required";
              setState((){});
              return;
            }if(con.was_per.value.text.isEmpty){
              error="All field required";
              setState((){});
              return;
            }
            project.project_real_name=con.project_real_name.value.text.toString();
            project.project_total_volume=con.project_total_volume.value.text.toString();
            project.project_total_wastage=con.project_total_wastage.value.text.toString();
            project.was_per=con.was_per.value.text.toString();

            con.addProject(project);
            Navigator.pop(context);
          },),
        ],
      ),
    ),
  ),);
}
