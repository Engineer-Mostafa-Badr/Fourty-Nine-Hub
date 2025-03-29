import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/winners_gift_cubit/winners_gift_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/winners_gift_view_body.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class WinnersGiftView extends StatelessWidget {
  const WinnersGiftView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: BackAppBar(
        label: LocaleKeys.winners.localize,
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: Image.asset(Assets.cupImage),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            serviceLocator<WinnersGiftCubit>()..getWinners(context),
        child: const WinnersGiftViewBody(),
      ),
    );
  }
}
