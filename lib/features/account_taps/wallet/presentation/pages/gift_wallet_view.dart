import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_states.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/styles.dart';
import '../widgets/wallet_card_widget.dart';

class GiftWalletView extends StatelessWidget {
  const GiftWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(
          label: Labels.giftWallet,
        ),
        body: BlocProvider<GiftCubit>(
          create:(_)=>serviceLocator()..loadData(),
          child: BlocBuilder<GiftCubit, GiftState>(builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const WalletCardWidget(
                      balance: 300,
                      type: WalletTypes.giftWallet,
                    ),
                    const Sizer(),
                    Label(
                      text: 'Competitions',
                      style: Styles.headerText(),
                    ),
                    // ListView.builder(
                    //     shrinkWrap: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     itemCount: state.competitions?.length ?? 0,
                    //     itemBuilder: (context, index) {
                    //       final item = state.competitions![index];
                    //       return CompetitionCard(
                    //         item: item,
                    //         onTap: (context) =>
                    //             controller.showGiftsHistory(context: context),
                    //       );
                    //     })
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
