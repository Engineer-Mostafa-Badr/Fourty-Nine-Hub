import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_button_wallet_and_gift_and_cashback.dart';
import 'package:fourtyninehub/features/ten_percent/presentation/cubit/ten_percent_cubit.dart';
import 'package:fourtyninehub/features/ten_percent/presentation/pages/widget/bill_value_field.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../res/assets/assets.dart';
import '../../../../account_taps/wallet/presentation/widgets/button_wallet_and_bill.dart';

class TenPercentViewBody extends StatelessWidget {
  const TenPercentViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TenPercentCubit, TenPercentState>(
        builder: (context, state) {
      var cubit = context.read<TenPercentCubit>();
      return Form(
        key: cubit.formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Label(
                      text: LocaleKeys.cashBack.localize,
                      style: Styles.headerText(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: context.isDarkMode
                              ? Color(0x99FFFFFF)
                              : const Color(0x993C3C43)),
                      maxLines: 3,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Label(
                      text: LocaleKeys.trafficViolation.localize,
                      style: Styles.headerText(
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ButtonWalletAndBill(
                      icon: state.trafficFile != null &&
                              state.trafficFile!.isNotEmpty
                          ? Icon(
                              Icons.check_circle_outline_rounded,
                              color: context.isDarkMode
                                  ? Colors.black
                                  : Colors.grey,
                            )
                          : SvgPicture.asset(
                              Assets.uploadIcon,
                            ),
                      label: LocaleKeys.uploadBill.localize,
                      onPressed: () async {
                        await context
                            .read<TenPercentCubit>()
                            .uploadTrafficBill(context: context);
                      },
                    ),
                    // InkWell(
                    //   onTap: () async {
                    //     await context
                    //         .read<TenPercentCubit>()
                    //         .uploadTrafficBill(context: context);
                    //   },
                    //   child: BlocBuilder<TenPercentCubit, TenPercentState>(
                    //     builder: (context, state) {
                    //       if (state.trafficFile != null &&
                    //           state.trafficFile!.isNotEmpty) {
                    //         return SizedBox(
                    //           width: double.infinity,
                    //           height: 300.h,
                    //           child: ImagePickerPlaceholder(
                    //             width: double.infinity,
                    //             height: 300.h,
                    //             image: Image.file(
                    //               File(state.trafficFile ?? ''),
                    //               fit: BoxFit.contain,
                    //             ),
                    //           ),
                    //         );
                    //       }
                    //       return SizedBox(
                    //         width: double.infinity,
                    //         height: 300.h,
                    //         child: ImagePickerPlaceholder(
                    //           title: LocaleKeys.selectBill.localize,
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    const SizedBox(
                      height: 16,
                    ),
                    BillValueTextFormField(
                      currentController: cubit.trafficController,
                      validator: (p0) {
                        if (p0!.isEmpty &&
                            (state.trafficId != null &&
                                state.trafficId!.isNotEmpty)) {
                          return LocaleKeys.enterBillValue.localize;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Label(
                      text: LocaleKeys.electricityBill.localize,
                      style: Styles.headerText(
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ButtonWalletAndBill(
                      icon: state.electricityFile != null &&
                              state.electricityFile!.isNotEmpty
                          ? const Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.grey,
                            )
                          : SvgPicture.asset(
                              Assets.uploadIcon,
                            ),
                      label: LocaleKeys.uploadBill.localize,
                      onPressed: () async {
                        await context
                            .read<TenPercentCubit>()
                            .uploadElectricityBill(context: context);
                      },
                    ),
                    // InkWell(
                    //   onTap: () async {
                    //     await context
                    //         .read<TenPercentCubit>()
                    //         .uploadElectricityBill(context: context);
                    //   },
                    //   child: BlocBuilder<TenPercentCubit, TenPercentState>(
                    //     builder: (context, state) {
                    //       if (state.electricityFile != null &&
                    //           state.electricityFile!.isNotEmpty) {
                    //         return SizedBox(
                    //           width: double.infinity,
                    //           height: 300.h,
                    //           child: ImagePickerPlaceholder(
                    //             width: double.infinity,
                    //             height: 300.h,
                    //             image: Image.file(
                    //               File(state.electricityFile ?? ''),
                    //               fit: BoxFit.contain,
                    //             ),
                    //           ),
                    //         );
                    //       }
                    //       return SizedBox(
                    //         width: double.infinity,
                    //         height: 300.h,
                    //         child: ImagePickerPlaceholder(
                    //           title: LocaleKeys.selectBill.localize,
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    const SizedBox(
                      height: 16,
                    ),
                    BillValueTextFormField(
                      currentController: cubit.electricityController,
                      validator: (p0) {
                        if (p0!.isEmpty &&
                            (state.electricityId != null &&
                                state.electricityId!.isNotEmpty)) {
                          return LocaleKeys.enterBillValue.localize;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Label(
                      text: LocaleKeys.mobileBill.localize,
                      style: Styles.headerText(
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ButtonWalletAndBill(
                      icon: state.mobileFile != null &&
                              state.mobileFile!.isNotEmpty
                          ? const Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.grey,
                            )
                          : SvgPicture.asset(
                              Assets.uploadIcon,
                            ),
                      label: LocaleKeys.uploadBill.localize,
                      onPressed: () async {
                        await context
                            .read<TenPercentCubit>()
                            .uploadMobileBill(context: context);
                      },
                    ),
                    // InkWell(
                    //   onTap: () async {
                    //     await context
                    //         .read<TenPercentCubit>()
                    //         .uploadMobileBill(context: context);
                    //   },
                    //   child: BlocBuilder<TenPercentCubit, TenPercentState>(
                    //     builder: (context, state) {
                    //       if (state.mobileFile != null &&
                    //           state.mobileFile!.isNotEmpty) {
                    //         return SizedBox(
                    //           width: double.infinity,
                    //           height: 300.h,
                    //           child: ImagePickerPlaceholder(
                    //             width: double.infinity,
                    //             height: 300.h,
                    //             image: Image.file(
                    //               File(state.mobileFile ?? ''),
                    //               fit: BoxFit.contain,
                    //             ),
                    //           ),
                    //         );
                    //       }
                    //       return SizedBox(
                    //         width: double.infinity,
                    //         height: 300.h,
                    //         child: ImagePickerPlaceholder(
                    //           title: LocaleKeys.selectBill.localize,
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    const SizedBox(
                      height: 16,
                    ),
                    BillValueTextFormField(
                      currentController: cubit.mobileController,
                      validator: (p0) {
                        if (p0!.isEmpty &&
                            (state.mobileId != null &&
                                state.mobileId!.isNotEmpty)) {
                          return LocaleKeys.enterBillValue.localize;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButtonWalletAndGiftAndCashback(
                      title: LocaleKeys.sendRequest.localize,
                      onPressed: () {
                        // if (state.mobileId == null &&
                        //     state.electricityId == null &&
                        //     state.trafficId == null) {
                        //   showErrorMessage(context,
                        //       LocaleKeys.uploadAtLeastOneBill.localize);
                        //   return;
                        // }
                        // if (state.mobileId != null || cubit.mobileController.text.isNotEmpty) {
                        //   if (cubit.mobileController.text.isEmpty) {
                        //     showErrorMessage(context,
                        //         LocaleKeys.uploadAtLeastOneBill.localize);
                        //     return;
                        //   }
                        // }
                        // if (state.electricityId != null) {
                        //   if (cubit.electricityController.text.isEmpty) {
                        //     showErrorMessage(context,
                        //         LocaleKeys.uploadAtLeastOneBill.localize);
                        //     return;
                        //   }
                        // }
                        // if (state.trafficId != null) {
                        //   if (cubit.trafficController.text.isEmpty) {
                        //     showErrorMessage(context,
                        //         LocaleKeys.uploadAtLeastOneBill.localize);
                        //     return;
                        //   }
                        // }
                        // cubit.fetchAdRequests(context);
                        if (cubit.formKey.currentState!.validate()) {
                          if ((state.mobileId == null ||
                                  state.mobileId == '') &&
                              (state.electricityId == null ||
                                  state.electricityId == '') &&
                              (state.trafficId == null ||
                                  state.trafficId == '')) {
                            showErrorMessage(context,
                                LocaleKeys.uploadAtLeastOneBill.localize);
                          } else {
                            cubit.fetchAdRequests(context);
                          }
                        }
                      },
                      status: true,
                    ),
              const SizedBox(
                height: 32,
              ),
              // SizedBox(
              //   height: 44,
              //   width: double.infinity,
              //   child: state.isLoading
              //       ? const Center(child: CircularProgressIndicator())
              //       : ElevatedButton(
              //           onPressed: () {
              //             if (cubit.formKey.currentState!.validate()) {
              //               if ((state.mobileId == null ||
              //                       state.mobileId == '') &&
              //                   (state.electricityId == null ||
              //                       state.electricityId == '') &&
              //                   (state.trafficId == null ||
              //                       state.trafficId == '')) {
              //                 showErrorMessage(context,
              //                     LocaleKeys.uploadAtLeastOneBill.localize);
              //               } else {
              //                 cubit.fetchAdRequests(context);
              //               }
              //             }
              //           },
              //           style: ElevatedButton.styleFrom(
              //               backgroundColor: AppColors.SECONDARY_COLOR,
              //               textStyle: TextStyle(
              //                   color: Colors.white, fontSize: 20.sp)),
              //           child: Label(
              //             text: LocaleKeys.sendRequest.localize,
              //             style: Styles.headerText(color: Colors.white),
              //           ),
              //         ),
              // ),
            ],
          ),
        ),
      );
    });
  }
}
