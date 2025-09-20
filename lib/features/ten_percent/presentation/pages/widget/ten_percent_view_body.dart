import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../account_taps/wallet/presentation/widgets/custom_button_wallet_and_gift_and_cashback.dart';
import '../../cubit/ten_percent_cubit.dart';
import 'bill_value_field.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';

import '../../../../../res/assets/assets.dart';
import '../../../../account_taps/wallet/presentation/widgets/button_wallet_and_bill.dart';
import '../../../../../helpers/manage_vibration.dart';

class TenPercentViewBody extends StatefulWidget {
  const TenPercentViewBody({
    super.key,
  });

  @override
  State<TenPercentViewBody> createState() => _TenPercentViewBodyState();
}

class _TenPercentViewBodyState extends State<TenPercentViewBody> {
  // final FocusNode trafficFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   trafficFocusNode.requestFocus();
    // });

    _scrollController.addListener(() {
      bool shouldShow = _scrollController.offset > 200;
      if (shouldShow != _showButton) {
        setState(() {
          _showButton = shouldShow;
        });
      }
    });
  }

  @override
  void dispose() {
    // trafficFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TenPercentCubit, TenPercentState>(
        builder: (context, state) {
      var cubit = context.read<TenPercentCubit>();
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: cubit.formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: _scrollController,
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
                          ManageVibration.vibrate();
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
                        // currentFocusNode: trafficFocusNode,
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
                          ManageVibration.vibrate();
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
                          ManageVibration.vibrate();
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
                    ? const Center(child: CustomCircularProgressIndicator())
                    : CustomButtonWalletAndGiftAndCashback(
                        title: LocaleKeys.sendRequest.localize,
                        onPressed: () {
                          ManageVibration.vibrate();
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
                //       ? const Center(child: CustomCircularProgressIndicator())
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
        ),
      );
    });
  }

  Widget _buildChanceBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // صورة المباني
            Container(
              width: double.infinity,
              height: 130,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800&h=400&fit=crop',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // الجزء السفلي الأبيض
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                // height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // أيقونة اللمبة
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.lightbulb,
                        color: Colors.orange[700],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // النص
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Join by buying a share in the product",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Everyone wins in the draw, one lucky winner gets the product",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
