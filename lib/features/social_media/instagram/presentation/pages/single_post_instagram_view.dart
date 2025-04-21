import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/profile_instagram_data_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class SinglePostInstagramView extends StatelessWidget {
  const SinglePostInstagramView({super.key, required this.post});

  final InstagramProfilePostEntity post;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Label(
          text: LocaleKeys.post.localize,
          style: Styles.mediumText(
            fontSize: 32,
            height: 1.22,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
