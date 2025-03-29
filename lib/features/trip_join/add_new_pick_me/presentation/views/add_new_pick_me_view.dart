import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/presentation/widgets/add_new_pick_me_body.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../../../../../core/widget/custom_scaffold.dart';

class AddNewPickMeView extends StatelessWidget {
  const AddNewPickMeView({super.key});

  @override
  Widget build(BuildContext context) {
    return
     SharedScaffold(
      body: const AddNewPickMeBody(),
      mainCategoryId: 1,
    );
  }
}
