import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_all_comewithme_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_all_pickme_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/request_come_with_me_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/request_pick_me_usecase.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../core/error/failure.dart';
import '../../../../requests_history/domain/entities/trip_entity.dart';
import '../../data/models/Ad_model.dart';
import '../../domain/usecases/get_ads_usecase.dart';

part 'ads_state.dart';

class AdvertisementCubit extends Cubit<AdsState> {
  final GetAdsUseCase _getAdsUseCase;
  final GetAllPickMeUseCase _getAllPickMeUseCase;
  final GetAllComeWithMeUseCase _getAllComeWithMeUseCase;
  final RequestPickMeUseCase _requestPickMeUseCase;
  final RequestComeWithMeUseCase _requestComeWithMeUseCase;
  AdvertisementCubit(
      this._getAdsUseCase,
      this._getAllComeWithMeUseCase,
      this._getAllPickMeUseCase,
      this._requestComeWithMeUseCase,
      this._requestPickMeUseCase)
      : super(const AdsState());

  // void loadData({required String subCategoryId,required String filter}) async {
  //   // emit(state.copyWith(status: AdsStates.loading));
  //   if (getRideServiceEnum(value: subCategoryId) == RideServicesEnum.pickMe) {
  //     await getPickMeAds();
  //   } else if (getRideServiceEnum(value: subCategoryId) ==
  //       RideServicesEnum.comeWithYou) {
  //     await getComeWithMeAds();
  //   } else {
  //     await getAds(subCategoryId: subCategoryId,filter: filter);
  //   }
  // }

  void loadData({required String subCategoryId, required String filter}) async {
    await getAds(subCategoryId: subCategoryId, filter: filter, page: 1);
    adsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getAds(subCategoryId: subCategoryId, filter: filter, page: pageKey);
    });
  }

  void onRefresh() async {
    adsPagingController.refresh();
  }

  final PagingController<int, AdModel> adsPagingController =
      PagingController(firstPageKey: 1);
  getAds(
      {required String subCategoryId,
      required String filter,
      required int page}) async {
    final response = await _getAdsUseCase(GetAdsParams(
        subCategoryId: subCategoryId, filter: filter, page: page, limit: 10));
    response
        .fold((l) => emit(state.copyWith(failure: l, status: AdsStates.error)),
            (data) async {
      final isLastPage = data.length < 10;
      if (page == 1) {
        print("page == 1 $page");
        adsPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        adsPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        adsPagingController.appendPage(data, nextPageKey);
      }
      emit(state.copyWith(ads: data, status: AdsStates.success));
    });
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
