import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/add_new_route_body.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/routes/routes.dart';

class AddNewRouteView extends StatelessWidget {
  const AddNewRouteView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pushReplacement(Routes.AVAILABLE_TRIPS);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.pushReplacement(Routes.AVAILABLE_TRIPS);
              },
            ),
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
      ),
    );
  }
}
