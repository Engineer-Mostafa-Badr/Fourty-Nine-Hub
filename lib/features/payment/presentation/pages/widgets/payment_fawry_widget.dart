import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_save_card_token_response_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_saved_cards_entity.dart';
import 'package:fourtyninehub/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/utils/custom_show_dialog.dart';
import '../../../../../res/style/styles.dart';

class FawryPayment extends StatefulWidget {
  final String amountId;
  final String providerId;
  final num amount;

  const FawryPayment(
      {super.key,
      required this.amountId,
      required this.providerId,
      required this.amount});

  @override
  _FawryPaymentState createState() => _FawryPaymentState();
}

class _FawryPaymentState extends State<FawryPayment> {
  bool _isCardSelected = false;
  bool _showQrCode = false;
  bool _showLink = false;
  bool _showNumber = false;
  bool _isAddingNewCard = false;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final FocusNode _cvvFocusNode = FocusNode();
  final TextEditingController _expiryMonthController = TextEditingController();
  final TextEditingController _expiryYearController = TextEditingController();
  final TextEditingController _cardAlias = TextEditingController();

  @override
  @override
  void initState() {
    super.initState();
    _cvvFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final PaymentCubit paymentCubit = context.read<PaymentCubit>();

    final mutliPaymentResponse = paymentCubit.state.mutliPaymentResponse;
    final paymentData = mutliPaymentResponse?.data;

    return Column(
      children: [
        _paymentOptions(paymentCubit),
        if (paymentCubit.state.status == StateStatus.loading) ...[
          const SizedBox(
            height: 70,
          ),
          const CustomLoading(),
        ] else ...[
          if (_isCardSelected) _creditCardPayment(),
          if (_showNumber && paymentData != null) _paymentNumber(paymentData),
          if (_showQrCode && paymentData != null) _qrCode(paymentCubit),
          if (_showLink && paymentData != null) _paymentLink(paymentData),
        ]
      ],
    );
  }

  Widget _paymentOptions(PaymentCubit paymentCubit) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _paymentOptionButton(
                onTap: () {
                  setState(() {
                    _isCardSelected = !_isCardSelected;
                    _showQrCode = false;
                    _showLink = false;
                    _showNumber = false;
                  });
                },
                icon: Icons.credit_card,
                text: "Card",
                isSelected: _isCardSelected,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: _paymentOptionButton(
                onTap: () {
                  setState(() {
                    _showQrCode = !_showQrCode;
                    _isCardSelected = false;
                    _showLink = false;
                    _showNumber = false;
                    if (_showQrCode == true) {
                      paymentCubit.makeMultiPayment(
                        amountId: widget.amountId,
                        providerId: widget.providerId,
                        paymentMethod: "MWALLET",
                      );
                    }
                  });
                },
                icon: Icons.qr_code_scanner,
                text: "QR Code",
                isSelected: _showQrCode,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _paymentOptionButton(
                onTap: () {
                  setState(() {
                    _showLink = !_showLink;
                    _isCardSelected = false;
                    _showQrCode = false;
                    _showNumber = false;
                    if (_showLink == true) {
                      paymentCubit.makeMultiPayment(
                        amountId: widget.amountId,
                        providerId: widget.providerId,
                        paymentMethod: "Link",
                      );
                    }
                  });
                },
                icon: Icons.link,
                text: "Link",
                isSelected: _showLink,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: _paymentOptionButton(
                onTap: () {
                  setState(() {
                    _showNumber = !_showNumber;
                    _isCardSelected = false;
                    _showQrCode = false;
                    _showLink = false;
                    if (_showNumber == true) {
                      paymentCubit.makeMultiPayment(
                        amountId: widget.amountId,
                        providerId: widget.providerId,
                        paymentMethod: "PayAtFawry",
                      );
                    }
                  });
                },
                icon: Icons.payment,
                text: "Pay at Fawry",
                isSelected: _showNumber,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSavedCardsList(
      PaymentCubit paymentCubit, List<CardEntity> savedCards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saved Cards',
          style: Styles.mediumText(),
        ),
        SizedBox(height: 16.h),
        ...savedCards.map((card) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8.h),
            child: ListTile(
              title:
                  Text(card.cardAlias.isNotEmpty ? card.cardAlias : 'No alias'),
              subtitle: Text(
                  '**** **** **** ${card.lastFourDigits} - Exp: ${card.updatedAt.year.toString().substring(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Show confirmation dialog
                      bool? confirm = await showAnimatedDialog(
                        context,
                        AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text(
                              'Are you sure you want to delete this card?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text('Delete'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      );
                      // bool? confirm = await showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return AlertDialog(
                      //       title: const Text('Confirm Deletion'),
                      //       content: const Text(
                      //           'Are you sure you want to delete this card?'),
                      //       actions: <Widget>[
                      //         TextButton(
                      //           onPressed: () {
                      //             Navigator.of(context).pop(true);
                      //           },
                      //           child: const Text('Delete'),
                      //         ),
                      //         TextButton(
                      //           onPressed: () {
                      //             Navigator.of(context).pop(false);
                      //           },
                      //           child: const Text('Cancel'),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );

                      if (confirm == true) {
                        // Call the delete card method
                        await paymentCubit.deleteCard(card.id);
                        // Delay to allow the state to update
                        await Future.delayed(const Duration(milliseconds: 500));

                        final state = context.read<PaymentCubit>().state;
                        if (state.status == StateStatus.success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Card deleted successfully')),
                          );
                        } else if (state.status == StateStatus.error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to delete card:')),
                          );
                        }
                      }
                    },
                  ),
                  Radio<CardEntity>(
                    value: card,
                    groupValue: paymentCubit.selectedCard,
                    onChanged: (CardEntity? selectedCard) {
                      if (selectedCard != null) {
                        paymentCubit.selectCard(selectedCard);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _creditCardPayment() {
    final paymentCubit = BlocProvider.of<PaymentCubit>(context);

    void updateCreditCard() {
      setState(() {});
    }

    void initializeListeners() {
      _cardNumberController.addListener(updateCreditCard);
      _expiryMonthController.addListener(updateCreditCard);
      _expiryYearController.addListener(updateCreditCard);
      _cvvController.addListener(updateCreditCard);
      _cardAlias.addListener(updateCreditCard);
    }

    initializeListeners();

    return Column(
      children: [
        if (paymentCubit.state.savedCardsData != null &&
            paymentCubit.state.savedCardsData!.isNotEmpty)
          _buildSavedCardsList(
              paymentCubit, paymentCubit.state.savedCardsData!),
        const SizedBox(height: 16),
        if (paymentCubit.selectedCard != null)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.PRIMARY_COLOR,
            ),
            onPressed: () {
              if (paymentCubit.selectedCard != null) {
                final card = paymentCubit.selectedCard!;
                print("Selected Card Data:");
                print("Card Alias: ${card.cardAlias}");
                print("Last Four Digits: ${card.lastFourDigits}");
                print(
                    "Expiry Date: ${card.updatedAt.year.toString().substring(2)}");
                paymentCubit.payWithToken(
                    cardId: card.id,
                    amountId: widget.amountId,
                    cvv: card.cvv.toString());
              }
            },
            child: Text(
              "Pay Now",
              style: Styles.mediumText(color: AppColors.AUTH_CONTAINER_COLOR),
            ),
          ),
        const Sizer(),
        AppButton(
          height: 44,
          color: AppColors.LIGHT_COLOR,
          label: _isAddingNewCard
              ? LocaleKeys.hideCardForm.localize
              : LocaleKeys.addNewCard.localize,
          style: Styles.headerText(
            fontWeight: FontWeight.w500,
            fontSize: 32,
            color: AppColors.LIGHT_COLOR,
          ),
          backColor: AppColors.SECONDARY_COLOR_DARK2,
          onPressed: () {
            setState(() {
              _isAddingNewCard = !_isAddingNewCard;
            });
          },
        ),
        if (_isAddingNewCard) ...[
          const SizedBox(height: 16),
          CreditCardWidget(
            padding: 0,
            cardBgColor: Colors.black,
            cardNumber: _cardNumberController.text,
            //  textStyle: Styles.mediumText(fontSize: 30.sp,color: Theme.of(context).scaffoldBackgroundColor),
            chipColor: Theme.of(context).scaffoldBackgroundColor,
            expiryDate:
                '${_expiryMonthController.text}/${_expiryYearController.text}',
            cardHolderName: _cardAlias.text,
            cvvCode: _cvvController.text,
            showBackView: _cvvFocusNode.hasFocus,
            obscureCardNumber: true,
            obscureCardCvv: true,
            isHolderNameVisible: false,
            isChipVisible: true,
            onCreditCardWidgetChange: (creditCardBrand) {},
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cardNumberController,
            cursorColor: AppColors.PRIMARY_COLOR,
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
            decoration: InputDecoration(
              labelText: 'Credit Card Number',
              labelStyle: const TextStyle(color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
            maxLength: 16,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            cursorColor: AppColors.PRIMARY_COLOR,
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
            controller: _cardAlias,
            decoration: InputDecoration(
              labelText: 'Credit Card Name',
              labelStyle: const TextStyle(color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
            maxLength: 16,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  cursorColor: AppColors.PRIMARY_COLOR,
                  style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
                  controller: _expiryMonthController,
                  decoration: InputDecoration(
                    labelText: 'Expiry Month',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _expiryYearController,
                  cursorColor: AppColors.PRIMARY_COLOR,
                  style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
                  decoration: InputDecoration(
                    labelText: 'Expiry Year',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _cvvController,
            cursorColor: AppColors.PRIMARY_COLOR,
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
            decoration: InputDecoration(
              labelText: 'CVV',
              labelStyle: const TextStyle(color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
            maxLength: 4,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            obscureText: true,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppButton(
                    height: 44,
                    label: LocaleKeys.payWithCard.localize,
                    style: Styles.headerText(
                      fontWeight: FontWeight.w700,
                      color: AppColors.LIGHT_COLOR,
                      fontSize: 24,
                    ),
                    backColor: AppColors.c0B1035,
                    onPressed: () {
                      print("Ok");
                      _handlePayWithCard();
                    }),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: AppButton(
                  height: 44,
                  label: LocaleKeys.saveCard.localize,
                  style: Styles.headerText(
                    fontWeight: FontWeight.w700,
                    color: AppColors.LIGHT_COLOR,
                    fontSize: 24,
                  ),
                  backColor: AppColors.c0B1035,
                  onPressed: () async {
                    print("Yes");

                    // Call the method to save the card token
                    await paymentCubit.saveCardToken(
                      cardNumber: _cardNumberController.text,
                      cardExpiryYear: _expiryYearController.text,
                      cardExpiryMonth: _expiryMonthController.text,
                      cardAlias: _cardAlias.text,
                      cvv: _cvvController.text,
                    );
                    paymentCubit.getSavedCards();
                    await Future.delayed(const Duration(milliseconds: 500));

                    final state = context.read<PaymentCubit>().state;

                    if (state.status == StateStatus.success &&
                        state.fawryCardTokenResponseData != null) {
                      final message =
                          state.fawryCardTokenResponseData?.message ??
                              'No message available';
                      showAnimatedDialog(
                        context,
                        AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text(
                              'Are you sure you want to delete this card?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text('Delete'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      );

                      //     showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return AlertDialog(
                      //       title: const Text('Success'),
                      //       content: Text('Payment was successful: $message'),
                      //       actions: <Widget>[
                      //         TextButton(
                      //           onPressed: () {
                      //             Navigator.of(context).pop();
                      //           },
                      //           child: const Text('OK'),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );
                    } else if (state.status == StateStatus.error) {
                      final message =
                          state.fawryCardTokenResponseData?.message ??
                              'No error message available';
                      final statusDescription = state.fawryCardTokenResponseData
                              ?.data.statusDescription ??
                          'No description available';
                      showAnimatedDialog(
                        context,
                        AlertDialog(
                          title: const Text('Error'),
                          content: Text(
                              'Payment failed: $message\nStatus Description: $statusDescription'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );

                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return AlertDialog(
                      //       title: const Text('Error'),
                      //       content: Text(
                      //           'Payment failed: $message\nStatus Description: $statusDescription'),
                      //       actions: <Widget>[
                      //         TextButton(
                      //           onPressed: () {
                      //             Navigator.of(context).pop();
                      //           },
                      //           child: const Text('OK'),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: AppButton(
                  height: 44,
                  label: LocaleKeys.cancel.localize,
                  style: Styles.headerText(
                    fontWeight: FontWeight.w700,
                    color: AppColors.LIGHT_COLOR,
                    fontSize: 24,
                  ),
                  backColor: AppColors.SECONDARY_COLOR_DARK2,
                  onPressed: () {
                    setState(() {
                      _isAddingNewCard = false;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ],
    );
  }

  void _handlePayWithCard() async {
    final cubit = context.read<PaymentCubit>();

    final cardNumber = _cardNumberController.text;
    final cardExpiryMonth = _expiryMonthController.text;
    final cardExpiryYear = _expiryYearController.text;
    final cvv = _cvvController.text;

    await cubit.chargeWithCard(
      cardNumber: cardNumber,
      cardExpiryYear: cardExpiryYear,
      cardExpiryMonth: cardExpiryMonth,
      cvv: cvv,
      amountId: widget.amountId,
      providerId: widget.providerId,
      paymentMethod: "PayUsingCC",
    );

    setState(() {});

    final state = context.read<PaymentCubit>().state;

    if (state.status == StateStatus.success) {
      showAnimatedDialog(
        context,
        AlertDialog(
          title: const Text('Success'),
          content: Text(
              'Payment was successful: ${state.fawryPayWithCardData?.message ?? ''}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: const Text('Success'),
      //       content: Text(
      //           'Payment was successful: ${state.fawryPayWithCardData?.message ?? ''}'),
      //       actions: <Widget>[
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //           child: const Text('OK'),
      //         ),
      //       ],
      //     );
      //   },
      // );
    } else if (state.status == StateStatus.error) {
      showAnimatedDialog(
        context,
        AlertDialog(
          title: const Text('Error'),
          content: const Text('Payment failed:'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: const Text('Error'),
      //       content: const Text('Payment failed:'),
      //       actions: <Widget>[
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //           child: const Text('OK'),
      //         ),
      //       ],
      //     );
      //   },
      // );
    }
  }

  Widget _paymentOptionButton({
    required VoidCallback onTap,
    required IconData icon,
    required String text,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 150.w,
        // Fixed width for all buttons
        height: 44,
        // Fixed height for all buttons
        // padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.r),
          color: isSelected
              ? Theme.of(context).primaryColor
              : AppColors.LIGHT_GRAY_COLOR,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: isSelected
                      ? Theme.of(context).scaffoldBackgroundColor
                      : AppColors.GREY_NORMAL_COLOR),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  text,
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                    color: isSelected
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Colors.black87,
                  ),
                  textAlign: TextAlign.center, // Center text horizontally
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentOptionButton2({
    required VoidCallback onTap,
    required IconData icon,
    required String text,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color:
              isSelected ? AppColors.PRIMARY_COLOR : AppColors.LIGHT_GRAY_COLOR,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentNumber(PaymentData paymentData) {
    return Column(
      children: [
        const SizedBox(
          height: 32,
        ),
        Label(
          text: '${LocaleKeys.paymentNumber.localize}:',
          style: Styles.headerText(
            fontWeight: FontWeight.w700,
            fontSize: 32,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          paymentData.referenceNumber ?? LocaleKeys.noNumberAvailable.localize,
          style: Styles.headerText(
            fontWeight: FontWeight.w700,
            fontSize: 32,
            color: AppColors.cF33D49,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _paymentLink(PaymentData paymentData) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 32,
        ),
        Label(
          text: '${LocaleKeys.paymentLink.localize}:',
          textAlign: TextAlign.center,
          style: Styles.headerText(
            fontWeight: FontWeight.w700,
            fontSize: 32,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            final url = paymentData.link;
            if (url != null) {
              await launchUrl(Uri.parse(url));
            }
          },
          child: Text(
            paymentData.link ?? LocaleKeys.noLinkAvailable.localize,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: Styles.headerText(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0080F9),
              fontSize: 32,
              height: 1.6,
              decoration: TextDecoration.underline,
              decorationThickness: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _qrCode(PaymentCubit paymentCubit) {
    final qrCodeBase64 = paymentCubit.state.mutliPaymentResponse?.data.walletQr;
    if (qrCodeBase64 == null || qrCodeBase64.isEmpty) {
      return Column(
        children: [
          const SizedBox(
            height: 32,
          ),
          Label(
            text: '${LocaleKeys.qrCode.localize}:',
            style: Styles.headerText(
              fontWeight: FontWeight.w700,
              fontSize: 32,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 4),
          // Text('No QR code available'),
        ],
      );
    }

    Uint8List imageBytes;
    try {
      imageBytes = _decodeBase64Image(qrCodeBase64);
    } catch (e) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("QR Code:"),
            SizedBox(height: 10.h),
            const Text('Error decoding QR code'),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("QR Code:"),
          SizedBox(height: 10.h),
          Center(
            child: Image.memory(
              imageBytes,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Uint8List _decodeBase64Image(String base64String) {
    try {
      final String base64Data = base64String.split(',').last;
      return base64Decode(base64Data);
    } catch (e) {
      throw FormatException('Invalid base64 string', e);
    }
  }
}
