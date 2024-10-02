import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart'; // For image picking

class PaymentYellowCard extends StatefulWidget {
  const PaymentYellowCard({super.key});

  @override
  _PaymentYellowCardState createState() => _PaymentYellowCardState();
}

class _PaymentYellowCardState extends State<PaymentYellowCard> {
  bool hasYellowCard = true; // Whether the user already has a Yellow Card
  bool isRequestingYellowCard = false; // Whether the user is requesting a new Yellow Card
  double walletBalance = 600; // Example wallet balance
  final TextEditingController yellowCardNumberController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? frontIdImage;
  XFile? backIdImage;

  @override
  void dispose() {
    yellowCardNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickFrontIdImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      frontIdImage = pickedFile;
    });
  }

  Future<void> _pickBackIdImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      backIdImage = pickedFile;
    });
  }

  void _submitYellowCardRequest() {
    if (isRequestingYellowCard && walletBalance >= 300) {
      setState(() {
        walletBalance -= 50; // Deduct 50 EGP from the user's wallet
      });

      // Show confirmation message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Yellow Card Request'),
          content: Text(
              'Your Yellow Card request is successful! 50 has been deducted. You will receive a notification when your card is ready for pickup at any Fawry branch.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else if (walletBalance < 300) {
      // Show insufficient balance message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Insufficient Balance'),
          content: Text(
              'You need at least 300 EGP in your wallet to request a Yellow Card.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: const Label(text: "Do you have a Yellow Card?"),
            value: hasYellowCard,
            activeTrackColor: AppColors.SECONDARY_COLOR,
            inactiveTrackColor: AppColors.GREY_NORMAL_COLOR,
            onChanged: (value) {
              setState(() {
                hasYellowCard = value;
              });
            },
          ),
          if (hasYellowCard) ...[
            Column(
              children: [
                TextFormField(
                  controller: yellowCardNumberController,
                  decoration: InputDecoration(labelText: 'Yellow Card Number'),
                ),
                const Sizer(),
                InkWell(
                  onTap: () {}, // Add your submit logic here
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 100.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Label(
                      text: 'Submit',
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            InkWell(
              onTap: () {
                if (walletBalance >= 300) {
                  setState(() {
                    isRequestingYellowCard = true;
                  });
                } else {
                  // Show balance warning
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Insufficient Balance'),
                      content: Text('You need at least 300 to request a Yellow Card.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppColors.SECONDARY_COLOR,
                ),
                child: const Center(
                  child: Label(
                    text: 'Request Yellow Card (50 will be deducted)',
                    maxLines: 2,
                    color: AppColors.AUTH_CONTAINER_COLOR,
                  ),
                ),
              ),
            ),
          ],
          if (isRequestingYellowCard) ...[
            Sizer(height: 50.h),
            Text(
              'Upload Your ID (Front and Back):',
              style: Styles.mediumText(),
            ),
            Sizer(height: 5.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: _pickFrontIdImage, // Corrected invocation
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Center(
                            child: Label(
                              text: frontIdImage == null ? 'Upload Front ID' : 'Front ID Uploaded',
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                      if (frontIdImage != null)
                        Column(
                          children: [
                            Image.file(
                              File(frontIdImage!.path),
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 8.h), // Spacing below the image
                          ],
                        ),
                    ],
                  ),
                ),
                const Sizer(),
                Expanded(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: _pickBackIdImage, // Corrected invocation
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Center(
                            child: Label(
                              text: backIdImage == null ? 'Upload Back ID' : 'Back ID Uploaded',
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                      if (backIdImage != null)
                        Column(
                          children: [
                            Image.file(
                              File(backIdImage!.path),
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 8.h), // Spacing below the image
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Sizer(height: 30.h),
            InkWell(
              onTap: _submitYellowCardRequest, // Corrected invocation
              child: Container(
                alignment: AlignmentDirectional.center,
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 100.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Theme.of(context).primaryColor,
                ),
                child: Label(
                  text: 'Submit Yellow Card Request',
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
