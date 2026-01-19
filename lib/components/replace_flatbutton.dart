import 'package:flutter/material.dart';

class ReplaceFlatButton extends StatelessWidget {
  final Widget? child;
  final Function? onPressed;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  ReplaceFlatButton({this.child, this.onPressed, this.textColor, this.padding});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed != null ? () {} : null,
        style: TextButton.styleFrom(
            backgroundColor: textColor ?? Theme
                .of(context)
                .primaryColor,
            padding: padding),
        child: child!
    );
  }
}