import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
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

  String _getTitle(
      BuildContext context, WalletSubscriptionEntity subscription) {
    final String name = context.isArabic
        ? subscription.nameAr ?? '----'
        : subscription.nameEn ?? '----';
    final String type = subscription.isActive!
        ? (subscription.isPremium!
            ? LocaleKeys.premium.localize
            : LocaleKeys.regular.localize)
        : LocaleKeys.notSubscription.localize;
    return '$name ($type)';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Label(
                text: _getTitle(context, subscription),
                style: Styles.mediumText(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Label(
              text: formatDateTime(subscription.createdAt ?? '', context),
              style: Styles.mediumText(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: subscription.isActive!
                    ? const Color(0xff72BA88)
                    : const Color(0xffF33D49),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  bottomSheet(
                      context: context,
                      isFloating: true,
                      asAlertDialog: true,
                      widget: AreYouSure(
                        title: LocaleKeys.areYouSure.localize,
                        subTitle: LocaleKeys.sureUnsubscribe.localize,
                        action: () {
                          context
                              .read<SubscriptionWalletCubit>()
                              .deleteSubscription(
                                subscriptionId: subscription.subCategoryId!,
                              );
                        },
                      ));
                },
                child: const ButtonSubscription(
                  cancelColor: true,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: InkWell(
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
