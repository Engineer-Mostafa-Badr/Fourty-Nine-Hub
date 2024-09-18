import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/use_case/transfer_money_use_case.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/presentation/cubit/transfer_money_cubit.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/presentation/cubit/transfer_money_state.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';

class TransferMoneyView extends StatefulWidget {
  const TransferMoneyView({super.key});

  @override
  State<TransferMoneyView> createState() => _TransferMoneyViewState();
}

class _TransferMoneyViewState extends State<TransferMoneyView> {
  var paymentController = TextEditingController();

  var amountController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  BackAppBar(
        label: LocaleKeys.transferMoney.localize,
      ),
      body: BlocProvider<TransferMoneyCubit>(
        create: (BuildContext context) => serviceLocator(),
        child: BlocConsumer<TransferMoneyCubit, TransferMoneyState>(
          listener: (BuildContext context, state) {
            if (state.status == StateStatus.success) {
              showSuccessMessage(context, LocaleKeys.moneySuccessfully.localize);
            }
          },
          builder: (BuildContext context, Object? state) {
            return ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormTextField(
                          textStyle: Styles.mediumText(
                              color: Theme.of(context).scaffoldBackgroundColor),
                          constraints:
                              BoxConstraints(maxHeight: 52.h, minHeight: 52.h),
                          fillColor: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20.r),
                          style: TextStyle(
                              fontSize: 30.sp,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          controller: paymentController,
                          suffix: SizedBox(
                            width: kToolbarHeight * 1.5.w,
                            child: IconAppButton(
                              onPressed: () => context.push(Routes.Lists),
                              icon: Icons.notes_rounded,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                          hint: LocaleKeys.paymentAddress.localize,
                          action: (v) {},
                        ),
                        const Sizer(),
                        FormTextField(
                          textStyle: Styles.mediumText(
                              color: Theme.of(context).scaffoldBackgroundColor),
                          type: TextInputType.number,
                          constraints:
                              BoxConstraints(maxHeight: 52.h, minHeight: 52.h),
                          fillColor: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20.r),
                          style: TextStyle(
                              fontSize: 30.sp,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          controller: amountController,
                          hint: LocaleKeys.amount.localize,
                          action: (v) {},
                        ),
                        const Sizer(),
                        AppButton(
                            label: LocaleKeys.confirm.localize,
                            style: Styles.mediumText(
                              fontSize: 60.sp,
                              color: AppColors.AUTH_CONTAINER_COLOR,
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context
                                    .read<TransferMoneyCubit>()
                                    .transferMoney(
                                        params: TransferMoneyParams(
                                      receiverUserId:
                                          '66bcbd183aa2f0e6b120aa6b',
                                      senderUserId: UserCubit.to.state.data!.id,
                                      amount: int.parse(amountController.text),
                                    ));
                              }
                            }),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
