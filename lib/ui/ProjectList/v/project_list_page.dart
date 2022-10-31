import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/globle/m/project_model.dart';
import 'package:scms/widgets/button_primary_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../../../services/session_repo.dart';
import '../../../widgets/header_txt_widget.dart';
import '../c/project_list_controller.dart';
import 'add_project_widget.dart';

class ProjectListPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends StateMVC<ProjectListPage> {
  ProjectListController? _con;

  _PageState() : super(ProjectListController()) {
    _con = controller as ProjectListController?;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con!.scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        persistentFooterButtons: _showButton(),
        body: Stack(
          children: [
            Positioned(
              left: 20,
              right: 20,
              top: 60,
              child: Center(
                child: HeaderTxtWidget(
                  'PROJECT LISTS',
                  color: ThemeColor.hexToColor('#6493C1'),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 100,
              bottom: 1,
              child: _list(),
            ),
          ],
        ));
  }

  Widget _list() {
    if (_con!.projectModel == null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade500,
        enabled: true,
        child: ListView.separated(
            itemBuilder: (context, index) {
              return ButtonPrimaryWidget(
                "=======",
                color: Colors.grey,
              );
            },
            itemCount: 4,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
                  height: 20,
                )),
      );
    } else {
      return ListView.separated(
          itemBuilder: (context, index) {
            Project project = _con!.projectModel!.list[index];
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              child: ListTile(contentPadding: EdgeInsets.zero,
                title: HeaderTxtWidget(project.project_real_name,textAlign: TextAlign.center,),
                trailing: IconButton(icon: const Icon(Icons.delete,color: Colors.red,),onPressed:()=>_con!.deleteProject(project)),
                onTap:(){
                  setSelectedProject(project.toMap());
                  Navigator.pushNamed(context, '/home',);
                },
              ),
            );
          },
          itemCount: _con!.projectModel!.list.length,
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
                height: 20,
              ));
    }
  }
  dynamic _showButton(){
    if(_con!.userDetails==null){
      return null;
    }if(_con!.userDetails!.user_type=="1"){
      return [ButtonPrimaryWidget("Add Project",onTap: () {
        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: Colors.white,
            builder: (c) {
              return AddProjectWidget(_con!);
            });
      },)];
    }
    return null;
  }
}
