import 'package:flutter/material.dart';

class DialogSearchSkeleton extends PageRoute {
  @override
  final bool barrierDismissible;

  @override
  final bool opaque;

  @override
  final Color barrierColor;

  DialogSearchSkeleton(
      {this.barrierColor = Colors.black54,
      this.opaque = false,
      this.barrierDismissible = true,
      required this.builder})
      : super();

  final WidgetBuilder builder;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  String? get barrierLabel => null;
}
