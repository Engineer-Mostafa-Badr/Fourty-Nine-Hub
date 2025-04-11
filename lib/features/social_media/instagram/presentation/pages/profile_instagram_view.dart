import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/profile_instagram_view_body.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ProfileInstagramView extends StatelessWidget {
  const ProfileInstagramView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Label(
          text: 'Ahmed mohamed',
          style: Styles.headerText(
            fontSize: 40,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: const ProfileInstagramViewBody(),
    );
  }
}
