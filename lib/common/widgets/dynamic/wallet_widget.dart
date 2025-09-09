import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/ads/interstitial_ad_model.dart';
import 'package:fourtyninehub/common/widgets/dynamic/wallet_widget_screen.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/locale_keys.g.dart';
import '../../../features/payment/presentation/cache_out_cubit/payment_cubit.dart';
import '../../../res/style/app_colors.dart';
import '../../../res/style/styles.dart';
import '../stateless/labels/label.dart';
import 'sizer.dart';

class WalletWidget extends StatefulWidget {
  const WalletWidget({
    super.key,
    this.margin,
    this.details = false,
    this.onBalanceClicked,
    this.onGiftClicked,
    this.onWalletClicked,
  });

  final double? margin;
  final bool details;
  final Function(BuildContext context)? onBalanceClicked;
  final Function(BuildContext context)? onWalletClicked;
  final Function(BuildContext context)? onGiftClicked;

  @override
  State<WalletWidget> createState() => _WalletWidgetState();
}

class _WalletWidgetState extends State<WalletWidget> {
  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    return WalletWidgetScreen(
      margin: widget.margin,
      details: widget.details,
      onBalanceClicked:(data) {
        if(widget.onBalanceClicked != null)widget.onBalanceClicked!(data);
      },
      onGiftClicked: (data){
    if(widget.onGiftClicked != null)widget.onGiftClicked!(data);
    },
      onWalletClicked: (data){
    if(widget.onWalletClicked != null)widget.onWalletClicked!(data);
    },
    );

  }

  Widget buildItem(Function function, String title, String amount, currency) =>
      Expanded(
        child: InkWell(
          onTap: () {
            ManageVibration.vibrate();
            function();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: title,
                style: Styles.mediumText(
                  fontWeight: FontWeight.bold,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Label(
                      text: amount.toString(),
                      style: Styles.mediumText(
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Label(
                      text: currency,
                      style: Styles.mediumText(
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.SECONDARY_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
