import 'package:fourtyninehub/features/authentication/data/models/wallet_model.dart';

class GetWalletState {}

class GetWalletInitial extends GetWalletState{}

class SuccessGetWallet extends GetWalletState {
  final WalletModel model;

  SuccessGetWallet({required this.model});
}

class FilauerGetWallatState extends GetWalletState{}