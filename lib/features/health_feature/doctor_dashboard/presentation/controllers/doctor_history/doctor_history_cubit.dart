import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'doctor_history_state.dart';

class DoctorHistoryCubit extends Cubit<DoctorHistoryState> {
  DoctorHistoryCubit() : super(DoctorHistoryInitial());
}
