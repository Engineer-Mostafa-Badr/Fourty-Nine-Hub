import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_history_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_subscription_entity.dart';

import '../../../domain/entities/favourite_ad_drawer_entity.dart';

enum FavouriteDrawerStates { loading, success,initial, error }

class FavouriteDrawerState {
  final FavouriteDrawerStates status;
  final Failure? failure;
  final List<FavouriteAdDrawerEntity>? favourite;

  const FavouriteDrawerState({
    this.status = FavouriteDrawerStates.loading,
    this.failure,
    this.favourite,
  });

  FavouriteDrawerState copyWith({
    FavouriteDrawerStates? status,
    Failure? failure,
    List<FavouriteAdDrawerEntity>? favourite

  }) {
    return FavouriteDrawerState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      favourite: favourite ?? this.favourite,
    );
  }
}
