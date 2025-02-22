import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/presentation/widgets/add_new_pick_me_body.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class AddNewPickMeView extends StatelessWidget {
  const AddNewPickMeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Transform(
          transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
          child: Text(
            LocaleKeys.tripJoin.localize,
            style: Styles.headerText(),
          ),
        ),
      ),
      body: const AddNewPickMeBody(),
    );
  }
}
