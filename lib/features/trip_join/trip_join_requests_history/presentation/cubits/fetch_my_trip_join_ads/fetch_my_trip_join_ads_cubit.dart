import 'package:bloc/bloc.dart';
import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/tripjoin_request_entity.dart';
import '../../../domain/usecases/fetch_ty_trip_join_ads_usecase.dart';
import '../../../../../../res/strings/labels.dart';

part 'fetch_my_trip_join_ads_state.dart';

class FetchMyTripJoinAdsCubit extends Cubit<FetchMyTripJoinAdsState> {
  final FetchMyTripJoinAdsUseCase fetchMyTripJoinAdsUseCase;
  FetchMyTripJoinAdsCubit({
    required this.fetchMyTripJoinAdsUseCase,
  }) : super(FetchMyTripJoinAdsInitial());
  List<TripJoinMyRequestEntity> trips = [];
  int page = 1;
  Future<void> fetchMyTripJoinAds() async {
    emit(FetchMyTripJoinAdsLoading());
    final response = await fetchMyTripJoinAdsUseCase.call(page: page);
    response.fold(
      (Failure failure) {
        emit(FetchMyTripJoinAdsFailed(Labels.errorHappened));
      },
      (data) {
        trips.addAll(data);

        emit(FetchMyTripJoinAdsSuccess(data));
      },
    );
  }
}
