import 'package:flutter/material.dart';

class ReplaceRaisedButton extends StatelessWidget {
  final Widget? child;
  final Function? onPressed;
  final Color? textColor;
  final Color? color;
  final Color? disabledColor;
  final EdgeInsetsGeometry? padding;
  final MaterialTapTargetSize? materialTapTargetSize;
  final RoundedRectangleBorder? shape;
  final double? elevation;

  const ReplaceRaisedButton({
    super.key,
    this.child,
    this.onPressed,
    this.textColor,
    this.padding,
    this.color,
    this.disabledColor,
    this.materialTapTargetSize,
    this.shape,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed != null ? () {} : null,
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(padding!),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) => states.contains(WidgetState.disabled)
              ? disabledColor!
              : textColor!,
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) =>
              states.contains(WidgetState.disabled) ? disabledColor! : color!,
        ),
        shape: WidgetStateProperty.all(shape),
        elevation: WidgetStateProperty.all<double>(elevation!),
        tapTargetSize: materialTapTargetSize,
      ),
      child: child,
    );
  }
}
