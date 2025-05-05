import 'package:fourtyninehub/features/account_taps/transfer_money/domain/entities/transfer_money_entity.dart';

import '../../../../../core/error/failure.dart';
import '../../../wallet/domain/entities/wallet/wallet_entity.dart';
import '../../domain/entities/user_transfer_money_entity.dart';

enum TransferMoneyStates {
  initial,
  loading,
  failure,
  success,
}

extension TransferMoneyStatesX on TransferMoneyState {
  bool get isInitial => status == TransferMoneyStates.initial;
  bool get isLoading => status == TransferMoneyStates.loading;
  bool get isFailure => status == TransferMoneyStates.failure;
  bool get isSuccess => status == TransferMoneyStates.success;
  bool get isSearchUserInitial =>
      searchUserStatus == TransferMoneyStates.initial;
  bool get isSearchUserLoading =>
      searchUserStatus == TransferMoneyStates.loading;
  bool get isSearchUserSuccess =>
      searchUserStatus == TransferMoneyStates.success;
  bool get isSearchUserFailure =>
      searchUserStatus == TransferMoneyStates.failure;
  bool get isTransferInitial => transferStatus == TransferMoneyStates.initial;
  bool get isTransferLoading => transferStatus == TransferMoneyStates.loading;
  bool get isTransferSuccess => transferStatus == TransferMoneyStates.success;
  bool get isTransferFailure => transferStatus == TransferMoneyStates.failure;
}

class TransferMoneyState {
  final TransferMoneyStates status;
  final TransferMoneyStates searchUserStatus;
  final TransferMoneyStates transferStatus;
  // final bool loadingInitial;
  // final bool transferLoading;
  final Failure? failure;
  final List<UserTransferMoneyEntity>? users;
  final UserTransferMoneyEntity? userSelected;
  final WalletEntity? wallet;
  final TransferMoneyEntity? dataTransfer;
  final String userSelectedEmail;

  const TransferMoneyState({
    this.status = TransferMoneyStates.initial,
    this.searchUserStatus = TransferMoneyStates.initial,
    this.transferStatus = TransferMoneyStates.initial,
    // this.searchUserLoading = false,
    // this.loadingInitial = false,
    // this.transferLoading = false,
    this.failure,
    this.users,
    this.wallet,
    this.dataTransfer,
    this.userSelected,
    this.userSelectedEmail = '',
  });
  TransferMoneyState copyWith({
    TransferMoneyStates? status,
    TransferMoneyStates? searchUserStatus,
    TransferMoneyStates? transferStatus,
    // bool? searchUserLoading,
    // bool? loadingInitial,
    // bool? transferLoading,
    Failure? failure,
    List<UserTransferMoneyEntity>? users,
    WalletEntity? wallet,
    TransferMoneyEntity? dataTransfer,
    UserTransferMoneyEntity? userSelected,
    String? userSelectedEmail,
  }) {
    return TransferMoneyState(
      status: status ?? this.status,
      searchUserStatus: searchUserStatus ?? this.searchUserStatus,
      transferStatus: transferStatus ?? this.transferStatus,
      // searchUserLoading: searchUserLoading ?? this.searchUserLoading,
      // loadingInitial: loadingInitial ?? this.loadingInitial,
      // transferLoading: transferLoading ?? this.transferLoading,
      failure: failure ?? this.failure,
      users: users ?? this.users,
      wallet: wallet ?? this.wallet,
      dataTransfer: dataTransfer ?? this.dataTransfer,
      userSelected: userSelected ?? this.userSelected,
      userSelectedEmail: userSelectedEmail ?? this.userSelectedEmail,
    );
  }
}
