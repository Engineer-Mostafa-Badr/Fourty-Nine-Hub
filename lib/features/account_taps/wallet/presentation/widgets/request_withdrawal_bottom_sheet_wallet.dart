import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_two_cubit/wallet_two_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class RequestWithdrawalBottomSheetWallet extends StatefulWidget {
  const RequestWithdrawalBottomSheetWallet({
    super.key,
    required this.currancy,
    required this.totalAmount,
  });
  final String currancy;
  final num totalAmount;

  @override
  _RequestWithdrawalBottomSheetWalletState createState() =>
      _RequestWithdrawalBottomSheetWalletState();
}

class _RequestWithdrawalBottomSheetWalletState
    extends State<RequestWithdrawalBottomSheetWallet>
    with SingleTickerProviderStateMixin {
  int? _selectedIndex;
  final TextEditingController _amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _animationController.reverse();
          });
        }
      });

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.red,
    ).animate(_animationController);
  }

  void _submitWithdrawal() async {
    if (_selectedIndex == null) {
      _animationController.forward();
      return;
    }

    if (_formKey.currentState!.validate()) {
      // double amount = double.parse(_amountController.text);

      // if (amount < 500) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Minimum withdrawal amount is 500')),
      //   );
      //   return;
      // }
      await context.read<WalletTwoCubit>().requestWithdrawal(
            context,
            amount: _amountController.text,
            phone: UserCubit.to.state.data!.phone!,
            method: PaymentMethodsEntity.paymentMethods[_selectedIndex!].value,
          );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletTwoCubit, WalletTwoState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: '${LocaleKeys.selectAPaymentMethods.localize}:',
                style: Styles.headerText(),
              ),
              // الصف الأول
              Row(
                children: PaymentMethodsEntity.paymentMethods.sublist(0, 2).map(
                  (p) {
                    int index = PaymentMethodsEntity.paymentMethods.indexOf(p);
                    return Expanded(
                      child: AnimatedBuilder(
                        animation: _colorAnimation,
                        builder: (context, child) {
                          return PaymentMethodItem(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            isSelected: _selectedIndex == index,
                            title: p.title,
                            borderColor: _selectedIndex == null
                                ? _colorAnimation.value
                                : null,
                          );
                        },
                      ),
                    );
                  },
                ).toList(),
              ),
              // الصف الثاني
              Row(
                children: PaymentMethodsEntity.paymentMethods.sublist(2).map(
                  (p) {
                    int index = PaymentMethodsEntity.paymentMethods.indexOf(p);
                    return Expanded(
                      child: AnimatedBuilder(
                        animation: _colorAnimation,
                        builder: (context, child) {
                          return PaymentMethodItem(
                            title: p.title,
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            isSelected: _selectedIndex == index,
                            borderColor: _selectedIndex == null
                                ? _colorAnimation.value
                                : null,
                          );
                        },
                      ),
                    );
                  },
                ).toList(),
              ),
              const SizedBox(height: 16),
              Label(
                text: '${LocaleKeys.selectTheAmount.localize}:',
                style: Styles.headerText(),
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: LocaleKeys.enterWithdrawalAmount.localize,
                  border: const OutlineInputBorder(),
                  prefixText: '${widget.currancy} ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.pleaseEnterAnAmount.localize;
                  } else if (value.toInt < 500) {
                    return LocaleKeys.theAmountMustBeGreateThan500.localize;
                  } else if (value.toInt > widget.totalAmount) {
                    return '${LocaleKeys.theAmountMustBeLessThan.localize} ${widget.totalAmount}';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppButton(
                label: LocaleKeys.requestWithdraw.localize,
                style: Styles.headerText(
                  color: Colors.white,
                ),
                onPressed: _submitWithdrawal,
              ),
              // ElevatedButton(
              //   onPressed: _submitWithdrawal,
              //   child: const Text('Submit Withdrawal'),
              //   style: ElevatedButton.styleFrom(
              //     minimumSize: const Size(double.infinity, 50),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}

class PaymentMethodItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  final Color? borderColor;

  const PaymentMethodItem({
    super.key,
    required this.title,
    required this.onTap,
    this.isSelected = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color:
                borderColor ?? (isSelected ? Colors.blue : Colors.transparent),
            width: 2,
          ),
          color: isSelected ? Colors.blue.withOpacity(0.1) : null,
        ),
        padding: const EdgeInsets.all(8),
        child: Label(
          text: title,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: Styles.headerText(
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class PaymentMethodsEntity {
  final String title;
  final String value;

  PaymentMethodsEntity({
    required this.title,
    required this.value,
  });

  static List<PaymentMethodsEntity> paymentMethods = [
    PaymentMethodsEntity(title: 'Insta pay', value: 'instapay'),
    PaymentMethodsEntity(title: 'Yellow Card', value: 'yellowCard'),
    PaymentMethodsEntity(title: 'Fawry', value: 'fawry'),
    PaymentMethodsEntity(title: 'Paymob', value: 'paymob'),
  ];
}
