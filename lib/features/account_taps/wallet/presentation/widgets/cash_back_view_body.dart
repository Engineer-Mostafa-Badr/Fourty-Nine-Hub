import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_history_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/header_total_account_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/history_wallet_list_view_item.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/icon_and_hint_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/with_drawal_button.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CashbackViewBody extends StatelessWidget {
  const CashbackViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderTotalAccountWidget(
            balance: '354',
            // state.wallet.realAmount.toString(),
            type: WalletTypes.balance,
          ),
          const SizedBox(
            height: 8,
          ),
          IconAndHintWidget(
            text:
                '${LocaleKeys.minimum.localize}1002 ${LocaleKeys.transaction.localize}',
          ),
          const SizedBox(
            height: 8,
          ),
          const WithDrawalButton(state: false
              // state.wallet.realAmount != null &&
              //     state.wallet.realAmount! >= 500,
              ),
          const SizedBox(
            height: 16,
          ),
          Label(
            text: 'History',
            style: Styles.headerText(
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20, //state.walletHistory?.length ?? 0,
              itemBuilder: (context, index) => HistoryWalletListViewItem(
                history: WalletHistoryEntity(
                  createdAt: '2023-07-01',
                  currency: '',
                  id: '',
                  received: false,
                  transactionAmount: 00.0,
                  internalPayment: '',
                  isPaid: index % 3 == 0,
                  status: '',
                  subCategoryId: '',
                  taxPrice: 00.0,
                  transactionPurpose: '',
                  userId: '',
                ),
                // state.walletHistory?[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
