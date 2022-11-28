import 'package:flutter/material.dart';

class DialogSearchStyle {
  final FieldStyle? mainFieldStyle;
  final DialogFrameStyle dialogFrameStyle;
  final DialogItemTileStyle dialogItemTileStyle;
  const DialogSearchStyle({
    this.dialogItemTileStyle = const DialogItemTileStyle(),
    this.dialogFrameStyle = const DialogFrameStyle(
      backgroundColor: Colors.white,
      hasDivider: false,
    ),
    this.mainFieldStyle,
  });
}

class DialogFrameStyle {
  final Color? backgroundColor;
  final BorderRadius radius;
  final bool hasDivider;
  final double elevation;

  const DialogFrameStyle(
      {this.elevation = 1,
      this.hasDivider = false,
      this.backgroundColor,
      this.radius = const BorderRadius.all(Radius.circular(8.0))});
}

class FieldStyle {
  final Widget? suffixWidget;
  final Widget? preffixWidget;
  final List<BoxShadow>? shadow;
  final BorderRadius? radius;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Gradient? gradient;
  final BoxBorder? border;

  const FieldStyle(
      {this.suffixWidget,
      this.preffixWidget,
      this.shadow,
      this.radius,
      this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      this.color,
      this.gradient,
      this.border});

  BoxDecoration? toBoxDecoration() {
    return BoxDecoration(
        borderRadius: radius,
        border: border,
        color: color,
        gradient: gradient,
        boxShadow: shadow);
  }
}

class DialogItemTileStyle {
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final BorderRadius radius;

  const DialogItemTileStyle(
      {this.selectedItemColor,
      this.unselectedItemColor,
      this.radius = const BorderRadius.all(Radius.circular(8.0))});
}
