import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_subscription_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/subscription_wallet_cubit/subscription_wallet_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/expandable_subscription.dart';

class MySubscriptionListView extends StatelessWidget {
  const MySubscriptionListView({
    super.key,
    required this.subscriptions,
  });

  final List<WalletSubscriptionEntity> subscriptions;

  @override
  Widget build(BuildContext context) {
    subscriptions.sort((a, b) => a.isActive != b.isActive
        ? a.isActive!
            ? -1
            : 1
        : a.isPremium != b.isPremium
            ? a.isPremium!
                ? -1
                : 1
            : 0);
    if (subscriptions.isEmpty) {
      return CustomEmptyWidget(
        label: LocaleKeys.noSubscription.localize,
      );
    } else {
      return ListView.builder(
        itemCount: subscriptions.length,
        itemBuilder: (context, index) {
          return BlocBuilder<SubscriptionWalletCubit, SubscriptionWalletState>(
            builder: (context, state) {
              return ExpandableSubscription(
                subscription: subscriptions[index],
              );
            },
          );
        },
      );
    }
  }
}
