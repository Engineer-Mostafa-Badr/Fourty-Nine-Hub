import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/core/utils/date_time.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_subscription_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/button_subscription.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ExpandableSubscription extends StatelessWidget {
  const ExpandableSubscription({
    super.key,
    required this.subscription,
  });

  final WalletSubscriptionEntity subscription;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              // 'Talent (Regular)',
              context.locale == Locales.english
                  ? subscription.nameEn ?? '----'
                  : subscription.nameAr ?? '----',
              style: Styles.mediumText(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              formatDateTime(subscription.createdAt ?? '', context),
              style: Styles.mediumText(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff72BA88)),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        const Row(
          children: [
            ButtonSubscription(
              cancelColor: true,
            ),
            SizedBox(
              width: 8,
            ),
            ButtonSubscription(
              cancelColor: false,
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
