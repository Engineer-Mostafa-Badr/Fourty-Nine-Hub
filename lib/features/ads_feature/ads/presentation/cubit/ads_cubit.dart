import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/ride_services_enum.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/detail_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_all_comewithme_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_all_pickme_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/request_come_with_me_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/request_pick_me_usecase.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/address_entity.dart';

import '../../../../../core/error/failure.dart';
import '../../../../requests_history/domain/entities/trip_entity.dart';
import '../../data/models/Ad_model.dart';
import '../../domain/usecases/get_ads_usecase.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  final GetAdsUseCase _getAdsUseCase;
  final GetAllPickMeUseCase _getAllPickMeUseCase;
  final GetAllComeWithMeUseCase _getAllComeWithMeUseCase;
  final RequestPickMeUseCase _requestPickMeUseCase;
  final RequestComeWithMeUseCase _requestComeWithMeUseCase;
  AdsCubit(
      this._getAdsUseCase,
      this._getAllComeWithMeUseCase,
      this._getAllPickMeUseCase,
      this._requestComeWithMeUseCase,
      this._requestPickMeUseCase)
      : super(const AdsState());

  void loadData({required String subCategoryId}) async {
    emit(state.copyWith(status: AdsStates.loading));
    if (getRideServiceEnum(value: subCategoryId) == RideServicesEnum.pickMe) {
      await getPickMeAds();
    } else if (getRideServiceEnum(value: subCategoryId) ==
        RideServicesEnum.comeWithYou) {
      await getComeWithMeAds();
    } else {
      await getAds(subCategoryId: subCategoryId);
    }
  }

  Future<void> getAds({required String subCategoryId}) async {
    final response = await _getAdsUseCase(subCategoryId);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: AdsStates.error)),
        (data) => emit(state.copyWith(
            ads: List.generate(
                6,
                (index) => AdModel(
                    id: 'id',
                    title: 'title',
                    description: 'description',
                    images: ['images'],
                    price: 500,
                    address: AddressEntity(
                        id: '',
                        coordinates: [],
                        address: '',
                        street: '',
                        flat: '',
                        building: '',
                        firstName: '',
                        lastName: '',
                        phone: ''),
                    phone: 'phone',
                    user: const UserEntity(
                        id: '',
                        firstName: '',
                        lastName: '',
                        email: '',
                        profilePicture: '',
                        profileCover: '',
                        friendsCount: null,
                        followersCount: null,
                        followingCount: null),
                    active: true,
                    details: [
                      DetailEntiy(label: 'label', type: 'type', value: 'value')
                    ],
                    createdAt: DateTime.now())),
            status: AdsStates.initState)));
  }

  Future<void> getPickMeAds() async {
    final response = await _getAllPickMeUseCase(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: AdsStates.error)),
        (data) =>
            emit(state.copyWith(pickMeAds: data, status: AdsStates.initState)));
  }

  Future<void> getComeWithMeAds() async {
    final response = await _getAllComeWithMeUseCase(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: AdsStates.error)),
        (data) => emit(
            state.copyWith(comeWithMeAds: data, status: AdsStates.initState)));
  }

  Future<void> requestPickMeAd({required RequestParams params}) async {
    final response = await _requestPickMeUseCase(params);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: AdsStates.error)),
        (data) => emit(state.copyWith(status: AdsStates.success)));
  }

  Future<void> requestComeWithMeAd({required RequestParams params}) async {
    final response = await _requestComeWithMeUseCase(params);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: AdsStates.error)),
        (data) => emit(state.copyWith(status: AdsStates.success)));
  }
}
