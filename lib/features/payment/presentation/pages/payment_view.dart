


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/features/payment/presentation/cubit/payment_cubit.dart';

import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  String _selectedPaymentMethod = '';
  List<Map<String, String>> _savedCards = [];
  String? _selectedCard;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final FocusNode _cvvFocusNode = FocusNode();
  bool _isAddingNewCard = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCards();
    _cvvFocusNode.addListener(() {
      setState(() {});
    });
  }

  Future<void> _loadSavedCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cards = prefs.getStringList('savedCards');
    if (cards != null) {
      setState(() {
        _savedCards = cards.map((card) {
          List<String> cardDetails = card.split(',');
          return {
            'last4': cardDetails[0],
            'expiry': cardDetails[1],
          };
        }).toList();
      });
    }
  }

  Future<void> _saveCardDetails(String last4, String expiry) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _savedCards.add({'last4': last4, 'expiry': expiry});
    List<String> cards = _savedCards
        .map((card) => '${card['last4']},${card['expiry']}')
        .toList();
    await prefs.setStringList('savedCards', cards);

    setState(() {});
  }

  Future<void> _deleteCard(String last4) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _savedCards.removeWhere((card) => card['last4'] == last4);
    List<String> cards = _savedCards
        .map((card) => '${card['last4']},${card['expiry']}')
        .toList();
    await prefs.setStringList('savedCards', cards);
    setState(() {});
  }

  void _handleSaveCard() {
    String cardNumber = _cardNumberController.text;
    String expiryDate = _expiryDateController.text;
    String last4 = cardNumber.isNotEmpty ? cardNumber.substring(cardNumber.length - 4) : '';

    if (cardNumber.isNotEmpty && expiryDate.isNotEmpty) {
      _saveCardDetails(last4, expiryDate);

      _cardNumberController.clear();
      _expiryDateController.clear();
      _cvvController.clear();

      setState(() {
        _isAddingNewCard = false;
      });
    }
  }

  void _onCardSelected(String last4) {
    setState(() {
      _selectedCard = last4;
    });
  }

  void _onNextPressed() {
    if (_selectedCard != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentConfirmationView(selectedCard: _selectedCard!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Options'),
      ),
      body: BlocBuilder<PaymentCubit, PaymentState>(
  builder: (context, state) {
    return SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                _buildCustomCard('Credit Card', Icon(Icons.credit_card), Colors.blue, 'Enter your credit card details'),
                _buildCustomCard('Fawry', Image.asset(Assets.fawry,fit: BoxFit.cover,), Colors.orange, 'Enter your Paymob link'),
                _buildCustomCard('Bank Transfer', Icon(Icons.account_balance), Colors.green, 'Enter your bank account details'),
              ],
            ),
            const SizedBox(height: 20.0),
            _buildPaymentBody(),
            if (_selectedPaymentMethod == 'Credit Card') ...[
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.PRIMARY_COLOR
                ),
                onPressed: _onNextPressed,
                child: const Text('Next',style: TextStyle(
                  color:  AppColors.LIGHT_COLOR,
                ),),
              ),
            ],
          ],
        ),
      );
  },
),
    );
  }

  Widget _buildCustomCard(String title, Widget icon, Color color, String details) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = title;
          });
        },
        child: Container(
          height: 130,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
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
             Spacer(),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentBody() {
    switch (_selectedPaymentMethod) {
      case 'Credit Card':
        return _creditCardPayment();
      case 'Fawry':
        return _fawryPayment();
      case 'Bank Transfer':
        return _bankTransferPayment();
      default:
        return const Center(
          child: Text('Please select a payment method.'),
        );
    }
  }

  Widget _creditCardPayment() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (_savedCards.isNotEmpty) _buildSavedCardsList(),
          const SizedBox(height: 16.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isAddingNewCard ?  AppColors.PRIMARY_COLOR_DARK  :AppColors.PRIMARY_COLOR
            ),
            onPressed: () {
              setState(() {
                _isAddingNewCard = !_isAddingNewCard;
              });
            },
            child: Text(_isAddingNewCard ? 'Hide Card Form' : 'Add New Card',style: const TextStyle(
              color: AppColors.LIGHT_COLOR

            ),),
          ),
          if (_isAddingNewCard) ...[
            CreditCardWidget(
              cardBgColor: Colors.black,
              cardNumber: _cardNumberController.text,
              expiryDate: _expiryDateController.text,
              cardHolderName: '',
              cvvCode: _cvvController.text,
              showBackView: _cvvFocusNode.hasFocus,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: false,
              isChipVisible: true,
              onCreditCardWidgetChange: (CreditCardBrand) {},
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Credit Card Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
              ],
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _expiryDateController,
              decoration: const InputDecoration(
                labelText: 'Expiry Date',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
              inputFormatters: [
                LengthLimitingTextInputFormatter(5),
              ],
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _cvvController,
              focusNode: _cvvFocusNode,
              decoration: const InputDecoration(
                labelText: 'CVV',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              obscureText: true,
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:AppColors.PRIMARY_COLOR
              ),
              onPressed: _handleSaveCard,
              child: const Text("Save Card",style: TextStyle(
                  color: AppColors.LIGHT_COLOR

              ),),
            ),
            ElevatedButton(
              onPressed: (){
                setState(() {
                  _isAddingNewCard = false;
                });
              },
              child:  const Text('Cancel',style: TextStyle(
                color: AppColors.LIGHT_COLOR
              ),),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSavedCardsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _savedCards.length,
      itemBuilder: (context, index) {
        final card = _savedCards[index];
        final last4 = card['last4']!;
        final expiry = card['expiry']!;

        return ListTile(
          leading: const Icon(
            Icons.credit_card,
            color: Colors.blue,
          ),
          title: Text('Card ending in $last4'),
          subtitle: Text('Expires $expiry'),
          trailing: _selectedCard == last4
              ? const Icon(Icons.check, color: Colors.green)
              : IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteCard(last4),
          ),
          onTap: () => _onCardSelected(last4),
        );
      },
    );
  }

  Widget _fawryPayment() {
    final TextEditingController _fawryLinkController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          FormTextField(
            controller: _fawryLinkController,
            label: "Fawry Link",
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.PRIMARY_COLOR
            ),
            onPressed: () {
              final fawryLink = _fawryLinkController.text;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentConfirmationView(selectedCard: fawryLink),
                ),
              );
            },
            child: const Text('Next',style: TextStyle(color: AppColors.LIGHT_COLOR),),
          ),
        ],
      ),
    );
  }

  Widget _bankTransferPayment() {
    final TextEditingController _bankNameController = TextEditingController();
    final TextEditingController _accountNumberController = TextEditingController();

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
            decoration: const InputDecoration(
              fillColor: Colors.white,
              labelText: 'Select Phone Number',
            ),

            dropdownColor: Colors.blue.withOpacity(0.5),
            items: phoneNumbers.map((phone) {
              return DropdownMenuItem<String>(
                value: phone,
                child: Text(phone),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                _bankNameController.text = value;
              }
            },
          ),
          const SizedBox(height: 16.0),
          FormTextField(
            controller: _accountNumberController,
            label:  'Account Number',
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Handle bank transfer details submission
              final phoneNumber = _bankNameController.text;
              final accountNumber = _accountNumberController.text;
              print(phoneNumber);
              print(accountNumber);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }


}

class PaymentConfirmationView extends StatelessWidget {
  final String selectedCard;

  const PaymentConfirmationView({required this.selectedCard, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Payment'),
      ),
      body: Center(
        child: Text('You have selected card ending in $selectedCard'),
      ),
    );
  }
}
