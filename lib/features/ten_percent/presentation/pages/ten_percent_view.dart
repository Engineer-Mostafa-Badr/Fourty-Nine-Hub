import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ten_percent/presentation/pages/widget/ten_percent_view_body.dart';

import '../../../../core/widget/custom_scaffold.dart';

class TenPercentView extends StatelessWidget {
  const TenPercentView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: BackAppBar(label: LocaleKeys.billCashback.localize),
      body: const TenPercentViewBody(),
    );
  }
}
