import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_history_entity.dart';

import '../cubit/wallet_two_cubit/wallet_two_cubit.dart';
import 'history_wallet_list_view_item.dart';

class HistoryWalletSliverList extends StatelessWidget {
  const HistoryWalletSliverList({
    super.key,
    required this.walletHistories,
  });

  final List<WalletHistoryEntity> walletHistories;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: context.read<WalletTwoCubit>().state.hasReachedMax
          ? walletHistories.length
          : walletHistories.length + 1,
      itemBuilder: (context, index) {
        if (index < walletHistories.length) {
          final history = walletHistories[index];
          return HistoryWalletListViewItem(
            isReceived: history.received == true,
            amount: history.transactionAmount.toString(),
            date: history.createdAt,
          );
        } else {
          return const CustomLoading();
        }
      },
    );
  }
}
