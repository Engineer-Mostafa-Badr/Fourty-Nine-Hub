import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
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
                  TextFormField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
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
                  if (!hasDigitalWallet) ...[
                    TextFormField(
                      controller: nationalIdController,
                      decoration: InputDecoration(
                        labelText: "National ID",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your national ID";
                        }
                        return null;
                      },
                    ),
                    const Sizer(),
                    TextFormField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: "Amount",
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
                    onTap: (){},
                    // onTap: () {
                    //   if (formKey.currentState!.validate()) {
                    //     if (hasDigitalWallet) {
                    //       // Call for digital wallet submission
                    //       controller.requestFawryCard(
                    //         params: RequestFawryCardParams(
                    //           phoneNumber: phoneNumberController.text,
                    //           nationalIdBack: null, // Not needed for digital wallet case
                    //           nationalIdFront: null, // Not needed for digital wallet case
                    //           amount: null, // Not needed for digital wallet case
                    //         ),
                    //       );
                    //     } else {
                    //       // Call for non-digital wallet submission
                    //       controller.requestFawryCard(
                    //         params: RequestFawryCardParams(
                    //           phoneNumber: phoneNumberController.text,
                    //           nationalIdBack: nationalIdController.text, // Using national ID
                    //           nationalIdFront: nationalIdController.text, // Both back and front in this case
                    //           amount: amountController.text, // Submit amount for non-digital wallet
                    //         ),
                    //       );
                    //     }
                    //   }
                    // },
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
