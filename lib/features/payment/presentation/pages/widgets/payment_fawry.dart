import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import '../../../../../common/widgets/stateless/dynamic/are_you_sure.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../domain/use_cases/cache_out/pay_out_request_use_case.dart';
import '../../cache_out_cubit/payment_cubit.dart';

class PaymentFawryCard extends StatefulWidget {
  const PaymentFawryCard({super.key});

  @override
  _PaymentFawryCardState createState() => _PaymentFawryCardState();
}

class _PaymentFawryCardState extends State<PaymentFawryCard> {
  bool hasDigitalWallet = true;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneNumberController.dispose();
    nationalIdController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          serviceLocator<PaymentCacheOutCubit>()..getWallet(),
      child: BlocConsumer<PaymentCacheOutCubit, PaymentCacheOutState>(
        listener: (BuildContext context, PaymentCacheOutState state) {
          if (state.status == StateStatus.success) {
            if (hasDigitalWallet) {
              showSuccessMessage(context, LocaleKeys.walletDigital.localize);
            } else {
              showSuccessMessage(context, LocaleKeys.notWalletDigital.localize);
            }
          }
          if (state.status == StateStatus.error) {
            showErrorMessage(
              context,
              getFailureMessage(state.failure!, context),
            );
          }
        },
        builder: (BuildContext context, state) {
          //final controller = context.read<PaymentCacheOutCubit>();
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: Label(
                      maxLines: 2,
                      text: LocaleKeys.HaveWallet.localize,
                      style: Styles.mediumText(),
                    ),
                    value: hasDigitalWallet,
                    activeTrackColor: AppColors.SECONDARY_COLOR,
                    activeColor: AppColors.AUTH_CONTAINER_COLOR,
                    inactiveTrackColor: AppColors.GREY_NORMAL_COLOR,
                    onChanged: (value) {
                      setState(() {
                        hasDigitalWallet = value;
                      });
                    },
                  ),
                  if (hasDigitalWallet) ...[
                    buildInputField(
                      controller: amountController,
                      labelText: LocaleKeys.amount.localize,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.pleaseEnterTheAmount.localize;
                        }
                        return null;
                      },
                    ),
                    const Sizer(),
                    buildInputField(
                      controller: phoneNumberController,
                      labelText: LocaleKeys.phoneNumber.localize,
                      validator: _validatePhoneNumber,
                    ),
                  ],
                  if (!hasDigitalWallet) ...[
                    buildInputField(
                      controller: phoneNumberController,
                      labelText: LocaleKeys.phoneNumber.localize,
                      validator: _validatePhoneNumber,
                    ),
                    const Sizer(),
                    buildInputField(
                      controller: nationalIdController,
                      labelText: LocaleKeys.nationalIdNumber.localize,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.pleaseEnterNationalId.localize;
                        }
                        if (!RegExp(r'^[0-9]{14}$').hasMatch(value)) {
                          return LocaleKeys.pleaseEnter14Digit.localize;
                        }
                        return null;
                      },
                    ),
                    const Sizer(),
                    buildInputField(
                      controller: amountController,
                      labelText: LocaleKeys.amount.localize,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.pleaseEnterTheAmount.localize;
                        }
                        return null;
                      },
                    ),
                  ],
                  const Sizer(height: 30),
                  InkWell(
                    //  onTap: (){},
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        if (hasDigitalWallet) {
                          // Call for digital wallet submission
                          showAreYouSure(
                              title: LocaleKeys.alert.localize,
                              subTitle: LocaleKeys.sureWithdrawMoney.localize,
                              action: () {
                                context
                                    .read<PaymentCacheOutCubit>()
                                    .payOutRequest(
                                        params: PayoutRequestParams(
                                      amount:
                                          double.parse(amountController.text),
                                      payoutMethod: 'fawry_wallet',
                                      phoneNumber: phoneNumberController.text,
                                      payoutSource: 'main_wallet',
                                    ));
                              },
                              context: context);
                        } else {
                          showAreYouSure(
                              title: LocaleKeys.alert.localize,
                              subTitle: LocaleKeys.sureWithdrawMoney.localize,
                              action: () {
                                context
                                    .read<PaymentCacheOutCubit>()
                                    .payOutRequest(
                                        params: PayoutRequestParams(
                                            amount: double.parse(
                                                amountController.text),
                                            payoutMethod: 'id_card',
                                            phoneNumber:
                                                phoneNumberController.text,
                                            payoutSource: 'main_wallet',
                                            idNumber:
                                                nationalIdController.text));
                              },
                              context: context);
                        }
                      }
                    },
                    child: Container(
                      alignment: AlignmentDirectional.center,
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 100.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Label(
                        text: LocaleKeys.submitPayment.localize,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        fillColor: Colors.transparent,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys
          .pleaseEnterYourPhoneNumber.localize; // Please enter a phone number
    }
    // Regex for Egyptian phone number
    final RegExp phoneRegExp = RegExp(r'^(01)[0-9]{9}$');
    if (!phoneRegExp.hasMatch(value)) {
      return LocaleKeys.invalidPhoneNumber.localize; // Invalid phone number
    }
    return null;
  }
}
