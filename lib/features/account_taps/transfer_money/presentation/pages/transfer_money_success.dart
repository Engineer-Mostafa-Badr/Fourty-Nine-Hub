import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/entities/transfer_money_entity.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class TransactionSuccessScreen extends StatelessWidget {
  const TransactionSuccessScreen({super.key, required this.model});
  final TransferMoneyEntity model;

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
                      text: '${model.amount}',
                      style: TextStyle(
                        fontSize: 100.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: model.currency,
                      style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.SECONDARY_COLOR,
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
                      model.fromUsername,
                      style: Styles.mediumText(fontWeight: FontWeight.bold),
                    ),
                     Text(model.from,
                     style: Styles.mediumText(),
                     )
                  ],
                ),
              ),
             const Row(
               children: [
                 Expanded(
                   child: Divider(
                     color: AppColors.GREY_NORMAL_COLOR,
                   ),
                 ),
                 CircleAvatar(
                   radius: 15,
                   backgroundColor: AppColors.GREY_NORMAL_COLOR,
                   child: Icon(Icons.check,color: Colors.green,size: 22,),
                 ),
                 Expanded(
                   child: Divider(
                     color: AppColors.GREY_NORMAL_COLOR,
                   ),
                 ),
               ],
             ),
              // To Section
              ListTile(
                leading: Icon(Icons.account_balance_wallet,
                    size: 80.sp, color: Colors.orange),
                title: Text(
                  'To',
                  style: Styles.mediumText(),
                ),
                subtitle:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.toUsername,
                    style: Styles.mediumText(fontWeight: FontWeight.bold),
                    ),
                    Text(model.to,
                    style: Styles.mediumText(),
                    ),
                  ],
                ),
             //   trailing: const Icon(Icons.star_border, color: Colors.orange),
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
                  model.date,
                  style: Styles.headerText(),
                ),
                title: Text(
                  'Date: ',
                  style: Styles.headerText(fontWeight: FontWeight.w400),
                ),
              ),
              Sizer(height: 70.h,),
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
