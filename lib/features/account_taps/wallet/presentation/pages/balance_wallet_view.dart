import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/date_time.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Balance_Cubit/balance_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Balance_Cubit/balance_states.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/wallet_card_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/styles.dart';
import '../widgets/wallet_history_card.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class BalanceWalletView extends StatefulWidget {
  const BalanceWalletView({super.key});

  @override
  State<BalanceWalletView> createState() => _BalanceWalletViewState();
}

class _BalanceWalletViewState extends State<BalanceWalletView> {
  bool showMore = false;

  late ScrollController _scrollController;
  late BalanceCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = context.read<BalanceCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
    _cubit.loadData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.fetchBalancetHistory();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        enableCustomAppBar: true,
        appBar: BackAppBar(
          label: LocaleKeys.balance.localize,
        ),
        body: BlocConsumer<BalanceCubit, BalanceState>(
          listener: (BuildContext context, BalanceState state) {
            if (state.status == BalanceStates.initial) {
              showSuccessMessage(
                  context, LocaleKeys.requestWithdrawal.localize);
            }
            if (state.status == BalanceStates.errorRequest) {
              showErrorMessage(
                context,
                getFailureMessage(
                  state.failure!,
                  context,
                ),
              );
            }
            if (state.status == BalanceStates.successTen) {
              showSuccessMessage(context, LocaleKeys.transferTenYears.localize);
            }
            if (state.status == BalanceStates.successFive) {
              showSuccessMessage(
                  context, LocaleKeys.transferFiveYears.localize);
            }
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

                    //  state.balance?.openBalance == true && state.balance!.balance >=1002
                    if (state.balance != null)
                      state.balance!.balance >= 1002
                          ? AppButton(
                              backColor: AppColors.SECONDARY_COLOR,
                              color: AppColors.AUTH_CONTAINER_COLOR,
                              label: LocaleKeys.requestWithdraw.localize,
                              onPressed: () {
      ManageVibration.vibrate();
                                context
                                    .read<BalanceCubit>()
                                    .requestWithdrawBalance();
                              },
                              margin: 10,
                            )
                          : AppButton(
                              backColor: Colors.red.withOpacity(.5),
                              label: LocaleKeys.requestWithdraw.localize,
                              onPressed: () {

      ManageVibration.vibrate();
                              },
                              margin: 10,
                            ),
                    // if (state.balance?.openBalance == true && state.withdraw?.data == false )
                    //   Label(text: LocaleKeys.checkRequest.localize,color:AppColors.SECONDARY_COLOR,),

                    // _buildWalletActionItem(
                    //     label:
                    //         '${LocaleKeys.gift.localize} / 5 ${LocaleKeys.years.localize}',
                    //     subTitle:
                    //         '${state.balance?.fiveYears ?? ''}  ${state.balance?.fiveYearsLeft ?? ''} ${LocaleKeys.yearsLast.localize}',
                    //     ontap: state.balance?.fiveYearsComplete == true
                    //         ? () {}
                    //         : state.balance?.fiveYearsTransfer == true
                    //             ? () {
                    //                 context
                    //                     .read<BalanceCubit>()
                    //                     .transferFiveBalance();
                    //               }
                    //             : () {},
                    //     color: state.balance?.fiveYearsComplete == true
                    //         ? Theme.of(context).primaryColor
                    //         : state.balance?.fiveYearsTransfer == true
                    //             ? AppColors.SECONDARY_COLOR
                    //             : AppColors.SECONDARY_COLOR.withOpacity(.5),
                    //     transfer: state.balance?.fiveYearsComplete == true
                    //         ? LocaleKeys.complete.localize
                    //         : LocaleKeys.transfer.localize,
                    //     textColor: state.balance?.fiveYearsComplete == true
                    //         ? Theme.of(context).scaffoldBackgroundColor
                    //         : AppColors.AUTH_CONTAINER_COLOR),
                    // _buildWalletActionItem(
                    //     label:
                    //         '${LocaleKeys.gift.localize} / 10 ${LocaleKeys.years.localize}',
                    //     subTitle:
                    //         '${state.balance?.tenYears ?? ''}  ${state.balance?.tenYearsLeft ?? ''} ${LocaleKeys.yearsLast.localize}',
                    //     ontap: state.balance?.tenYearsComplete == true
                    //         ? () {}
                    //         : state.balance?.tenYearsTransfer == true
                    //             ? () {
                    //                 context
                    //                     .read<BalanceCubit>()
                    //                     .transferTenBalance();
                    //               }
                    //             : () {},
                    //     color: state.balance?.tenYearsComplete == true
                    //         ? Theme.of(context).primaryColor
                    //         : state.balance?.tenYearsTransfer == true
                    //             ? AppColors.SECONDARY_COLOR
                    //             : AppColors.SECONDARY_COLOR.withOpacity(.5),
                    //     transfer: state.balance?.tenYearsComplete == true
                    //         ? LocaleKeys.complete.localize
                    //         : LocaleKeys.transfer.localize,
                    //     textColor: state.balance?.tenYearsComplete == true
                    //         ? Theme.of(context).scaffoldBackgroundColor
                    //         : AppColors.AUTH_CONTAINER_COLOR),
                    const Sizer(),
                    Label(
                      text: LocaleKeys.history.localize,
                      style: Styles.headerText(),
                    ),
                    state.status == BalanceStates.loading
                        ? const Center(child: CustomCircularProgressIndicator())
                        : SizedBox(
                            height: 400,
                            child: ListView.separated(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (index == _cubit.history.length) {
                                  return const Center(
                                      child: CustomCircularProgressIndicator());
                                }
                                final item = state.history![index];
                                return WalletHistoryCard(
                                  title: '${item.transactionAmount}',
                                  subTitle:
                                      formatDateTime(item.createdAt, context),
                                  icon: FontAwesomeIcons.check,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                color: AppColors.GREY_NORMAL_COLOR,
                              ),
                              itemCount: state.history?.length ?? 0,
                            ),
                          )
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget _buildWalletActionItem({
    required String label,
    required String subTitle,
    required Function() ontap,
    required Color color,
    Color? textColor,
    required String transfer,
  }) {
    return ListTile(
      title: Label(text: label),
      subtitle: Label(text: subTitle),
      trailing: MaterialButton(
        onPressed: () {
      ManageVibration.vibrate();
          ontap();
        },
        color: color,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Label(
            text: transfer,
            style: Styles.mediumText(color: textColor ?? Colors.white)),
      ),
    );
  }
}
