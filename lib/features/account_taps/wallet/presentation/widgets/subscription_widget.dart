import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_subscription_entity.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/localization/locales.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class SubscriptionWidget extends StatelessWidget {
  final WalletSubscriptionEntity subscription;

  const SubscriptionWidget({
    super.key,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime createdAt = subscription.isActive == true
        ? DateTime.parse(subscription.expireSubscription ??'')
        : DateTime.parse(subscription.expirePremium ??'');
    final DateTime egyptTime = createdAt.toUtc().add(const Duration(hours: 3));
    final String formattedDateTime = DateFormat('dd/MM/yyyy').format(egyptTime);
    return Column(
      children: [
        Row(
          children: [
            SizedBox(height: 30, width: 30, child: Image.network(subscription.picture ??'')),
            const Sizer(),
            Expanded(
                child: Label(
                    text: context.locale == Locales.english
                        ? subscription.nameEn ??''
                        : subscription.nameAr ??'')),
            Label(
              text: formattedDateTime,
              style:
                  Styles.mediumText(color: subscription.isActive ==true ? Colors.red : Colors.green),
            )
          ],
        ),
         const Sizer(height: 10,),
        Row(
          children: [
            Expanded(
              child: buildContainer(
                text: 'Cancel',
                color: AppColors.SECONDARY_COLOR,
                textColor:
                AppColors.AUTH_CONTAINER_COLOR,
                function: () {},
              ),
            ),
            const Sizer(width: 5,),
            Expanded(
              child: buildContainer(
                text: 'renewal',
                color: Theme.of(context).primaryColor,
                textColor:
                Theme.of(context).scaffoldBackgroundColor,
                function: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildContainer({
    required String text,
    required Color color,
    required Color textColor,
    required Function function,
  }) =>
      GestureDetector(
        onTap: () {
          function();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Label(
              text: text,
              color: textColor,
            ),
          ),
        ),
      );
}
