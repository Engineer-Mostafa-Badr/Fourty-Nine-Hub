import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
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

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _paymentOptions(paymentCubit),
          if (paymentCubit.state.status == StateStatus.loading)
            const CircularProgressIndicator(),
          if (_isCardSelected) _creditCardPayment(),
          if (_showNumber && paymentData != null) _paymentNumber(paymentData),
          if (_showQrCode && paymentData != null) _qrCode(paymentCubit),
          if (_showLink && paymentData != null) _paymentLink(paymentData),
        ],
      ),
    );
  }

  Widget _paymentOptions(PaymentCubit paymentCubit) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
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
              const Sizer(),
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
        ),
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
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
              const Sizer(),
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
                      bool? confirm = await showAnimatedDialog(context,AlertDialog(
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

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (paymentCubit.state.savedCardsData != null &&
              paymentCubit.state.savedCardsData!.isNotEmpty)
            _buildSavedCardsList(
                paymentCubit, paymentCubit.state.savedCardsData!),
          SizedBox(height: 16.h),
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
            height: 70.h,
            color: AppColors.LIGHT_COLOR,
            label: _isAddingNewCard ? 'Hide Card Form' : 'Add New Card',
            backColor: AppColors.PRIMARY_COLOR_DARK,
            onPressed: () {
              setState(() {
                _isAddingNewCard = !_isAddingNewCard;
              });
            },
          ),
          if (_isAddingNewCard) ...[
            CreditCardWidget(
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
            SizedBox(height: 16.h),
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
            SizedBox(height: 16.h),
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
            SizedBox(height: 16.h),
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
            SizedBox(height: 16.h),
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
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                      height: 50.h,
                      color: AppColors.LIGHT_COLOR,
                      label: "Pay With Card",
                      backColor: AppColors.PRIMARY_COLOR,
                      onPressed: () {
                        print("Ok");
                        _handlePayWithCard();
                      }),
                ),
                const Sizer(
                  width: 5,
                ),
                Expanded(
                  child: AppButton(
                    height: 50.h,
                    color: AppColors.LIGHT_COLOR,
                    label: "Save Card",
                    backColor: AppColors.PRIMARY_COLOR,
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
                        showAnimatedDialog(context,AlertDialog(
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
                        ),);

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
                        final statusDescription = state
                                .fawryCardTokenResponseData
                                ?.data
                                .statusDescription ??
                            'No description available';
                        showAnimatedDialog(context,AlertDialog(
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
                        ),);

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
                const Sizer(
                  width: 5,
                ),
                Expanded(
                  child: AppButton(
                    height: 50.h,
                    color: AppColors.LIGHT_COLOR,
                    label: "Cancel",
                    backColor: AppColors.PRIMARY_COLOR_DARK,
                    onPressed: () {
                      setState(() {
                        _isAddingNewCard = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
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
      showAnimatedDialog(context,AlertDialog(
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
      ),);

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
      showAnimatedDialog(context,AlertDialog(
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
      ),);

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
        height: 80.h,
        // Fixed height for all buttons
        padding: EdgeInsets.symmetric(horizontal: 10.w),
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
              const Sizer(),
              Flexible(
                child: Text(
                  text,
                  style: Styles.mediumText(
                      color: isSelected
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Colors.black87),
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("Payment Number:"),
          SizedBox(height: 10.h),
          Text(
            paymentData.referenceNumber ?? 'No number available',
            style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.PRIMARY_COLOR_DARK),
          ),
        ],
      ),
    );
  }

  Widget _paymentLink(PaymentData paymentData) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Payment Link:"),
          SizedBox(height: 10.h),
          InkWell(
            onTap: () async {
              final url = paymentData.link;
              if (url != null) {
                await launchUrl(Uri.parse(url));
              }
            },
            child: Text(
              paymentData.link ?? 'No link available',
              style: TextStyle(
                fontSize: 25.sp,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qrCode(PaymentCubit paymentCubit) {
    final qrCodeBase64 = paymentCubit.state.mutliPaymentResponse?.data.walletQr;
    if (qrCodeBase64 == null || qrCodeBase64.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("QR Code:"),
            SizedBox(height: 10.h),
            // Text('No QR code available'),
          ],
        ),
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
