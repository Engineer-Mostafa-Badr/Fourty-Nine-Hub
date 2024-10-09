import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import '../../../../../common/widgets/stateless/dynamic/are_you_sure.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/base_status_enum.dart';
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
      create: (BuildContext context) => serviceLocator<PaymentCacheOutCubit>()..getWallet(),
      child: BlocConsumer<PaymentCacheOutCubit, PaymentCacheOutState>(
        listener: (BuildContext context, PaymentCacheOutState state) {
          if (state.status == StateStatus.success) {
            if (hasDigitalWallet) {
              showSuccessMessage(context, "You have successfully submitted your payment. Check your inbox, you will receive your money shortly.");
            } else {
              showSuccessMessage(context, "You have successfully submitted your payment. Check your inbox, you will receive a voucher including your money shortly.");
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
                    title: Label(maxLines: 2,text: "Do you have a wallet?",
                    style: Styles.mediumText(),
                    ),
                    value: hasDigitalWallet,
                    activeTrackColor: AppColors.SECONDARY_COLOR,
                    inactiveTrackColor: AppColors.GREY_NORMAL_COLOR,
                    onChanged: (value) {
                      setState(() {
                        hasDigitalWallet = value;
                      });
                    },
                  ),
                  if (hasDigitalWallet) ...[
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your phone number";
                        }
                        return null;
                      },
                    ),
                    const Sizer(),
                    TextFormField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.amount.localize,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the amount";
                        }
                        return null;
                      },
                    ),
                  ],
                  if (!hasDigitalWallet) ...[
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your phone number";
                        }
                        return null;
                      },
                    ),
                    const Sizer(),
                    TextFormField(
                      controller: nationalIdController,
                      decoration: const InputDecoration(
                        labelText: "National ID",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your national ID";
                        }
                        if (value.length != 14) {
                          return "National ID must be 14 digits";
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return "National ID must contain only numbers";
                        }
                        return null;
                      },
                    ),
                    const Sizer(),
                    TextFormField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.amount.localize,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the amount";
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
                              subTitle:
                              'Are you sure of transferring money?',
                              action: () {
                                context
                                    .read<PaymentCacheOutCubit>()
                                    .payOutRequest(
                                    params: PayoutRequestParams(
                                      amount:double.parse(amountController.text),
                                      payoutMethod: 'fawry_wallet',
                                      phoneNumber: phoneNumberController.text,
                                      payoutSource: 'main_wallet',
                                    ));
                              },
                              context: context);
                        } else {
                          showAreYouSure(
                              title: LocaleKeys.alert.localize,
                              subTitle:
                              'Are you sure of transferring money?',
                              action: () {
                                context
                                    .read<PaymentCacheOutCubit>()
                                    .payOutRequest(
                                    params: PayoutRequestParams(
                                      amount:double.parse(amountController.text),
                                      payoutMethod: 'id_card',
                                      phoneNumber: phoneNumberController.text,
                                      payoutSource: 'main_wallet',
                                      idNumber: nationalIdController.text
                                    ));
                              },
                              context: context);
                        }
                      }
                    },
                    child: Container(
                      alignment: AlignmentDirectional.center,
                      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 100.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Label(
                        text: "Submit Payment",
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
}
