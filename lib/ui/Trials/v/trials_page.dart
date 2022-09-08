import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/widgets/chip_widget.dart';
import 'package:scms/widgets/header_txt_widget.dart';
import 'package:scms/widgets/sub_txt_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../c/trials_controller.dart';

class TrialsPage extends StatefulWidget {

  @override
  _PageState createState() => _PageState();

}

class _PageState extends StateMVC<TrialsPage> {
  TrialsController? _con;
  int type=0;
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
          'Trials',
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
      persistentFooterButtons:[
        if(_con!.user!=null&&_con!.user!.user_type=="0"&&type!=2)
         Center(
           child: ChipWidget('ADD FILE',width: 100,onTap: () async {
            Navigator.pushNamed(context, '/add_trials');
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
                        'Schedule',
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
                        _con!.getTrails(type);
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
                        'Completed',
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
                        _con!.getTrails(type);
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
                        'Results',
                        fontSize: 16,
                      ),
                      padding: EdgeInsets.all(10),
                      alignment: AlignmentDirectional.center,
                      decoration:BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: type==2?ThemeColor.colorPrimary:Colors.grey.shade400,width: 2),
                          )
                      ),
                    ),
                    onTap: (){
                      if(type!=2){
                        type=2;
                        _con!.getTrails(type);
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
                child: InkWell(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SubTxtWidget(
                                  "Start Date: ${_con!.list[index].start_date}",
                                  fontSize: 16,
                                ),
                                SubTxtWidget(
                                  "End Date: ${_con!.list[index].end_date}",
                                  fontSize: 16,
                                ),
                                SubTxtWidget(
                                  "Details: ${_con!.list[index].details}",
                                  fontSize: 16,
                                ),
                                if(type==2)
                                  SubTxtWidget(
                                    "File: ${_con!.list[index].filename}",
                                    fontSize: 16,
                                  ),
                              ],
                            ),
                          ),
                          if(type==1)
                            IconButton(onPressed: () async {
                              await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['ppt', 'pdf', 'doc'],
                              ).then((value){
                                if(value!=null){
                                  _con!.addFile(_con!.list[index],value.files.first);
                                }
                              });
                            }, icon: Icon(Icons.file_upload_outlined,size: 30,)),
                          if(_con!.user!.user_type=="0")
                            IconButton(onPressed: () {
                              _con!.deleteTrials(type,_con!.list[index].key);
                            }, icon: Icon(Icons.delete)),
                        ],
                      ),
                      Divider(
                        color: Colors.grey.shade400,
                        height: 20,
                      ),
                    ],
                  ),
                  onTap: (){
                    if(type==2){
                      _con!.downloadFile(_con!.list[index]);
                    }
                  },
                ),
              );
            },
            itemCount: _con!.list.length,
          ));
    }
  }
}
