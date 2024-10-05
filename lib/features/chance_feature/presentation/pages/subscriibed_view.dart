import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../widgets/subscribe_view_body.dart';


class SubscribedView extends StatelessWidget {
  const SubscribedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.subscribed.localize,
      ),
      body: const SubscribeViewBody(),
    );
  }
}
