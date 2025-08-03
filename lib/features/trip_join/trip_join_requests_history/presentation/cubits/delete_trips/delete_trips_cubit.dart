import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/error/failure.dart';
import '../../../domain/usecases/delet_trip_usecase.dart';
import '../../../../../../res/strings/labels.dart';

part 'delete_trips_state.dart';

class DeleteTripsCubit extends Cubit<DeleteTripsState> {
  final DeleteTripUseCase deleteTripUseCase;
  DeleteTripsCubit({required this.deleteTripUseCase})
      : super(DeleteTripsInitial());
  Future<void> deleteTrip(
      {required String subCategory,
      required String url,
      required String id}) async {
    emit(DeleteTripsLoading());
    final response = await deleteTripUseCase.call(
        subCategory: subCategory, url: url, id: id);
    response.fold(
      (Failure failure) {
        emit(DeleteTripsFailed(Labels.errorHappened));
      },
      (_) {
        emit(DeleteTripsSuccess());
      },
    );
  }
}
