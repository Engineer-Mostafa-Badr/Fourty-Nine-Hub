import 'package:flutter/material.dart';
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

import '../../../../service_locator/service_locator.dart';
import '../cache_out_cubit/payment_cubit.dart';

class PaymobLink {
  final String amountId;
  final num amount;

  PaymobLink({required this.amountId, required this.amount});
}

class PaymentCashOut extends StatefulWidget {
  const PaymentCashOut({
    super.key,
  });

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
        title: Text(LocaleKeys.cashOutOption.localize),
      ),
      body: BlocProvider<PaymentCacheOutCubit>(
        create: (BuildContext context) =>serviceLocator()..payoutMethod(),
        child: BlocBuilder<PaymentCacheOutCubit, PaymentCacheOutState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.all(8.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        if(state.method?.PaymobCashOut ==true)
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
                        if(state.method?.FawryCashOut ==true)
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
                        if(state.method?.YellowCardCashOut ==true)
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
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
           const Sizer(),
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
    return const SizedBox.shrink();
  }
}
