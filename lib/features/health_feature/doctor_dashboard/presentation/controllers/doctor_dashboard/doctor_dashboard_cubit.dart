import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_id_remaining_days.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_practicing_remaining_days.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_subscription_remaining_days.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'doctor_dashboard_state.dart';

class DoctorDashboardCubit extends Cubit<DoctorDashboardState> {
  final GetDoctorSubscriptionRemainingDaysUseCase
      _getDoctorSubscriptionRemainingDaysUseCase;
  final GetDoctorPracticingRemainingDaysUseCase
      _getDoctorPracticingRemainingDaysUseCase;
  final GetDoctorIDRemainingDaysUseCase _getDoctorIDRemainingDaysUseCase;
  DoctorDashboardCubit(
      this._getDoctorSubscriptionRemainingDaysUseCase,
      this._getDoctorPracticingRemainingDaysUseCase,
      this._getDoctorIDRemainingDaysUseCase)
      : super(DoctorDashboardInitial());

  Future<void> loadData() async {
    await _getSubscriptionRemainingDays();
    await _getPracticingRemainingDays();
    await _getIDRemainingDays();
  }

  Future<void> _getSubscriptionRemainingDays() async {
    final response = await _getDoctorSubscriptionRemainingDaysUseCase.call('');
    response.fold((l) => emit(DoctorDashboardError(Labels.errorHappened)),
        (r) => emit(DoctorDAshboardSupscriptionRemainingDays(r)));
  }

  Future<void> _getPracticingRemainingDays() async {
    final response = await _getDoctorPracticingRemainingDaysUseCase.call('');
    response.fold((l) => emit(DoctorDashboardError(Labels.errorHappened)),
        (r) => emit(DoctorDAshboardSupscriptionRemainingDays(r)));
  }

  Future<void> _getIDRemainingDays() async {
    final response = await _getDoctorIDRemainingDaysUseCase.call('');
    response.fold((l) => emit(DoctorDashboardError(Labels.errorHappened)),
        (r) => emit(DoctorDAshboardSupscriptionRemainingDays(r)));
  }
}
