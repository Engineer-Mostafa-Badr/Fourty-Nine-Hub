import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/payment/presentation/pages/widgets/payment_fawry.dart';
import 'package:fourtyninehub/features/payment/presentation/pages/widgets/payment_instapay.dart';
import 'package:fourtyninehub/features/payment/presentation/pages/widgets/payment_yellow_card.dart';

import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymobLink {
  final String amountId;
  final num amount;

  PaymobLink({required this.amountId, required this.amount});
}

class PaymentCashOut extends StatefulWidget {
  PaymentCashOut({
    Key? key,
  }) : super(key: key);

  @override
  _PaymentCashOutState createState() => _PaymentCashOutState();
}

class _PaymentCashOutState extends State<PaymentCashOut> {
  String _selectedPaymentMethod = '';
  String? _selectedProviderId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.paymentOptions.localize),
      ),
      body: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.all(8.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildCustomCard(
                          onTap: () async {
                            // final cubit = context.read<PaymentCubit>();
                            // final url = cubit.state.paymobData?.data;
                            // if (url != null) {
                            //   await launchUrl(Uri.parse(url));
                            // }
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
                      Expanded(
                        child: _buildCustomCard(
                          title: 'Yellow Card',
                          titleId: 'manual',
                          icon: Icon(Icons.credit_card,color: Colors.yellow,size: 60.sp,),
                          color: Colors.orange,
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

          // cubit.getPaymobData(
          //     amountId: widget.amountId, providerId: _selectedProviderId!);
        } else {
          print('Provider ID not found for $title');
        }

        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        height: 200.h,
        margin: EdgeInsets.symmetric(horizontal: 4.0.w),
        padding: EdgeInsets.all(12.0.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: _selectedPaymentMethod == title ? color : Colors.grey,
            width: 4.0.w,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
           Sizer(),
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
        return const PaymentFawryCard();
      case 'InstaPay':
        return const PaymentInstapay();
      case 'Yellow Card':
        return const PaymentYellowCard();
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
    return SizedBox.shrink();
  }

  // Widget _bankTransferPayment(){
  //   String? selectedOption;
  //   bool isPhoneWallet = false;
  //
  //   // Controllers for the form inputs
  //   final TextEditingController instaPayController = TextEditingController();
  //   final TextEditingController phoneController = TextEditingController();
  //   final TextEditingController bankAccountController = TextEditingController();
  //   final TextEditingController bankNameController = TextEditingController();
  //   final TextEditingController cardNumberController = TextEditingController();
  // return  Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       children: [
  //         DropdownButtonFormField<String>(
  //           decoration: InputDecoration(labelText: 'Choose Payment Option'),
  //           items: [
  //             DropdownMenuItem(
  //               child: Text('InstaPay Account'),
  //               value: 'instapay',
  //             ),
  //             DropdownMenuItem(
  //               child: Text('Phone Number'),
  //               value: 'phone',
  //             ),
  //             DropdownMenuItem(
  //               child: Text('Bank Account'),
  //               value: 'bank',
  //             ),
  //             DropdownMenuItem(
  //               child: Text('Card Number'),
  //               value: 'card',
  //             ),
  //           ],
  //           onChanged: (value) {
  //             setState(() {
  //               selectedOption = value;
  //             });
  //           },
  //         ),
  //         SizedBox(height: 20),
  //         if (selectedOption == 'instapay') ...[
  //           TextFormField(
  //             controller: instaPayController,
  //             decoration: InputDecoration(
  //               labelText: 'InstaPay Username or Shortcut',
  //             ),
  //           ),
  //         ],
  //         if (selectedOption == 'phone') ...[
  //           TextFormField(
  //             controller: phoneController,
  //             decoration: InputDecoration(
  //               labelText: 'Phone Number',
  //             ),
  //           ),
  //           Row(
  //             children: [
  //               Text('Type: '),
  //               Radio(
  //                 value: true,
  //                 groupValue: isPhoneWallet,
  //                 onChanged: (value) {
  //                   setState(() {
  //                     isPhoneWallet = value!;
  //                   });
  //                 },
  //               ),
  //               Text('Wallet'),
  //               Radio(
  //                 value: false,
  //                 groupValue: isPhoneWallet,
  //                 onChanged: (value) {
  //                   setState(() {
  //                     isPhoneWallet = value!;
  //                   });
  //                 },
  //               ),
  //               Text('Account'),
  //             ],
  //           ),
  //         ],
  //         if (selectedOption == 'bank') ...[
  //           TextFormField(
  //             controller: bankAccountController,
  //             decoration: InputDecoration(
  //               labelText: 'Bank Account Number',
  //             ),
  //           ),
  //           TextFormField(
  //             controller: bankNameController,
  //             decoration: InputDecoration(
  //               labelText: 'Bank Name',
  //             ),
  //           ),
  //         ],
  //         if (selectedOption == 'card') ...[
  //           TextFormField(
  //             controller: cardNumberController,
  //             decoration: InputDecoration(
  //               labelText: 'Card Number',
  //             ),
  //           ),
  //         ],
  //         SizedBox(height: 30),
  //         ElevatedButton(
  //           onPressed: () {
  //             // Handle form submission based on the selected option
  //             if (selectedOption == 'instapay') {
  //               print('InstaPay: ${instaPayController.text}');
  //             } else if (selectedOption == 'phone') {
  //               print('Phone: ${phoneController.text}, Type: ${isPhoneWallet ? 'Wallet' : 'Account'}');
  //             } else if (selectedOption == 'bank') {
  //               print('Bank Account: ${bankAccountController.text}, Bank: ${bankNameController.text}');
  //             } else if (selectedOption == 'card') {
  //               print('Card Number: ${cardNumberController.text}');
  //             }
  //           },
  //           child: Text('Submit'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _bankTransferPayment() {
  //   final TextEditingController _bankNameController = TextEditingController();
  //
  //   final cubit = context.read<PaymentCubit>();
  //   final banks = cubit.state.data ?? [];
  //   final phoneNumbers = <String>[];
  //   for (var bank in banks) {
  //     if (bank.metadata?.phone1 != null) {
  //       phoneNumbers.add(bank.metadata!.phone1);
  //     }
  //     if (bank.metadata?.phone2 != null) {
  //       phoneNumbers.add(bank.metadata!.phone2);
  //     }
  //   }
  //   return Padding(
  //     padding: EdgeInsets.all(16.0),
  //     child: Column(
  //       children: [
  //         DropdownButtonFormField<String>(
  //           decoration: InputDecoration(
  //             fillColor: Colors.white,
  //             labelText: 'Select Phone Number',
  //           ),
  //           dropdownColor: Colors.blue.withOpacity(0.5),
  //           items: phoneNumbers.map((phone) {
  //             return DropdownMenuItem<String>(
  //               value: phone,
  //               child: Text(phone),
  //             );
  //           }).toList(),
  //           onChanged: (value) {
  //             if (value != null) {
  //               _bankNameController.text = value;
  //             }
  //           },
  //         ),
  //         SizedBox(height: 15.h),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: AppColors.PRIMARY_COLOR,
  //           ),
  //           onPressed: () {},
  //           child: Text(
  //             "${widget.amount}",
  //             style: TextStyle(color: AppColors.LIGHT_COLOR, fontSize: 20.sp),
  //           ),
  //         ),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             SizedBox(height: 20.h),
  //             Label(
  //               text: "Snap copy of bill payment",
  //               style: Styles.headerText(),
  //             ),
  //             SizedBox(),
  //             InkWell(
  //               onTap: () async {
  //                 await cubit.uploadProfileImage();
  //               },
  //               child: BlocBuilder<PaymentCubit, PaymentState>(
  //                 buildWhen: (previous, current) =>
  //                 previous.uploadedImage != current.uploadedImage ||
  //                     previous.uploadStatus != current.uploadStatus,
  //                 builder: (context, state) {
  //                   if (state.uploadStatus == StateStatus.loading) {
  //                     return Center(child: CircularProgressIndicator());
  //                   } else if (state.uploadStatus == StateStatus.success &&
  //                       state.uploadedImage != null) {
  //                     return Image.file(state.uploadedImage!);
  //                   }
  //                   return ImagePickerPlaceholder();
  //                 },
  //               ),
  //             ),
  //             BlocBuilder<PaymentCubit, PaymentState>(
  //               builder: (context, state) {
  //                 return ElevatedButton(
  //                   onPressed: () {
  //                     // Snackbar: "Your bill has been sent successfully, waiting for administration approval."
  //                     print("${state.imageMediaId}");
  //                     print(" the provider ${_selectedProviderId}");
  //                     if (state.imageMediaId != null) {
  //                       cubit.postInstaPay(
  //                           receiptId: state.imageMediaId!,
  //                           amountId: widget.amountId,
  //                           paymentProviderId: _selectedProviderId!);
  //                     }
  //                     if (state.status == StateStatus.success) {
  //                       print("99111");
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         SnackBar(
  //                           content: Text(state.instaPayResponseData?.message ??
  //                               'Payment successful'),
  //                           backgroundColor: Colors.green,
  //                         ),
  //                       );
  //                       context.go(Routes.HOME);
  //                     }
  //                   },
  //                   child: Text(
  //                     "Send for review and approval",
  //                     style: TextStyle(
  //                         color: AppColors.LIGHT_COLOR, fontSize: 20.sp),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
