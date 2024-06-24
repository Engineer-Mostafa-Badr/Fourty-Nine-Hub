import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/usecases/get_ad_details_usecase.dart';
import '../../domain/usecases/get_relevant_ads_usecase.dart';

part 'ad_details_state.dart';

class AdDetailsCubit extends Cubit<AdDetailsState> {
  final GetAdDetailsUseCase _getAdDetailsUseCase;
  final GetRelevantAdsUseCase _getRelevantAdsUseCase;
  AdDetailsCubit(
    this._getAdDetailsUseCase,
    this._getRelevantAdsUseCase,
  ) : super(const AdDetailsState());

  void loadData() async {
    await getAdDetails();
    await getRelevantAds();
  }

  Future<void> getAdDetails() async {
    final response = await _getAdDetailsUseCase.call(0);

    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: AdDetailsStates.error)),
        (data) {

      emit(state.copyWith(ad: data, status: AdDetailsStates.initState));
    });
  }

  Future<void> getRelevantAds() async {
    final response = await _getRelevantAdsUseCase.call(0);
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: AdDetailsStates.error)),
        (data) => emit(state.copyWith(
            relevantAds: data, status: AdDetailsStates.initState)));
  }
}
