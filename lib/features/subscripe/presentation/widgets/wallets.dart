import 'package:flutter/material.dart';
import '../../../../core/enums/wallet_types_enums.dart';
import '../../../../helpers/manage_vibration.dart';

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
      ManageVibration.vibrate();

            },
          ),
        );
      },
    );
  }
}