import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../common/widgets/stateful/dynamic/pagination_view.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/style/styles.dart';
import '../../../../payment/presentation/cubit/payment_cubit.dart';
import '../../../../payment/presentation/pages/payment_view.dart';
import '../../domain/entities/balance/balance_history_entity.dart';
import '../widgets/wallet_history_card.dart';

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
          child: BlocConsumer<BalanceCubit, BalanceState>(
            listener: (BuildContext context, BalanceState state) {
              if (state.status == BalanceStates.initial) {
                showSuccessMessage(
                    context, LocaleKeys.requestWithdrawal.localize);
              }
              // if (state.status == BalanceStates.successFive) {
              //   showSuccessMessage(
              //       context, 'Transfer five_years balance done to gift wallet');
              // }
              // if (state.status == BalanceStates.successTen) {
              //   showSuccessMessage(
              //       context, 'Transfer ten_years balance done to gift wallet');
              // }
            },
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
                      Padding(
                        padding: EdgeInsets.only(right: 5.w),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.grey,
                            ),
                            const Sizer(),
                            Expanded(
                              child: Label(
                                text:
                                    '${LocaleKeys.minimum.localize}1002 ${LocaleKeys.transaction.localize}',
                                style: Styles.mediumText(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      state.balance?.openBalance == true
                          ? AppButton(
                              backColor: AppColors.SECONDARY_COLOR,
                              color: AppColors.AUTH_CONTAINER_COLOR,
                              label: LocaleKeys.requestWithdraw.localize,
                              onPressed: () {
                                context
                                    .read<BalanceCubit>()
                                    .requestWithdrawBalance();
                                //Your request withdrawal sent successfully waiting for administration approval
                              },
                              margin: 10,
                            )
                          : AppButton(
                              backColor: Colors.red.withOpacity(.5),
                              label: LocaleKeys.requestWithdraw.localize,
                              onPressed: () {},
                              margin: 10,
                            ),
                      if (state.balance?.openBalance == true &&
                          state.withdraw?.data == false)
                        Label(text: LocaleKeys.checkRequest.localize),
                      if (state.withdraw?.data == true)
                        AppButton(
                          backColor: AppColors.SECONDARY_COLOR,
                          color: AppColors.AUTH_CONTAINER_COLOR,
                          label: LocaleKeys.withdraw.localize,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BlocProvider<PaymentCubit>(
                                    create: (BuildContext context) =>
                                        serviceLocator(),
                                    child: PaymentView(
                                      amountId: '',
                                      amount: state.balance?.balance ?? 0,
                                    ),
                                  ),
                                ));
                          },
                          margin: 10,
                        )
                      else
                        AppButton(
                          backColor: Colors.red.withOpacity(.5),
                          label: LocaleKeys.withdraw.localize,
                          onPressed: () {},
                          margin: 10,
                        ),
                      // if(state.withdraw?.data ==true)
                      //   const Label(text: 'Please wait to check request'),

                      _buildWalletActionItem(
                          label:
                              '${LocaleKeys.gift.localize} / 5 ${LocaleKeys.years.localize}',
                          subTitle:
                              '${state.balance?.fiveYears ?? ''} . ${state.balance?.fiveYearsLeft ?? ''} ${LocaleKeys.yearsLast.localize}',
                          ontap: state.balance?.fiveYearsComplete == true
                              ? () {}
                              : state.balance?.fiveYearsTransfer == true
                                  ? () {
                                      context
                                          .read<BalanceCubit>()
                                          .transferFiveBalance();
                                    }
                                  : () {},
                          color: state.balance?.fiveYearsComplete == true
                              ? Theme.of(context).primaryColor
                              : state.balance?.fiveYearsTransfer == true
                                  ? AppColors.SECONDARY_COLOR
                                  : AppColors.SECONDARY_COLOR.withOpacity(.5),
                          transfer: state.balance?.fiveYearsComplete == true
                              ? LocaleKeys.complete.localize
                              : LocaleKeys.transfer.localize,
                          textColor: Theme.of(context).scaffoldBackgroundColor),
                      _buildWalletActionItem(
                          label:
                              '${LocaleKeys.gift.localize} / 10 ${LocaleKeys.years.localize}',
                          subTitle:
                              '${state.balance?.tenYears ?? ''} . ${state.balance?.tenYearsLeft ?? ''} ${LocaleKeys.yearsLast.localize}',
                          ontap: state.balance?.tenYearsTransfer == true
                              ? () {}
                              : state.balance?.tenYearsTransfer == true
                                  ? () {
                                      context
                                          .read<BalanceCubit>()
                                          .transferFiveBalance();
                                    }
                                  : () {},
                          color: state.balance?.tenYearsComplete == true
                              ? Theme.of(context).primaryColor
                              : state.balance?.tenYearsTransfer == true
                                  ? AppColors.SECONDARY_COLOR
                                  : AppColors.SECONDARY_COLOR.withOpacity(.5),
                          transfer: state.balance?.tenYearsComplete == true
                              ? LocaleKeys.complete.localize
                              : LocaleKeys.transfer.localize,
                          textColor: state.balance?.tenYearsComplete == true
                              ? Theme.of(context).scaffoldBackgroundColor
                              : AppColors.AUTH_CONTAINER_COLOR),
                      const Sizer(),
                      Label(
                        text: LocaleKeys.history.localize,
                        style: Styles.headerText(),
                      ),
                      PaginationView<BalanceHistoryEntity>(
                        loadingWidget: const SizedBox.shrink(),
                        build: (ScrollController scrollController,
                            List<BalanceHistoryEntity> data) {
                          return data.isNotEmpty
                              ? ListView.separated(
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    //  final item = state.history![index];
                                    final DateTime createdAt =
                                        DateTime.parse(data[index].createdAt);
                                    final DateTime egyptTime = createdAt
                                        .toUtc()
                                        .add(const Duration(hours: 3));
                                    final String formattedDateTime =
                                        DateFormat('dd/MM/yyyy, h:mm a')
                                            .format(egyptTime);

                                    return WalletHistoryCard(
                                        title:
                                            '${data[index].transactionAmount}',
                                        subTitle: formattedDateTime,
                                        onTap: () {},
                                        //amount: item.amount,
                                        icon: FontAwesomeIcons.check);
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox();
                                  },
                                  itemCount: data.length)
                              : Center(
                                  child: Label(
                                      text: LocaleKeys
                                          .noHistoryAvailable.localize));
                        },
                        fetchData: (PaginationParams paginationParams) {
                          return context
                              .read<BalanceCubit>()
                              .fetchBalanceHistory(
                                  paginationParams: paginationParams);
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  Widget _buildWalletActionItem({
    required String label,
    required String subTitle,
    required Function ontap,
    required Color color,
    Color? textColor,
    required String transfer,
  }) {
    return ListTile(
      title: Label(text: label),
      subtitle: Label(text: subTitle),
      trailing: GestureDetector(
        onTap: () {
          ontap();
        },
        child: MaterialButton(
          onPressed: () {},
          color: color,
          //disabledColor: const Color.fromARGB(159, 255, 82, 82),
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Label(
              text: transfer,
              style: Styles.mediumText(color: textColor ?? Colors.white)),
        ),
      ),
    );
  }
}
