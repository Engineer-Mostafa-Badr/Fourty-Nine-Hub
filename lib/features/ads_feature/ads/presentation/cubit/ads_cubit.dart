import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/usecases/make_ad_premium_request_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/usecases/make_ad_request_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/favourite_ad_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_all_comewithme_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_all_pickme_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/remove_favourite_ad_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/request_come_with_me_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/request_pick_me_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/usecases/filter_ad_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
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
  final RemoveFavouriteAdUseCase _removeFavouriteAdUseCase;
  final FavouriteAdUseCase _favouriteAdUseCase;
  final FilterAdUseCase _filterAdUseCase;
  final MakeAdRequestUsecase _makeAdRequestUsecase;
  final MakeAdPremiumRequestUsecase _makeAdPremiumRequestUsecase;

  AdvertisementCubit(
      this._getAdsUseCase,
      this._getAllComeWithMeUseCase,
      this._getAllPickMeUseCase,
      this._requestComeWithMeUseCase,
      this._requestPickMeUseCase,
      this._removeFavouriteAdUseCase,
      this._favouriteAdUseCase,
      this._filterAdUseCase,
      this._makeAdRequestUsecase,
      this._makeAdPremiumRequestUsecase)
      : super(AdsState());

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

  void loadData(
      {required String subCategoryId,
      required String filter,
      required bool fromTab}) async {
    if (fromTab == true) {
      emit(state.copyWith(status: AdsStates.loading));
    }
    await getAds(subCategoryId: subCategoryId, filter: filter, page: 1);
    adsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getAds(subCategoryId: subCategoryId, filter: filter, page: pageKey);
    });
    emit(state.copyWith(status: AdsStates.success));
  }

  void loadFilterData({
    required FilterModel model,
    required String filter,
  }) async {
    emit(state.copyWith(status: AdsStates.loading));
    await filterAds(model: model, filter: filter, page: 1);
    adsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      filterAds(model: model, filter: filter, page: pageKey);
    });
    emit(state.copyWith(status: AdsStates.success));
  }

  void onRefresh() async {
    adsPagingController.refresh();
  }

  void changeState(FilterModel model, bool hasFilter) {
    emit(state.copyWith(filterModel: model, hasFilter: hasFilter));
  }

  filterAds({
    required FilterModel model,
    required int page,
    required String filter,
  }) async {
    if (page == 1) {
      adsPagingController.itemList = [];
    }
    // emit(state.copyWith(status: AdsStates.filterLoading));
    print("object");
    print(page);
    print(filter);
    print("objectHiiiiiiiiiiii");

    FilterModel filterModel = FilterModel(
        price: model.price,
        props: model.props,
        cityId: state.city,
        governorateId: state.governorate,
        limit: 15,
        page: page,
        subCategoryId: model.subCategoryId,
        filter: filter);
    final response = await _filterAdUseCase(filterModel);
    response
        .fold((l) => emit(state.copyWith(failure: l, status: AdsStates.error)),
            (data) {
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
      print(data.toString());
    });
  }

  final PagingController<int, AdModel> adsPagingController =
      PagingController(firstPageKey: 1);
  getAds(
      {required String subCategoryId,
      required String filter,
      required int page}) async {
    final userId = UserCubit.to.isLoggedIn ? UserCubit.to.state.data?.id : '';

    if (page == 1) {
      adsPagingController.itemList = [];
    }
    final response = await _getAdsUseCase(GetAdsParams(
        subCategoryId: subCategoryId,
        filter: filter,
        page: page,
        limit: 10,
        userId: userId));
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
        print(data.length);
        print(data.toString());
        adsPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        adsPagingController.appendPage(data, nextPageKey);
      }
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

  Future<bool> favouriteAd(String id) async {
    final response = await _favouriteAdUseCase(id);
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: AdsStates.error)),
        (data) {
      result = data;
      emit(state.copyWith(status: AdsStates.success));
    });
    return result;
  }

  Future<bool> unFavouriteAd(String id) async {
    final response = await _removeFavouriteAdUseCase(id);
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: AdsStates.error)),
        (data) {
      result = data;
      emit(state.copyWith(status: AdsStates.success));
    });
    return result;
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

  String? phone;

  void changePhone({
    required String v,
  }) {
    phone = v;
    print(phone);
  }

  final formKey = GlobalKey<FormState>();
  void resetRequest() {
    emit(state.copyWith(makeRequest: false));
  }

  Future<bool> makeAdRequest({
    required String id,
  }) async {
    bool data = false;
    print(phone);
    final response = await _makeAdRequestUsecase(
      AdRequestParams(adId: id, phone: phone ?? ''),
    );
    response.fold((l) {
      emit(state.copyWith(
          failure: l, makeRequest: false, status: AdsStates.error));
    }, (r) {
      data = r;
      emit(state.copyWith(status: AdsStates.requestSuccess, makeRequest: true));
    });
    return data;
  }

  Future<bool> makeAdPremiumRequest({
    required String id,
  }) async {
    bool data = false;
    print(phone);
    final response = await _makeAdPremiumRequestUsecase(
      AdRequestParams(adId: id, phone: phone ?? ''),
    );
    response.fold((l) {
      emit(state.copyWith(
          failure: l, makeRequest: false, status: AdsStates.error));
    }, (r) {
      data = r;
      emit(state.copyWith(status: AdsStates.requestSuccess, makeRequest: true));
    });
    return data;
  }
}
