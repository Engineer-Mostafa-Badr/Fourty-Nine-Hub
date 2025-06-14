import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_history_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/cashback_cubit/cashback_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/history_wallet_list_view_item.dart';

class CashbackHistoriesListView extends StatefulWidget {
  const CashbackHistoriesListView({
    super.key,
    required this.histories,
  });

  final List<BalanceHistoryEntity> histories;

  @override
  State<CashbackHistoriesListView> createState() =>
      _CashbackHistoriesListViewState();
}

class _CashbackHistoriesListViewState extends State<CashbackHistoriesListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (!context.read<CashbackCubit>().state.hasReachedMax) {
            context.read<CashbackCubit>().getHistories(context);
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
    if (widget.histories.isEmpty) {
      return CustomEmptyWidget(
        label: LocaleKeys.noHistoryAvailable.localize,
      );
    } else {
      return ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: context.read<CashbackCubit>().state.hasReachedMax
            ? widget.histories.length
            : widget.histories.length + 1,
        itemBuilder: (context, index) {
          if (index < widget.histories.length) {
            final history = widget.histories[index];
            return HistoryWalletListViewItem(
              isReceived: history.received,
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
}
