import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_details_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../ads/domain/usecases/get_ads_usecase.dart';
import '../../domain/usecases/get_ad_details_usecase.dart';
import '../../domain/usecases/make_ad_request_usecase.dart';

part 'ad_details_state.dart';

class AdDetailsCubit extends Cubit<AdDetailsState> {
  final GetAdDetailsUseCase _getAdDetailsUseCase;
  final GetAdsUseCase _getAdsUseCase;

  final MakeAdRequestUsecase _makeAdRequestUsecase;
  String? phone;
  AdDetailsCubit(this._getAdDetailsUseCase, this._getAdsUseCase,
      this._makeAdRequestUsecase)
      : super(const AdDetailsState());

  //
  // Future<void> getRelevantAds() async {
  //   final response = await _getAdsUseCase(GetAdsParams(subCategoryId: state.ad?.subCategoryId ?? '',filter: 'provider'));
  //   response.fold(
  //       (failure) => emit(
  //           state.copyWith(failure: failure, status: AdDetailsStates.error)),
  //       (data) => emit(state.copyWith(
  //           relevantAds: data, status: AdDetailsStates.initState)));
  // }

  void changePhone({
    required String v,
  }) =>
      phone = v;

  Future<void> getAdDetails({required String adId}) async {
    final userId = UserCubit.to.state.data?.id;
    final response = await _getAdDetailsUseCase(
        GetAdDetailsParams(adId: adId, userId: userId ?? ''));

    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: AdDetailsStates.error));
    }, (data) {
      // getRelevantAds();
      emit(state.copyWith(ad: data, status: AdDetailsStates.initState));
    });
  }

  void loadData({required String adId}) async {
    await getAdDetails(adId: adId);
  }

  void makeAdRequest({
    required String id,
  }) async {
    if (phone != null) {
      final response = await _makeAdRequestUsecase(
        AdRequestParams(adId: id, phone: phone ?? ''),
      );
      response.fold((l) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(currentContext, getFailureMessage(l, currentContext));
        emit(state.copyWith(failure: l));
      }, (r) {
        emit(state.copyWith(status: AdDetailsStates.success));
      });
    } else {
      emit(state.copyWith(
          failure: const ValidationFailure('Phone is required')));
    }
  }
}
