import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../../res/style/app_colors.dart';

class NetworkAlertBanner extends StatelessWidget {
  final bool isConnected;

  const NetworkAlertBanner({required this.isConnected, super.key});

  @override
  Widget build(BuildContext context) {
    if (isConnected) return const SizedBox.shrink();

    return Container(
      color: AppColors.PRIMARY_COLOR_DARK,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child:  Text(
        LocaleKeys.noInternetConnection.tr(),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}