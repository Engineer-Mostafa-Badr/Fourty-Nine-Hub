import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

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
