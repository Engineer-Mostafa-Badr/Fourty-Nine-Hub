import 'package:bloc/bloc.dart';
import '../../../../../../../core/error/failure.dart';
import '../../../../data/models/fetch_my_pick_me_model.dart';
import '../../../../domain/use_cases/fetch_my_pick_me_use_case.dart';
import '../../../../../../../res/strings/labels.dart';

part 'fetch_my_pick_me_trips_state.dart';

class FetchMyPickMeTripsCubit extends Cubit<FetchMyPickMeTripsState> {
  final FetchMyPickMeUseCase fetchMyPickMeUseCase;
  FetchMyPickMeTripsCubit({required this.fetchMyPickMeUseCase})
      : super(FetchMyPickMeTripsInitial());
  List<TripData> trips = [];
  int page = 1;
  Future<void> fetchMyPickMeTrips() async {
    emit(FetchMyPickMeTripsLoading());
    print("Response1 loaaaaaaading \n");
    final response = await fetchMyPickMeUseCase.call(page: page);
    response.fold((Failure failure) {
      emit(FetchMyPickMeTripsFailure(errorMessage: Labels.errorHappened));
    }, (data) {
      trips.addAll(data);
      emit(FetchMyPickMeTripsSuccess(trips: data));
    });
  }
}
