import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/accept_come_with_me_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/accept_pick_me_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/get_my_trip_join_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/reject_come_with_me_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/reject_pick_me_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../../../../ads_feature/ads/domain/entities/ad_entity.dart';

import '../../../../ride/trip_details/domain/entities/trip_and_request_entity.dart';
import '../../domain/entity/get_all_counts_trip_join_entity.dart';
import '../../domain/entity/my_ads_auction.dart';
import '../../domain/entity/my_ads_trip_join_entity.dart';
import '../../domain/usecases/cancel_ad_usecase.dart';
import '../../domain/usecases/delete_come_with_me_usecase.dart';
import '../../domain/usecases/delete_my_installment_usecase.dart';
import '../../domain/usecases/delete_my_trip_join_usecase.dart';
import '../../domain/usecases/delete_pick_me_usecase.dart';
import '../../domain/usecases/get_all_counts_usecase.dart';
import '../../domain/usecases/get_my_ads_usecase.dart';
import '../../domain/usecases/get_my_auctions_usecase.dart';
import '../../domain/usecases/get_my_come_with_you_usecase.dart';
import '../../domain/usecases/get_my_installments_usecase.dart';
import '../../domain/usecases/get_my_other_ads_usecase.dart';
import '../../domain/usecases/get_my_pick_me_usecase.dart';

part 'my_adds_state.dart';

class MyAddsCubit extends Cubit<MyAddsState> {
  final GetMyAdsUseCase _getMyAdsUseCase;
  final GetMyPickMeAdsUseCase _getMyPickMeAdsUseCase;
  final GetMyComeWithMeUseCase _getMyComeWithMeUseCase;
  final DeletePickMeUseCase _deletePickMeUseCase;
  final DeleteComeWithMeUseCase _deleteComeWithMeUseCase;
  final AcceptPickMeUseCase _acceptPickMeUseCase;
  final AcceptComeWithMeUseCase _acceptComeWithMeUseCase;
  final RejectComeWithMeUseCase _rejectComeWithMeUseCase;
  final RejectPickMeUseCase _rejectPickMeUseCase;
  final CancelAdUseCase _cancelAdUseCase;
  final GetMyAuctionsUseCase _getMyAuctionsUseCase;
  final GetMyInstallmentUseCase _getMyInstallmentUseCase;
  final GetMyOtherAdsUseCase _getMyOtherAdsUseCase;
  final GetMyTripJoinUseCase _getMyTripJoinUseCase;
  final DeleteMyTripJoinUseCase _deleteMyTripJoinUseCase;
  final DeleteMyInstallmentUseCase _deleteMyInstallmentUseCase;
  final GetAllCountsUseCase _allCountsUseCase;

  MyAddsCubit(
      this._getMyAdsUseCase,
      this._deleteComeWithMeUseCase,
      this._deletePickMeUseCase,
      this._getMyComeWithMeUseCase,
      this._getMyPickMeAdsUseCase,
      this._acceptComeWithMeUseCase,
      this._acceptPickMeUseCase,
      this._rejectComeWithMeUseCase,
      this._cancelAdUseCase,
      this._getMyAuctionsUseCase,
      this._rejectPickMeUseCase,
      this._getMyInstallmentUseCase,
      this._getMyTripJoinUseCase,
      this._deleteMyTripJoinUseCase,
      this._deleteMyInstallmentUseCase,
      this._getMyOtherAdsUseCase,
      this._allCountsUseCase)
      : super(const MyAddsState());

  void loadData() async {
    // await getMyAds();
    await getPickMeTrips();
    // await getComeWithMeTrips();
    // await getMyAuctions();
  }

  Future<void> getMyAds() async {
    final response = await _getMyAdsUseCase.call(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) => emit(state.copyWith(myAds: r, status: MyAddsStates.initState)));
  }

  Future<void> getMyAuctions() async {
    emit(state.copyWith(status: MyAddsStates.loading));
    final response = await _getMyAuctionsUseCase(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) => emit(
            state.copyWith(myAuctions: r, status: MyAddsStates.initState)));
  }

  Future<void> getMyInstallment() async {
    emit(state.copyWith(status: MyAddsStates.loading));
    final response = await _getMyInstallmentUseCase(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) => emit(
            state.copyWith(myInstallments: r, status: MyAddsStates.initState)));
  }

  Future<void> getMyOtherAds() async {
    emit(state.copyWith(status: MyAddsStates.loading));
    final response = await _getMyOtherAdsUseCase(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) => emit(
            state.copyWith(myOtherAds: r, status: MyAddsStates.initState)));
  }

  Future<void> getMyTripJoin() async {
    emit(state.copyWith(status: MyAddsStates.loading));
    final response = await _getMyTripJoinUseCase(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) =>
            emit(state.copyWith(tripJoin: r, status: MyAddsStates.initState)));
  }

  Future<void> deleteMyTripJoin({required String id}) async {
    emit(state.copyWith(status: MyAddsStates.loading));
    final response = await _deleteMyTripJoinUseCase(id);
    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
      (r) {
        emit(
          state.copyWith(status: MyAddsStates.success),
        );
        getMyTripJoin();
      },
    );
  }

  Future<void> deleteMyInstallment({required String id}) async {
    emit(state.copyWith(status: MyAddsStates.loading));
    final response = await _deleteMyInstallmentUseCase(id);
    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
      (r) {
        emit(
          state.copyWith(status: MyAddsStates.success),
        );
        getMyInstallment();
      },
    );
  }

  Future<void> getPickMeTrips() async {
    final response = await _getMyPickMeAdsUseCase(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) => emit(
            state.copyWith(pickMeTrips: r, status: MyAddsStates.initState)));
  }

  Future<void> getComeWithMeTrips() async {
    final response = await _getMyComeWithMeUseCase(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) => emit(state.copyWith(
            comeWithMeTrips: r, status: MyAddsStates.initState)));
  }

  void cancelAd({required String id}) async {
    final response = await _cancelAdUseCase(id);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) {
      getMyAds();
    });
  }

  void rejectPickMeRequest({required String id}) async {
    final response = await _rejectPickMeUseCase(id);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) {
      getPickMeTrips();
    });
  }

  void rejectComeWithMeRequest({required String id}) async {
    final response = await _rejectComeWithMeUseCase(id);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) {
      getComeWithMeTrips();
    });
  }

  void acceptComeWithMeRequest({required String id}) async {
    final response = await _acceptComeWithMeUseCase(id);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) {
      getComeWithMeTrips();
    });
  }

  void acceptPickMeRequest({
    required String id,
  }) async {
    final response = await _acceptPickMeUseCase(id);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) {
      getPickMeTrips();
    });
  }

  void deleteAd({required String id}) async {}

  void deletePickMeRequest({
    required String id,
  }) async {
    final response = await _deletePickMeUseCase(id);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) {
      getPickMeTrips();
    });
  }

  void deleteComeWithMe({required String id}) async {
    final response = await _deleteComeWithMeUseCase(id);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) {
      getComeWithMeTrips();
    });
  }

  Future<void> getAllCount({
    required Params params,
  }) async {
    final response = await _allCountsUseCase(params);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) =>
            emit(state.copyWith(allCounts: r, status: MyAddsStates.initState)));
  }
}
