import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/entities/transfer_money_entity.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/presentation/pages/widgets/check_divider_widget.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/presentation/pages/widgets/transfer_list_tile_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class TransactionSuccessScreen extends StatefulWidget {
  const TransactionSuccessScreen({super.key, required this.dataEntity});

  final TransferMoneyEntity dataEntity;

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
    return CustomScaffold(
      backgroundColor: context.isDarkMode ? Color(0xff0D0D0D) : null,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.transactionSuccessful.localize,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Screenshot(
              controller: screenshotController,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Success Icon
                    Image.asset(
                      height: 150,
                      width: 150,
                      context.isDarkMode
                          ? Assets.checkSuccessImageDark
                          : Assets.checkSuccessImage,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Label(
                      text: LocaleKeys.yourTransactionWasSuccessful.localize,
                      style: Styles.headerText(
                        fontSize: 40,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: '${widget.dataEntity.amount} ',
                          style: Styles.headerText(
                            color: context.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontSize: 48 + 48,
                            fontWeight: FontWeight.w700,
                            height: 1.33,
                          ),
                        ),
                        TextSpan(
                          text: context.isArabic
                              ? widget.dataEntity.currencyAr
                              : widget.dataEntity.currencyEn,
                          style: Styles.headerText(
                            color: AppColors.SECONDARY_COLOR_DARK2,
                            fontSize: 36 + 36,
                            fontWeight: FontWeight.w700,
                            height: 1.78,
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Label(
                      text: LocaleKeys.transferMoney.localize,
                      style: Styles.headerText(
                        fontWeight: FontWeight.w500,
                        fontSize: 40,
                        height: 1.60,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TransferListTileWidget(
                      title: LocaleKeys.from.localize,
                      mail: '@${widget.dataEntity.fromEmail.split('@')[0]}',
                      name: widget.dataEntity.from,
                      image: Image.asset(Assets.logo),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const CheckDividerWidget(),
                    const SizedBox(
                      height: 8,
                    ),
                    // To Section
                    TransferListTileWidget(
                      title: LocaleKeys.to.localize,
                      mail: '@${widget.dataEntity.toEmail.split('@')[0]}',
                      name: widget.dataEntity.to,
                      image: SvgPicture.asset(
                        context.isDarkMode
                            ? Assets.walletImageDark
                            : Assets.walletImage,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 29),
                      child: Row(
                        children: [
                          Label(
                            text: '${LocaleKeys.date.localize}: ',
                            style: Styles.headerText(
                              fontWeight: FontWeight.w500,
                              color: context.isDarkMode
                                  ? const Color(0x99FFFFFF)
                                  : const Color(0x993C3C43),
                            ),
                          ),
                          Label(
                            text: context.isArabic
                                ? widget.dataEntity.dateAr
                                : widget.dataEntity.dateEn,
                            style: Styles.headerText(
                              fontSize: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ListTile(
                    //   // trailing: Text(
                    //   //   '${LocaleKeys.date.localize}: ${widget.model.date}',
                    //   //   //widget.model.date,
                    //   //   style: Styles.headerText(),
                    //   // ),
                    //   title: Row(
                    //     children: [
                    //       Text(
                    //         '${LocaleKeys.date.localize}: ',
                    //         style: Styles.headerText(
                    //             fontWeight: FontWeight.w400,
                    //             color: AppColors.GREY_NORMAL_COLOR),
                    //       ),
                    //       Text(
                    //         widget.model.date,
                    //         style: Styles.headerText(),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Powered by Logo
                    Image.asset(
                      height: 100,
                      width: 100,
                      Assets.logo,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppButton(
              width: 150,
              label: LocaleKeys.share.localize,
              style: Styles.headerText(
                color: context.isDarkMode ? Color(0xff0D0D0D) : Colors.white,
                fontSize: 40,
              ),
              onPressed: _takeScreenshotAndShare,
              iconWidget: SvgPicture.asset(
                context.isDarkMode ? Assets.share2IconDark : Assets.share2Icon,
              ),
              backColor: context.isDarkMode
                  ? const Color(0xffEF333C)
                  : const Color(0xffED1B24),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: ElevatedButton.icon(
          //     onPressed: _takeScreenshotAndShare,
          //     icon: const Icon(
          //       Icons.share,
          //       color: AppColors.AUTH_CONTAINER_COLOR,
          //     ),
          //     label: Text(
          //       LocaleKeys.share.localize,
          //       style: Styles.mediumText(color: AppColors.AUTH_CONTAINER_COLOR),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
