import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension RoutingHelper on BuildContext {
  void pushAndRemoveUntil(
      // condition: A function that returns true to keep a route in the stack or false to remove it.
      // To remove all routes, use (String route) => false.
      String location,
      bool Function(String route) predicate,
      {Object? extra}) {
    while (canPop() && !(predicate(ModalRoute.of(this)!.settings.name!))) {
      pop();
    }

    pushReplacement(location, extra: extra);
  }
}
