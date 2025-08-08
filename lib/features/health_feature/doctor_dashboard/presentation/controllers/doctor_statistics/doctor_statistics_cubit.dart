import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_statistics_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_statistics_usecase.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
part 'doctor_statistics_state.dart';

class DoctorStatisticsCubit extends Cubit<DoctorStatisticsState> {
  final GetDoctorStatisticsUsecase _getDoctorStatisticsUsecase;

  DoctorStatisticsCubit(this._getDoctorStatisticsUsecase)
      : super(DoctorStatisticsInitial());

  Future<void> loadData() async {
    await _getDoctorStatistics();
  }

  Future<void> _getDoctorStatistics() async {
    final response = await _getDoctorStatisticsUsecase.call(const NoParams());
    response.fold((failure) {
      var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
      String message = 'cannotLoadData';
      if (failure is ServerFailure) {
        message = failure.message;
      }
      emit(DoctorStatisticsError(message));
    }, (data) => emit(DoctorStatisticsLoaded(data)));
  }
}
