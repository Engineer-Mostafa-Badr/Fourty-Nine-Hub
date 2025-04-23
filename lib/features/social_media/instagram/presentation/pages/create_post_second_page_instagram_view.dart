import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/create_post_second_page_instagram_view_body.dart';

class CreatePostSecondPageInstagramView extends StatelessWidget {
  const CreatePostSecondPageInstagramView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: BackAppBar(
        label: LocaleKeys.newPost.localize,
      ),
      body: const CreatePostSecondPageInstagramViewBody(),
    );
  }
}
