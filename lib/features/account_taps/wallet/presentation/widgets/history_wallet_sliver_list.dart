import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_history_entity.dart';

import '../cubit/wallet_two_cubit/wallet_two_cubit.dart';
import 'history_wallet_list_view_item.dart';

class HistoryWalletSliverList extends StatefulWidget {
  const HistoryWalletSliverList({
    super.key,
    required this.walletHistories,
  });

  final List<WalletHistoryEntity> walletHistories;

  @override
  State<HistoryWalletSliverList> createState() => _HistoryWalletSliverListState();
}

class _HistoryWalletSliverListState extends State<HistoryWalletSliverList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
          () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (!context.read<WalletTwoCubit>().hasReachedMax) {
            context.read<WalletTwoCubit>().getHistories();
          }
        }
      },
    );
  }


  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: widget.walletHistories.length,
      itemBuilder: (context, index) {
        final history = widget.walletHistories[index];
        return HistoryWalletListViewItem(
          isReceived: history.received == true,
          amount: history.transactionAmount.toString(),
          date: history.createdAt,
        );
      },
    );
  }
}
