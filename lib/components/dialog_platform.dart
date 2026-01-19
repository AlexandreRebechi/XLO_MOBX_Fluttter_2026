import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xlo_mobx/components/replace_flatbutton.dart';

class DialogPlatform extends StatelessWidget {
  final String? title;
  final String? content;
  final String? textNoButton;
  final String? textYesButton;
  final Function? actionNo;
  final Function? actionYes;

  const DialogPlatform({
    super.key,
    required this.title,
    required this.content,
    required this.textNoButton,
    required this.textYesButton,
    required this.actionNo,
    required this.actionYes,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(title!),
        content: Text(content!),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: actionNo != null ? () {} : null,
            child: Text(textNoButton!),
          ),
          CupertinoDialogAction(
            onPressed: actionYes != null ? () {} : null,
            child: Text(textYesButton!),
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: Text(title!),
        content: Text(content!),
        actions: <Widget>[
          ReplaceFlatButton(
            textColor: Colors.purple,
            onPressed: actionNo,
            child: Text(textNoButton!),
          ),
          ReplaceFlatButton(
            textColor: Colors.purple,
            onPressed: actionYes,
            child: Text(textYesButton!),
          ),
        ],
      );
    }
  }
}
