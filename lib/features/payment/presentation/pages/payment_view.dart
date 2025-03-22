import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/payment/presentation/cubit/payment_cubit.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.paymentOptions.localize),
      ),
      body: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          return SingleChildScrollView(
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
                        title: 'Paymob',
                        titleId: 'Paymob',
                        icon: Image.asset(
                          Assets.paymob,
                          fit: BoxFit.cover,
                          height: 30.h,
                        ),
                        color: Colors.blue,
                        details: LocaleKeys.enterYourCreditCardDetails.localize,
                        context: context,
                      ),
                    ),
                    Expanded(
                      child: _buildCustomCard(
                        title: 'Fawry',
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
                    Expanded(
                      child: _buildCustomCard(
                        title: 'InstaPay',
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
                SizedBox(height: 20.h),
                _buildPaymentBody(context),
                if (_selectedPaymentMethod == 'Credit Card') ...[
                  SizedBox(height: 20.h),
                ],
              ],
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
    String? titleId,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = title;
        });

        final cubit = context.read<PaymentCubit>();
        _selectedProviderId = cubit.paymentProviderMap[titleId];

        if (_selectedProviderId != null) {
          print('Provider ID for $title: $_selectedProviderId');

          cubit.getPaymobData(
              amountId: widget.amountId, providerId: _selectedProviderId!);
        } else {
          print('Provider ID not found for $title');
        }

        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        height: 150.h,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: _selectedPaymentMethod == title ? color : Colors.grey,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
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
      case 'InstaPay':
        return _bankTransferPayment();
      default:
        return Center(
          child: Text(LocaleKeys.pleaseSelectPaymentMethod.localize),
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
    final TextEditingController bankNameController = TextEditingController();

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              //fillColor: Colors.white,
              labelText: LocaleKeys.phoneNumber.localize,
            ),
            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
            items: phoneNumbers.map((phone) {
              return DropdownMenuItem<String>(
                value: phone,
                child: Text(phone),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                bankNameController.text = value;
              }
            },
          ),
          SizedBox(height: 25.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.PRIMARY_COLOR,
            ),
            onPressed: () {},
            child: Text(
              "${widget.amount}",
              style: TextStyle(color: AppColors.LIGHT_COLOR, fontSize: 20.sp),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              Label(
                text: LocaleKeys.snapCopyOfBillPayment.localize,
                style: Styles.headerText(),
              ),
              SizedBox(
                height: 10.h,
              ),
              InkWell(
                onTap: () async {
                  await cubit.uploadProfileImage(context: context);
                },
                child: BlocBuilder<PaymentCubit, PaymentState>(
                  buildWhen: (previous, current) =>
                      previous.uploadedImage != current.uploadedImage ||
                      previous.uploadStatus != current.uploadStatus,
                  builder: (context, state) {
                    if (state.uploadStatus == StateStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.uploadStatus == StateStatus.success &&
                        state.uploadedImage != null) {
                      return Image.file(state.uploadedImage!);
                    }
                    return const ImagePickerPlaceholder();
                  },
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              BlocBuilder<PaymentCubit, PaymentState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      // Snackbar: "Your bill has been sent successfully, waiting for administration approval."
                      print("${state.imageMediaId}");
                      print(" the provider $_selectedProviderId");
                      if (state.imageMediaId != null) {
                        cubit.postInstaPay(
                            receiptId: state.imageMediaId!,
                            amountId: widget.amountId,
                            paymentProviderId: _selectedProviderId!);
                      }
                      if (state.status == StateStatus.success) {
                        print("99111");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.instaPayResponseData?.message ??
                                LocaleKeys.paymentSuccessful.localize),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // context.go(Routes.HOME);
                        context.pop();
                        context.pop();
                      }
                    },
                    child: Text(
                      LocaleKeys.sendReviewApproval.localize,
                      style: Styles.mediumText(
                          color: AppColors.AUTH_CONTAINER_COLOR),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
