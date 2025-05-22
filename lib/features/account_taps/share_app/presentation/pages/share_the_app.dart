import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/share_app/presentation/widgets/share_the_app_view_body.dart';
import '../../../../../core/widget/custom_scaffold.dart';

class ShareTheApp extends StatelessWidget {
  const ShareTheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.shareApp.localize,
          enableCustomAppBar: false, // true,
        ),
      ),
      enableCustomAppBar: false, // true,
      body: ShareTheAppViewBody(),
      // body: BlocProvider<ShareAppCubit>(
      //   create: (BuildContext context) => serviceLocator()..shareApp(),
      //   child: ShareTheAppViewBody(),
      // ),
    );
  }
}
