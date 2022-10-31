import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../c/traning_controller.dart';

class TraningPage extends StatefulWidget {

  @override
  _PageState createState() => _PageState();

}

class _PageState extends StateMVC<TraningPage> {
  TraningController? _con;
  int type=0;
  _PageState() : super(TraningController()) {
    _con = controller as TraningController?;
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
        if(_con!.user!=null&&_con!.user!.user_type=="1")
         Center(
           child: ChipWidget('ADD FILE',width: 150,onTap: () async {
            await FilePicker.platform.pickFiles(
               type: FileType.custom,
               allowedExtensions: ['ppt', 'pdf', 'doc'],
             ).then((value){
               if(value!=null){
                 _con!.addFile(value.files.first,type);
               }
            });
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
                        'Modules',
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
                        _con!.getTraining(type);
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
                        'Exam papers',
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
                        _con!.getTraining(type);
                      }
                    },
                  )
              ),

            ],
          ),
          _files()
        ],
      ),
      
    );
  }
  Widget _files() {
    if (_con!.isLoading) {
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
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            child: HeaderTxtWidget(
                              "File: ${_con!.list[index].file_name}",
                              fontSize: 18,
                            ),
                            onTap: (){
                              _con!.downloadFile(_con!.list[index]);
                            },
                          ),
                        ),
                        if(_con!.user!.user_type=="0")
                        IconButton(onPressed: () {
                          _con!.deleteTraining(_con!.list[index].id,type);
                        }, icon: Icon(Icons.delete)),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                      height: 1,
                    ),
                  ],
                ),
              );
            },
            itemCount: _con!.list.length,
          ));
    }
  }
}
