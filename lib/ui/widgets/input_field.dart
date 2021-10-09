// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:getx_project/ui/size_config.dart';

import '../theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hintText,
      this.controller,
      this.widget,
      this.isReadOnly=false})
      : super(key: key);
  final bool isReadOnly;
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            padding: EdgeInsets.only(left: 14),
            margin: EdgeInsets.only(top: 10),
            width: SizeConfig.screenWidth,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                      readOnly: isReadOnly,
                  style: subTitleStyle,
                  controller: controller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      // errorBorder: UnderlineInputBorder(
                      //     borderSide: BorderSide(color: context.theme.backgroundColor, width: 0)),
                      // focusedBorder: UnderlineInputBorder(
                      //     borderSide: BorderSide(color: context.theme.backgroundColor, width: 0)),
                      hintText: hintText,
                      helperStyle: subTitleStyle),
                )),
                widget ?? Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
