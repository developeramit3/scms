import 'package:flutter/material.dart';

import '../Utils/theme_color.dart';
import 'header_txt_widget.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({required this.iconData, this.text,this.count=0});
  String iconData;
  int count;
  String? text;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    required this.items,
    this.centerItemText,
    this.height: 60.0,
    this.iconSize: 23.0,
    required this.backgroundColor,
    required this.color,
    required this.selectedColor,
    required this.notchedShape,
    required this.onTabSelected,
    required this.selectedIndex,
  }) {
    // assert(this.items.length == 2 || this.items.length == 4);
  }
  final List<FABBottomAppBarItem> items;
  final String? centerItemText;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;
  int selectedIndex;
  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {


  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      widget.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    // items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      shape: widget.notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.iconSize),
            Text(
              widget.centerItemText ?? '',
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    FABBottomAppBarItem? item,
    int? index,
    ValueChanged<int>? onPressed,
  }) {
    Color color = widget.selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed!(index!),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 35,
                  height: 35,
                  child: Stack(
                    children: [
                      Align(
                        child: Image.asset('assets/svg/${item!.iconData}',width: widget.selectedIndex == index?30:widget.iconSize,color: index==2?null:color,),
                        alignment: AlignmentDirectional.centerStart,
                      ),
                      if(item.count>0)
                      Positioned(child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: HeaderTxtWidget('${item.count}',fontSize: 10,textAlign: TextAlign.center,color: Colors.white,),
                      ),right: 1,top: 1,)
                    ],
                  ),
                ),
                if(item.text!=null)
                  Text(
                    item.text!,
                    style: TextStyle(color: color),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}