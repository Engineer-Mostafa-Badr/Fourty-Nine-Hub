import 'package:flutter/material.dart';
showAnimatedDialog(BuildContext context, Widget alertDialog,
    {bool? barrierDismissible, String? barrierLabel}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? true,
    barrierLabel: barrierLabel ??
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, _, __) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: alertDialog,
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInExpo),
        ),
        child: child,
      );
    },
  );
  /*showGeneralDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? true,
    barrierLabel: barrierLabel ??
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, _, __) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: alertDialog,
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: Tween<double>(begin: .85, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        ),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );*/
}
