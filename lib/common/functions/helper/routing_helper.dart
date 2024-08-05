import 'package:flutter/material.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

extension RoutingHelper on BuildContext {
  void pushAndRemoveUntil(String location, {Object? extra}) {
    while (canPop() && (ModalRoute.of(this)!.settings.name != Routes.HOME)) {
      pop();
    }
    push(location, extra: extra);
  }
}
