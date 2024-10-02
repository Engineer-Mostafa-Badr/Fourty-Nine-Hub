import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(16.w),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            borderRadius: BorderRadius.circular(20.r),
            decoration: const InputDecoration(labelText: 'Choose InstaPay Option'),
            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
            items: const [
              DropdownMenuItem(
                value: 'instapay',
                child: Text('InstaPay Account'),
              ),
              DropdownMenuItem(
                value: 'phone',
                child: Text('Phone Number'),
              ),
              DropdownMenuItem(
                value: 'bank',
                child: Text('Bank Account'),
              ),
              DropdownMenuItem(
                value: 'card',
                child: Text('Card Number'),
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
              decoration: const InputDecoration(
                labelText: 'InstaPay Username or Shortcut',
              ),
            ),
          ],
          if (selectedOption == 'phone') ...[
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            Row(
              children: [
                const Label(text: 'Type: '),
                Radio(
                  value: true,
                  groupValue: isPhoneWallet,
                  onChanged: (value) {
                    setState(() {
                      isPhoneWallet = value!;
                    });
                  },
                ),
                const Label(text: 'Wallet'),
                Radio(
                  value: false,
                  groupValue: isPhoneWallet,
                  onChanged: (value) {
                    setState(() {
                      isPhoneWallet = value!;
                    });
                  },
                ),
                const Label(text: 'Account'),
              ],
            ),
          ],
          if (selectedOption == 'bank') ...[
            TextFormField(
              controller: bankAccountController,
              decoration: const InputDecoration(
                labelText: 'Bank Account Number',
              ),
            ),
            TextFormField(
              controller: bankNameController,
              decoration: const InputDecoration(
                labelText: 'Bank Name',
              ),
            ),
          ],
          if (selectedOption == 'card') ...[
            TextFormField(
              controller: cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Card Number',
              ),
            ),
          ],
          const Sizer(),
          InkWell(
            onTap:()=>  _submitForm(),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 20.h,
                horizontal: 100.w
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Theme.of(context).primaryColor
              ),
              child:  Label(text: 'Submit',color: Theme.of(context).scaffoldBackgroundColor,),
            ),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     _submitForm();
          //   },
          //   child: Text('Submit'),
          // ),
        ],
      ),
    );
  }

  void _submitForm() {
    String result = '';

    if (selectedOption == 'instapay') {
      result = 'InstaPay: ${instaPayController.text}';
    } else if (selectedOption == 'phone') {
      result =
      'Phone: ${phoneController.text}, Type: ${isPhoneWallet ? 'Wallet' : 'Account'}';
    } else if (selectedOption == 'bank') {
      result =
      'Bank Account: ${bankAccountController.text}, Bank: ${bankNameController.text}';
    } else if (selectedOption == 'card') {
      result = 'Card Number: ${cardNumberController.text}';
    }

    // Show result in a dialog
    if (result.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Label(text: 'Submitted Data'),
            content: Text(result),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Label(text: 'OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
