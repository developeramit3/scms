import 'package:flutter/material.dart';
import 'package:scms/services/dropdown_model.dart';
import 'package:scms/widgets/sub_txt_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../Utils/theme_color.dart';
import '../generated/l10n.dart';
typedef callback=Function();
class DropdownWidget extends StatelessWidget {
  String txt;
  DropdownModel? selected;
  List<DropdownModel>list;
  var onChanged;
  DropdownWidget(this.txt,{required this.list,this.selected,this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTxtWidget(txt,color: Colors.white,),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 8),
          height: 50,
          alignment: AlignmentDirectional.centerStart,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              border: Border.all(color: ThemeColor.colorPrimary)
          ),
          child:list.isEmpty?_loading():DropdownButtonHideUnderline(
            child: DropdownButton(
                isExpanded: true,
                value: selected??list.first,
                items: list.map((e){
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.title),
                  );
                }).toList(), onChanged: onChanged,),
          ),
        )
      ],
    );
  }
  Widget _loading(){
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade500,
      enabled: true,
      child: Container(
        height: 20,
        color: Colors.grey,
        margin: const EdgeInsets.only(bottom: 5, top: 5),
      ),
    );
  }
}