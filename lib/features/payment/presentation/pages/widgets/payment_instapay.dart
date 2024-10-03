import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/payment/presentation/cache_out_cubit/payment_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../domain/use_cases/cache_out/instapay_cache_out_use_case.dart';

class PaymentInstapay extends StatefulWidget {
  const PaymentInstapay({super.key});

  @override
  _PaymentInstapayState createState() => _PaymentInstapayState();
}

class _PaymentInstapayState extends State<PaymentInstapay> {
  String? selectedOption;
  bool isPhoneWallet = false;

  // Controllers for the form inputs
  final TextEditingController instaPayController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bankAccountController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  var formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentCacheOutCubit>(
      create: (BuildContext context) => serviceLocator(),
      child: BlocConsumer<PaymentCacheOutCubit, PaymentCacheOutState>(
        listener: (BuildContext context, state) {
          if (state.status == StateStatus.success) {
            showSuccessMessage(
              context,
              LocaleKeys.successfullyReceiveYourMoneyShortly.localize,
            );
          }
          if (state.status == StateStatus.error) {
            showErrorMessage(
              context,
              getFailureMessage(
                state.failure!,
                context,
              ),
            );
          }
        },
        builder: (BuildContext context, Object? state) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(20.r),
                    decoration:  InputDecoration(
                        labelText: LocaleKeys.chooseInstaPayOption.localize),
                    dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                    items: [
                       DropdownMenuItem(
                        value: 'instapay',
                        child: Text(LocaleKeys.instaPayAccount.localize),
                      ),
                      DropdownMenuItem(
                        value: 'phone',
                        child: Text(LocaleKeys.phoneNumber.localize),
                      ),
                      DropdownMenuItem(
                        value: 'bank',
                        child: Text(LocaleKeys.bankAccount.localize),
                      ),
                      DropdownMenuItem(
                        value: 'card',
                        child: Text(LocaleKeys.cardNumber.localize),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                  const Sizer(),
                  if (selectedOption == 'instapay') ...[
                    TextFormField(
                      controller: instaPayController,
                      decoration:  InputDecoration(
                        labelText: LocaleKeys.instaPayUsernameOrShortcut.localize,
                      ),
                      validator: _validateUsername,
                    ),
                  ],
                  if (selectedOption == 'phone') ...[
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.phoneNumber.localize,
                      ),
                      validator: _validatePhoneNumber,
                    ),
                    Row(
                      children: [
                         Label(text: '${LocaleKeys.type.localize} '),
                        Radio(
                          value: true,
                          groupValue: isPhoneWallet,
                          onChanged: (value) {
                            setState(() {
                              isPhoneWallet = value!;
                            });
                          },
                        ),
                         Label(text: LocaleKeys.wallet.localize),
                        Radio(
                          value: false,
                          groupValue: isPhoneWallet,
                          onChanged: (value) {
                            setState(() {
                              isPhoneWallet = value!;
                            });
                          },
                        ),
                         Label(text: LocaleKeys.account.localize),
                      ],
                    ),
                  ],
                  if (selectedOption == 'bank') ...[
                    TextFormField(
                      controller: bankAccountController,
                      decoration:  InputDecoration(
                        labelText: LocaleKeys.bankAccountNumber.localize,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.pleaseEnterBankAccountNumber.localize;
                        }
                        if (!RegExp(r'^[0-9]{10,16}$').hasMatch(value)) {
                          return LocaleKeys.pleaseEnter1016digits.localize;
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      controller: bankNameController,
                      decoration:  InputDecoration(
                        labelText: LocaleKeys.bankName.localize,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.pleaseEnterBankName.localize;
                        }
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return LocaleKeys.bankNameCanOnlyContainLetters.localize;
                        }
                        return null;
                      },
                    ),

                  ],
                  if (selectedOption == 'card') ...[
                    TextFormField(
                      controller: cardNumberController,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.cardNumber.localize,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.pleaseEnterCardNumber.localize;
                        }
                        if (!RegExp(r'^[0-9]{16}$').hasMatch(value)) {
                          return LocaleKeys.enterNumber16digits.localize;
                        }
                        if (!_isValidCardNumber(value)) {
                          return LocaleKeys.invalidCardNumber.localize;
                        }
                        return null;
                      },
                    ),

                  ],
                  const Sizer(),
                  InkWell(
                    onTap: () {
                      _submitForm(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20.h, horizontal: 100.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Theme.of(context).primaryColor),
                      child: Label(
                        text: LocaleKeys.submit.localize,
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

void _submitForm(BuildContext context) {
  String result = '';

  if (selectedOption == 'instapay') {
    if (formKey.currentState!.validate()){
      result = 'InstaPay: ${instaPayController.text}';
      context.read<PaymentCacheOutCubit>().postInstaPay(
          params:
          InstapayParams(instaPay: instaPayController.text));
    }
  } else if (selectedOption == 'phone') {
    if (formKey.currentState!.validate()){
      result =
      'Phone: ${phoneController.text}, Type: ${isPhoneWallet ? 'Wallet' : 'Account'}';
    }
  } else if (selectedOption == 'bank') {
    if(formKey.currentState!.validate()) {
      result =
        'Bank Account: ${bankAccountController.text}, Bank: ${bankNameController.text}';
    }
  } else if (selectedOption == 'card') {
    if (formKey.currentState!.validate()) {
      result = 'Card Number: ${cardNumberController.text}';
    }
  }
}
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.pleaseEnterUsername.localize;
    }
    // Add your custom validation logic here
    // For example: only allow alphanumeric characters and underscores
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return LocaleKeys.usernameContainLettersNumbersUnderscores.localize;
    }
    return null; // Return null if validation passes
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.pleaseEnterYourPhoneNumber
          .localize; // Please enter a phone number
    }
    // Regex for Egyptian phone number
    final RegExp phoneRegExp =
    RegExp(r'^(01)[0-9]{9}$');
    if (!phoneRegExp.hasMatch(value)) {
      return LocaleKeys.invalidPhoneNumber
          .localize; // Invalid phone number
    }
    return null;
  }
  bool _isValidCardNumber(String cardNumber) {
    int sum = 0;
    bool shouldDouble = false;

    // Iterate over the card number digits from right to left
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (shouldDouble) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;  // If doubling results in a two-digit number, subtract 9
        }
      }

      sum += digit;
      shouldDouble = !shouldDouble; // Alternate between doubling or not
    }

    return sum % 10 == 0;
  }

}
