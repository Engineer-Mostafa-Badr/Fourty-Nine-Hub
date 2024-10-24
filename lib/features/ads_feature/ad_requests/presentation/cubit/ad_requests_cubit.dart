import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_details_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import '../../../../../core/error/failure.dart';
import '../../../ads/domain/usecases/get_ads_usecase.dart';
part 'ad_requests_state.dart';

class AdRequestsCubit extends Cubit<AdRequestsState> {
  final GetAdsUseCase _getAdsUseCase;

  String? phone;
  AdRequestsCubit( this._getAdsUseCase,
      )
      : super(const AdRequestsState());



  //
  // Future<void> getRelevantAds() async {
  //   final response = await _getAdsUseCase(GetAdsParams(subCategoryId: state.ad?.subCategoryId ?? '',filter: 'provider'));
  //   response.fold(
  //       (failure) => emit(
  //           state.copyWith(failure: failure, status: AdRequestsStates.error)),
  //       (data) => emit(state.copyWith(
  //           relevantAds: data, status: AdRequestsStates.initState)));
  // }

  void changePhone({
    required String v,
  }) =>
      phone = v;


}
