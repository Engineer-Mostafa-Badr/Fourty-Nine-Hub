import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_states.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/styles.dart';
import '../widgets/competition_card.dart';
import '../widgets/wallet_card_widget.dart';

class GiftWalletView extends StatelessWidget {
  const GiftWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  BackAppBar(
          label: LocaleKeys.gift.localize,
        ),
        body: BlocProvider<GiftCubit>(
          create:(_)=>serviceLocator(),
          child: BlocBuilder<GiftCubit, GiftState>(builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     WalletCardWidget(
                      balance: '${state.gift?.giftWallet.amount ??''}',
                      type: WalletTypes.giftWallet,
                    ),
                    Sizer(),
                    Label(
                      text: LocaleKeys.competition.localize,
                      style: Styles.headerText(),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.gift?.competitionsWallet.length ?? 0,
                        itemBuilder: (context, index) {
                          return CompetitionCard(
                            competitionsWalletEntity: state.gift!.competitionsWallet[index],
                            onTap: (context){},
                            // onTap: (context) =>
                            //     controller.showGiftsHistory(context: context),
                          );
                        })
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
