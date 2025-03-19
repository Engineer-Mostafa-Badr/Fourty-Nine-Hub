import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/core/utils/date_time.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_subscription_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/button_subscription.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../../../../../common/widgets/stateless/dynamic/are_you_sure.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../cubit/subscription_wallet_cubit/subscription_wallet_cubit.dart';

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
         Row(
          children: [
            InkWell(
              onTap: () {
                showAreYouSure(
                  title: LocaleKeys.areYouSure.localize,
                  subTitle: LocaleKeys.sureUnsubscribe.localize,
                  action: () {
                    context.read<SubscriptionWalletCubit>().deleteSubscription(
                      subscriptionId: subscription.subCategoryId!,
                    );
                  },
                  context: context,
                );
              },
              child: const ButtonSubscription(
                cancelColor: true,
              ),
            ),
            const  SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                serviceLocator<SubscriptionController>()
                    .showSubscriptionPlans(
                    wallets: [
                      WalletTypes.mainWallet,
                    ],
                    subCategoryId: subscription.subCategoryId!,
                    title: context.locale == Locales.english
                        ? subscription.nameEn ?? ''
                        : subscription.nameAr ?? '');
              },
              child: const ButtonSubscription(
                cancelColor: false,
              ),
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
