import 'package:bloc/bloc.dart';

part 'doctor_dashboard_state.dart';

class DoctorDashboardCubit extends Cubit<DoctorDashboardState> {
  DoctorDashboardCubit() : super(DoctorDashboardInitial());
}
