import 'package:flutter/material.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/widgets/sub_txt_widget.dart';

import '../generated/l10n.dart';
import 'header_txt_widget.dart';
class InputPasswordWidget extends StatefulWidget {
  String title;
  var controller;

  @override
  _PageState createState() => _PageState();

  InputPasswordWidget(this.title, {this.controller});
}
class _PageState extends State<InputPasswordWidget> {
bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: TextFormField(
            controller: widget.controller!=null?widget.controller:TextEditingController(),
            obscureText: _obscureText,
            style: TextStyle(
              fontFamily:'Schyler',
            ),
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              border: InputBorder.none,
              filled: true,
              hoverColor: Colors.transparent,
              hintText: widget.title,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
            border: Border.all(color: ThemeColor.colorPrimary)
          ),
        )
      ],
    );
  }
}