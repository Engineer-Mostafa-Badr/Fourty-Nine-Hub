import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/gift_two_cubit/gift_two_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/gift_view_body.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class GiftView extends StatelessWidget {
  const GiftView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: BackAppBar(
        label: LocaleKeys.gift.localize,
      ),
      body: BlocProvider(
        create: (context) =>
            serviceLocator<GiftTwoCubit>()..fetchWheelWallet(context),
        child: const GiftViewBody(),
      ),
    );
  }
}
