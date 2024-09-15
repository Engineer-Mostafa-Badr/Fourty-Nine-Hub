import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_subscription_entity.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/localization/locales.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../cubit/wallet_cubit.dart';

class SubscriptionWidget extends StatelessWidget {
  final WalletSubscriptionEntity subscription;

  const SubscriptionWidget({
    super.key,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime createdAt =
        subscription.isActive == true && subscription.isPremium == true
            ? DateTime.parse(subscription.expirePremium ?? '')
            : subscription.isActive == true ||
                    subscription.isActive == false &&
                        subscription.isPremium == false
                ? DateTime.parse(subscription.expireSubscription ?? '')
                : DateTime.parse(
                    subscription.expirePremium ?? '',
                  );
    // final DateTime createdAt = subscription.isActive == true ||
    //         subscription.isActive == false && subscription.isPremium == false
    //     ? DateTime.parse(subscription.expireSubscription ?? '')
    //     : DateTime.parse(subscription.expirePremium ?? '');
    final DateTime egyptTime = createdAt.toUtc().add(const Duration(hours: 3));
    final String formattedDateTime = DateFormat('dd/MM/yyyy').format(egyptTime);
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
                height: 30.h,
                width: 30,
                child: Image.network(subscription.picture ?? '')),
            Sizer(),
            Expanded(
                child: Row(
              children: [
                Label(
                    text: context.locale == Locales.english
                        ? subscription.nameEn ?? ''
                        : subscription.nameAr ?? ''),
                Sizer(
                  width: 5,
                ),
                Label(
                  text: subscription.isActive == true &&
                          subscription.isPremium == true
                      ? '(${LocaleKeys.premium.localize})'
                      : subscription.isActive == false &&
                              subscription.isPremium == false
                          ? '(${LocaleKeys.notSubscription.localize})'
                          : subscription.isActive == true
                              ? '(${LocaleKeys.regular.localize})'
                              : '(${LocaleKeys.premium.localize})',
                  color: AppColors.GREY_NORMAL_COLOR,
                )
                // Label(
                //   text: subscription.isActive == false &&
                //           subscription.isPremium == false
                //       ? '(${LocaleKeys.notSubscription.localize})'
                //       : subscription.isActive == true
                //           ? '(${LocaleKeys.regular.localize})'
                //           : '(${LocaleKeys.premium.localize})',
                //   color: AppColors.GREY_NORMAL_COLOR,
                // )
              ],
            )),
            Label(
              text: formattedDateTime,
              style: Styles.mediumText(
                color: subscription.isActive == true &&
                        subscription.isPremium == true
                    ? AppColors.WHATS_APP_COLOR
                    : subscription.isActive == false &&
                            subscription.isPremium == false
                        ? AppColors.SECONDARY_COLOR
                        : AppColors.WHATS_APP_COLOR,
              ),
            )
            // Label(
            //   text: formattedDateTime,
            //   style: Styles.mediumText(
            //       color: subscription.isActive == false &&
            //               subscription.isPremium == false
            //           ? AppColors.SECONDARY_COLOR
            //           : AppColors.WHATS_APP_COLOR),
            // )
          ],
        ),
        Sizer(
          height: 10.h,
        ),
        Row(
          children: [
            Expanded(
              child: buildContainer(
                color: AppColors.SECONDARY_COLOR,
                text: LocaleKeys.cancel.localize,
                textColor: AppColors.AUTH_CONTAINER_COLOR,
                function: () {
                  showAreYouSure(
                    title: LocaleKeys.areYouSure.localize,
                    subTitle: LocaleKeys.sureUnsubscribe.localize,
                    action: () {
                      context.read<WalletCubit>().deleteSubscription(
                            subscriptionId: subscription.subCategoryId!,
                          );
                    },
                    context: context,
                  );
                },
              ),
            ),
            Sizer(
              width: 5,
            ),
            Expanded(
              child: buildContainer(
                text: LocaleKeys.renewal.localize,
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).scaffoldBackgroundColor,
                function: () {
                  serviceLocator<SubscriptionController>()
                      .showSubscriptionPlans(
                    subCategoryId: subscription.subCategoryId!,
                    wallets: [],
                  );
                },
              ),
            ),
          ],
        ),
        Sizer(
          height: 15.h,
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
          padding: EdgeInsets.symmetric(vertical: 4.h),
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
