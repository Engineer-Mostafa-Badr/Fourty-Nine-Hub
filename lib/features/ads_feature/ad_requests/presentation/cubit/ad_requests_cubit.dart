import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/ad_request_entity.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/usecases/get_ad_requests_usecase.dart';
part 'ad_requests_state.dart';

class AdRequestsCubit extends Cubit<AdRequestsState> {
  final GetAdRequestsUseCase _getAdRequestsUseCase;

  String? phone;
  AdRequestsCubit( this._getAdRequestsUseCase,
      )
      : super(const AdRequestsState());




  Future<void> getRelevantAds(String id) async {
    emit(state.copyWith(status: AdRequestsStates.loading));
    final response = await _getAdRequestsUseCase(id);
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: AdRequestsStates.error)),
        (data) => emit(state.copyWith(
            requests: data, status: AdRequestsStates.initState)));
  }

  void changePhone({
    required String v,
  }) =>
      phone = v;


}
