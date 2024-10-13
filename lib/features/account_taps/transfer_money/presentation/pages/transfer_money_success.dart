import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class TransactionSuccessScreen extends StatelessWidget {
  const TransactionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Transaction Successful',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Success Icon
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 200.sp,
              ),
              const Sizer(),
              Text(
                'Your transaction was successful',
                style: Styles.mediumText(),
              ),
              const Sizer(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '1,000 ',
                      style: TextStyle(
                        fontSize: 60.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'EGP',
                      style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              Sizer(
                height: 15.h,
              ),
              Text(
                'Transfer Amount',
                style: TextStyle(fontSize: 30.sp, color: Colors.black54),
              ),
              const Sizer(),
              ListTile(
                leading: Image.asset(
                  Assets.logo, // Add the appropriate image asset here
                  width: 80.w,
                  height: 80.h,
                ),
                title: const Text('From'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'gemy3617@instapay',
                      style: Styles.mediumText(fontWeight: FontWeight.bold),
                    ),
                     Text('محمد جمال عباس عبدالموجود',
                     style: Styles.mediumText(),
                     )
                  ],
                ),
              ),
              const Divider(
                color: AppColors.GREY_NORMAL_COLOR,
              ),
              // To Section
              ListTile(
                leading: Icon(Icons.account_balance_wallet,
                    size: 80.sp, color: Colors.orange),
                title: Text(
                  'To Wallet',
                  style: Styles.mediumText(fontWeight: FontWeight.bold),
                ),
                subtitle:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Moaz M A*******',
                    style: Styles.mediumText(),
                    ),
                    Text('01023765247',
                    style: Styles.mediumText(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.star_border, color: Colors.orange),
              ),
              //  const Divider(),

              // Reference
              //  ListTile(
              //   trailing: Text('Reference',
              //   style: Styles.mediumText(),
              //   ),
              //   title: Text('Reference'),
              // ),
              ListTile(
                trailing: Text(
                  '31 Aug 2024 12:27 AM',
                  style: Styles.headerText(),
                ),
                title: Text(
                  'Date: ',
                  style: Styles.headerText(fontWeight: FontWeight.w400),
                ),
              ),

              // Note
               ListTile(
                title: Text('Note',
                style: Styles.headerText(fontWeight: FontWeight.w400),
                ),
                subtitle: Text('Living Expenses',
                  style: Styles.headerText(),
                ),
              ),

              const Sizer(),

              // Powered by Logo
              Image.asset(
                Assets.logo, // Add the appropriate image asset here
                width: 180.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
