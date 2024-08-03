import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/subscripe/presentation/cubit/subscribe_cubit.dart';

class WalletsWedgit extends StatelessWidget {
  final List<WalletTypes> wallets;
  const WalletsWedgit({super.key, required this.wallets});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: wallets.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(wallets[index].translatedName),
            onTap: () {
              context.read<SubscribeCubit>().showActiveSubscriptionAmounts();
            },
          ),
        );
      },
    );
  }
}
