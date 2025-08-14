import 'package:flutter/material.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../widgets/create_post_second_page_instagram_view_body.dart';

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
