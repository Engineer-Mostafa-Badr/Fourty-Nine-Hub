import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Balance_Cubit/balance_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Balance_Cubit/balance_states.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/wallet_card_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';

class BalanceWalletView extends StatelessWidget {
  const BalanceWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackAppBar(
          label: LocaleKeys.balance.localize,
        ),
        body: BlocProvider<BalanceCubit>(
          create: (_) => serviceLocator()..loadData(),
          child: BlocBuilder<BalanceCubit, BalanceState>(
              builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WalletCardWidget(
                      balance: '${state.balance?.balance ?? ''}',
                      target: 1002,
                      type: WalletTypes.balance,
                    ),
                    const Sizer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                        ),
                        const Sizer(),
                        Expanded(
                          child: Row(
                            children: [
                              Label(
                                text: LocaleKeys.minimum.localize,
                                style: Styles.mediumText(color: Colors.grey),
                              ),
                              Label(
                                text: '500 ',
                                style: Styles.mediumText(color: Colors.grey),
                              ),
                              Label(
                                text: LocaleKeys.transaction.localize,
                                style: Styles.mediumText(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    state.balance?.openBalance == true
                        ? AppButton(
                            backColor: AppColors.SECONDARY_COLOR,
                            color: AppColors.AUTH_CONTAINER_COLOR,
                            label: LocaleKeys.requestWithdraw.localize,
                            onPressed: () => context.push(Routes.PAYMENT),
                            margin: 10,
                          )
                        : AppButton(
                            backColor: Colors.red.withOpacity(.5),
                            label: LocaleKeys.requestWithdraw.localize,
                            onPressed: () {},
                            margin: 10,
                          ),
                    _buildWalletActionItem(
                        label:
                            '${LocaleKeys.gift.localize} / 5 ${LocaleKeys.years.localize}',
                        subTitle:
                            '${state.balance?.fiveYears ?? ''} . 3 years last',
                        ontap: () {}),
                    _buildWalletActionItem(
                        label:
                            '${LocaleKeys.gift.localize} / 10 ${LocaleKeys.years.localize}',
                        subTitle:
                            '${state.balance?.tenYears ?? ''} . 8 years last',
                        ontap: () {}),
                    const Sizer(),
                    Label(
                      text: LocaleKeys.history.localize,
                      style: Styles.headerText(),
                    ),
                    // ListView.separated(
                    //     shrinkWrap: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     itemBuilder: (context, index) {
                    //       final item = state.balanceHistory![index];
                    //       return WalletHistoryCard(
                    //           title: '${item.amount} ${Labels.currency}',
                    //           subTitle: item.description,
                    //           onTap: () {},
                    //           amount: item.amount,
                    //           icon: FontAwesomeIcons.check);
                    //     },
                    //     separatorBuilder: (context, index) {
                    //       return const SizedBox();
                    //     },
                    //     itemCount: state.balanceHistory?.length ?? 0)
                  ],
                ),
              ),
            );
          }),
        ));
  }

  Widget _buildWalletActionItem({
    required String label,
    required String subTitle,
    required Function ontap,
  }) {
    return ListTile(
      title: Label(text: label),
      subtitle: Label(text: subTitle),
      trailing: MaterialButton(
        onPressed: null,
        color: Colors.red,
        disabledColor: const Color.fromARGB(159, 255, 82, 82),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Label(
            text: 'Transfer', style: Styles.mediumText(color: Colors.white)),
      ),
    );
  }
}
