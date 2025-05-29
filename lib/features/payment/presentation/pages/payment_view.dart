import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_dropdown.dart';
import 'package:fourtyninehub/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:fourtyninehub/features/payment/presentation/pages/widgets/button_upload_image.dart';
import 'package:fourtyninehub/features/payment/presentation/pages/widgets/payment_fawry_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widget/custom_scaffold.dart';

class PaymobLink {
  final String amountId;
  final num amount;

  PaymobLink({required this.amountId, required this.amount});
}

class PaymentView extends StatefulWidget {
  const PaymentView({
    super.key,
    required this.amountId,
    required this.amount,
  });

  final String amountId;
  final num amount;

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  String _selectedPaymentMethod = '';
  String? _selectedProviderId;
  String phoneNumber = '';
  late final TextEditingController bankNameController;

  @override
  void initState() {
    bankNameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.paymentOptions.localize,
        ),
      ),
      body: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildCustomCard(
                          onTap: () async {
                            final cubit = context.read<PaymentCubit>();
                            final url = cubit.state.paymobData?.data;
                            if (url != null) {
                              await launchUrl(Uri.parse(url));
                            }
                          },
                          title: LocaleKeys.paymob.localize,
                          titleId: 'Paymob',
                          icon: Image.asset(
                            Assets.paymob,
                            fit: BoxFit.cover,
                            height: 30.h,
                          ),
                          color: Colors.blue,
                          details:
                              LocaleKeys.enterYourCreditCardDetails.localize,
                          context: context,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: _buildCustomCard(
                          title: LocaleKeys.fawry.localize,
                          titleId: 'Fawry',
                          icon: Image.asset(
                            Assets.fawry,
                            fit: BoxFit.cover,
                            height: 30.h,
                          ),
                          color: Colors.orange,
                          details: LocaleKeys.enterPaymobLink.localize,
                          context: context,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: _buildCustomCard(
                          title: LocaleKeys.instaPay.localize,
                          titleId: 'manual',
                          icon: Image.asset(
                            Assets.instaPay,
                            fit: BoxFit.cover,
                            height: 50.h,
                          ),
                          color: Colors.deepPurple,
                          details: LocaleKeys.enterBankAccountDetails.localize,
                          context: context,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildPaymentBody(context),
                  if (_selectedPaymentMethod == 'Credit Card') ...[
                    SizedBox(height: 20.h),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomCard({
    required String title,
    required Widget icon,
    required Color color,
    required String details,
    VoidCallback? onTap,
    required String titleId,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = titleId;
        });

        final cubit = context.read<PaymentCubit>();
        _selectedProviderId = cubit.paymentProviderMap[titleId];

        if (_selectedProviderId != null) {
          print('Provider ID  for $titleId:  $_selectedProviderId');

          cubit.getPaymobData(
              amountId: widget.amountId, providerId: _selectedProviderId!);
        } else {
          print('Provider ID not found for $titleId');
        }

        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        height: 150.h,
        // margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: context.isDarkMode ? const Color(0xff0E0E0E) : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: _selectedPaymentMethod == titleId
                ? color
                : (context.isDarkMode ? const Color(0xff333333) : Colors.grey),
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _selectedPaymentMethod == titleId
                  ? color.withValues(alpha: 0.4)
                  : const Color(0x66D9D9D9),
              blurRadius: 4,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            )
            // BoxShadow(
            //   color: color.withOpacity(0.3),
            //   spreadRadius: 2,
            //   blurRadius: 8,
            //   offset: const Offset(0, 4),
            // ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const Spacer(),
            Text(
              title,
              style: Styles.mediumText(color: color),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentBody(BuildContext context) {
    switch (_selectedPaymentMethod) {
      case 'Credit Card':
        return _openLinkPayment(context);
      case 'Fawry':
        return FawryPayment(
          amountId: widget.amountId,
          providerId: _selectedProviderId ?? '',
          amount: widget.amount,
        );
      case 'manual':
        return _bankTransferPayment();
      default:
        return Center(
          child: Label(
            text: LocaleKeys.pleaseSelectPaymentMethod.localize,
            style: Styles.headerText(
              color: Colors.grey,
            ),
          ),
        );
    }
  }

  Widget _openLinkPayment(BuildContext context) {
    final cubit = context.read<PaymentCubit>();
    final url = cubit.state.paymobData?.data;
    if (url != null) {
      launchUrl(Uri.parse(url));
    } else {
      print("Null $url");
    }
    return const SizedBox.shrink();
  }

  Widget _bankTransferPayment() {
    final cubit = context.read<PaymentCubit>();
    final banks = cubit.state.data ?? [];
    final phoneNumbers = <String>[];
    for (var bank in banks) {
      if (bank.metadata?.phone1 != null) {
        phoneNumbers.add(bank.metadata!.phone1);
      }
      if (bank.metadata?.phone2 != null) {
        phoneNumbers.add(bank.metadata!.phone2);
      }
    }
    return Column(
      children: [
        // DropdownButtonHideUnderline(
        //   child: Container(
        //     width: double.infinity,
        //     height: 42,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(15),
        //       color: const Color(0xffF5F5F5),
        //     ),
        //     child: Theme(
        //       data: Theme.of(context).copyWith(
        //         canvasColor: const Color(0xFFE0E0E0),
        //       ),
        //       child: ButtonTheme(
        //         alignedDropdown: true,
        //         child: DropdownButton<String>(
        //           value: null,
        //           isExpanded: true,
        //           icon: const Icon(Icons.keyboard_arrow_down_rounded),
        //           menuMaxHeight: 300,
        //           elevation: 2,
        //           dropdownColor: const Color(0xFFE0E0E0),
        //           borderRadius: BorderRadius.circular(15),
        //           itemHeight: 50,
        //           underline: Container(),
        //           onChanged: (String? value) {
        //             if (value != null) {
        //               bankNameController.text = value;
        //             }
        //           },
        //           items: phoneNumbers.map((phone) {
        //             return DropdownMenuItem<String>(
        //               value: phone,
        //               child: Text(phone),
        //             );
        //           }).toList(),
        //           hint: Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 16),
        //             child: Label(
        //               text: LocaleKeys.phoneNumber.localize,
        //               style: Styles.mediumText(fontSize: 32),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        CustomDropdown<String>(
          items: phoneNumbers,
          displayStringForItem: (item) => item,
          onItemSelected: (value) {
            // if (value != null) {
            bankNameController.text = value;
            phoneNumber = value;
            // }
          },
          selectedItem: null,
          // selectedItem: ,
          itemBuilder: (item) => ListTile(
            title: Label(
              text: item,
              style: Styles.headerText(
                height: 1.60,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          dropdownDecoration: BoxDecoration(
            color: context.isDarkMode ? const Color(0xff0D0D0D) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: context.isDarkMode ? Colors.white : Colors.black,
                width: 2),
          ),
          buttonDecoration: BoxDecoration(
            color: context.isDarkMode
                ? const Color(0xff191919)
                : const Color(0xffF3F3F3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xff7D569E), width: 1),
          ),
          iconColor: const Color(0xff7D569E),
          closedIcon: Icons.keyboard_arrow_down_outlined,
          openedIcon: Icons.keyboard_arrow_up_outlined,
          hint: LocaleKeys.phoneNumber.localize,
          textAlign: TextAlign.start,
          buttonTextStyle: Styles.headerText(
            fontSize: 32,
            color: const Color(0xFF7D569E),
            height: 1.60,
          ),
          // itemTextStyle: Styles.headerText(color: Colors.white),
        ),
        // DropdownButtonFormField<String>(
        //   decoration: InputDecoration(
        //     //fillColor: Colors.white,
        //     labelText: LocaleKeys.phoneNumber.localize,
        //   ),
        //   dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        //   items: phoneNumbers.map((phone) {
        //     return DropdownMenuItem<String>(
        //       value: phone,
        //       child: Text(phone),
        //     );
        //   }).toList(),
        //   onChanged: (value) {
        //     if (value != null) {
        //       bankNameController.text = value;
        //     }
        //   },
        // ),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: context.isDarkMode
                ? const Color(0xFFCAD0F4)
                : AppColors.c0B1035,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onPressed: () {},
          child: Label(
            text: "${widget.amount}",
            style: Styles.headerText(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: context.isDarkMode ? Colors.black : Colors.white,
              height: 1.6,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            Label(
              text: LocaleKeys.snapCopyOfBillPayment.localize,
              style: Styles.headerText(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                height: 1.60,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            BlocBuilder<PaymentCubit, PaymentState>(
              buildWhen: (previous, current) =>
                  previous.uploadedImage != current.uploadedImage ||
                  previous.uploadStatus != current.uploadStatus,
              builder: (context, state) {
                if (state.uploadStatus == StateStatus.loading) {
                  return const CustomLoading();
                }
                return ButtonUploadImage(
                  height: 48,
                  icon: state.uploadStatus == StateStatus.success &&
                          state.uploadedImage != null
                      ? Icon(
                          Icons.check_circle_outline_rounded,
                          color: context.isDarkMode
                              ? const Color(0xff0D0D0D)
                              : Colors.grey,
                        )
                      : Icon(
                          Icons.file_upload_outlined,
                          color: context.isDarkMode
                              ? const Color(0xff0D0D0D)
                              : Colors.grey,
                        ),
                  label: LocaleKeys.uploadImage.localize,
                  onPressed: () async {
                    await cubit.uploadProfileImage(context: context);
                  },
                );
              },
            ),
            // InkWell(
            //   onTap: () async {
            //     await cubit.uploadProfileImage(context: context);
            //   },
            //   child: BlocBuilder<PaymentCubit, PaymentState>(
            //     buildWhen: (previous, current) =>
            //         previous.uploadedImage != current.uploadedImage ||
            //         previous.uploadStatus != current.uploadStatus,
            //     builder: (context, state) {
            //       if (state.uploadStatus == StateStatus.loading) {
            //         return const Center(child: CustomCircularProgressIndicator());
            //       } else if (state.uploadStatus == StateStatus.success &&
            //           state.uploadedImage != null) {
            //         return Image.file(state.uploadedImage!);
            //       }
            //       return const ImagePickerPlaceholder();
            //     },
            //   ),
            // ),
            const SizedBox(
              height: 8,
            ),
            BlocConsumer<PaymentCubit, PaymentState>(
              listener: (context, state) {
                // if (state.status == StateStatus.success) {
                //   print("99111");
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text(state.instaPayResponseData?.message ??
                //           LocaleKeys.paymentSuccessful.localize),
                //       backgroundColor: Colors.green,
                //     ),
                //   );
                //   // context.go(Routes.HOME);
                // }
                if (state.instaPayStatus == StateStatus.success) {
                  showSuccessMessage(
                    context,
                    state.instaPayResponseData?.message ??
                        LocaleKeys.paymentSuccessful.localize,
                  );
                  context.go(Routes.HOME);
                }
                if (state.instaPayStatus == StateStatus.error) {
                  showErrorMessage(
                    context,
                    getFailureMessage(
                      state.failure!,
                      context,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.isDarkMode
                          ? const Color(0xFFF45560)
                          : const Color(0xffF33D49),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      // Snackbar: "Your bill has been sent successfully, waiting for administration approval."
                      print("${state.imageMediaId}");
                      print(" the provider $_selectedProviderId");
                      // if (phoneNumbers.isEmpty) {
                      if (bankNameController.text.isEmpty) {
                        showErrorMessage(context,
                            LocaleKeys.pleaseEnterPhoneNumber.localize);
                        return;
                      }
                      if (state.imageMediaId != null) {
                        cubit.postInstaPay(
                          context,
                          receiptId: state.imageMediaId!,
                          amountId: widget.amountId,
                          paymentProviderId: _selectedProviderId!,
                          phoneNumber: phoneNumber,
                        );
                      } else {
                        showErrorMessage(
                          context,
                          LocaleKeys.youMustUploadTheImage.localize,
                        );
                      }
                    },
                    child: Label(
                      text: LocaleKeys.sendReviewApproval.localize,
                      style: Styles.mediumText(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: context.isDarkMode
                            ? const Color(0xff0D0D0D)
                            : AppColors.AUTH_CONTAINER_COLOR,
                        height: 1.60,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
