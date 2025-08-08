import 'package:flutter/material.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../../helpers/manage_vibration.dart';

class FollowRequestsInstagramView extends StatelessWidget {
  const FollowRequestsInstagramView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Label(
          text: LocaleKeys.followRequests.localize,
          style: Styles.headerText(fontSize: 40),
        ),
        leading: IconButton(
          onPressed: () {
      ManageVibration.vibrate();
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          Label(
            text: LocaleKeys.manage.localize,
            style: Styles.headerText(fontSize: 32),
          ),
        ],
      ),
      body: const FollowRequestsInstagramViewBody(),
    );
  }
}

class FollowRequestsInstagramViewBody extends StatelessWidget {
  const FollowRequestsInstagramViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column();
  }
}