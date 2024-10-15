import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/add_new_route_body.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AddNewRouteView extends StatelessWidget {
  const AddNewRouteView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Transform(
            transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: Text(
              LocaleKeys.newRoute.localize,
              style: Styles.headerText(),
            ),
          ),
        ),
        body: const AddNewRouteBody(),
      ),
    );
  }
}
