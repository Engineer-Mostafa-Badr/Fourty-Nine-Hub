import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/entities/transfer_money_entity.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class TransactionSuccessScreen extends StatefulWidget {
  const TransactionSuccessScreen({super.key, required this.model});

  final TransferMoneyEntity model;

  @override
  _TransactionSuccessScreenState createState() =>
      _TransactionSuccessScreenState();
}

class _TransactionSuccessScreenState extends State<TransactionSuccessScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _takeScreenshotAndShare() async {
    final image = await screenshotController.capture();
    if (image != null) {
      // Save the captured image temporarily to the device
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/transaction_screenshot.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      // Show the share dialog with options
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: LocaleKeys.transactionSuccessful.localize,
        subject: LocaleKeys.shareTransactionDetails.localize,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.transactionSuccessful.localize,
      ),
      body: Column(
        children: [
          Expanded(
            child: Screenshot(
              controller: screenshotController,
              child: Container(
               // padding: const EdgeInsets.all(16.0),
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
                        LocaleKeys.yourTransactionWasSuccessful.localize,
                        style: Styles.mediumText(),
                      ),
                      const Sizer(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${widget.model.amount} ',
                              style: TextStyle(
                                fontSize: 100.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.model.currency,
                              style: TextStyle(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.SECONDARY_COLOR,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Sizer(height: 15.h),
                      Text(
                        LocaleKeys.transferMoney.localize,
                        style: TextStyle(
                          fontSize: 30.sp,
                        ),
                      ),
                      const Sizer(),
                      ListTile(
                        leading: Image.asset(
                          Assets.logo,
                          width: 80.w,
                          height: 80.h,
                        ),
                        title: Text(LocaleKeys.from.localize),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@${widget.model.fromEmail.split('@')[0]}',
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.model.from,
                              style: Styles.mediumText(),
                            ),
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
                            child: Icon(Icons.check,
                                color: Colors.green, size: 22),
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
                          LocaleKeys.to.localize,
                          style: Styles.mediumText(),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@${widget.model.toEmail.split('@')[0]}',
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.model.to,
                              style: Styles.mediumText(),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        // trailing: Text(
                        //   '${LocaleKeys.date.localize}: ${widget.model.date}',
                        //   //widget.model.date,
                        //   style: Styles.headerText(),
                        // ),
                        title: Row(
                          children: [
                            Text(
                              '${LocaleKeys.date.localize}: ',
                              style: Styles.headerText(fontWeight: FontWeight.w400,color: AppColors.GREY_NORMAL_COLOR),
                            ),
                            Text(
                              widget.model.date,
                              style: Styles.headerText(),
                            ),
                          ],
                        ),
                      ),
                      Sizer(height: 70.h),
                      // Powered by Logo
                      Image.asset(
                        Assets.logo,
                        width: 180.w,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _takeScreenshotAndShare,
              icon: const Icon(
                Icons.share,
                color: AppColors.AUTH_CONTAINER_COLOR,
              ),
              label: Text(
                LocaleKeys.share.localize,
                style: Styles.mediumText(color: AppColors.AUTH_CONTAINER_COLOR),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
