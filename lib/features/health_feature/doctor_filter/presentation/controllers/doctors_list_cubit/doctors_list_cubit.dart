import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_doctor_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../doctor_details/domain/entities/doctor_entity.dart';

part 'doctors_list_state.dart';

class DoctorsListCubit extends Cubit<DoctorsListState> {
  final HealthSharedData _healthSharedData;
  final GetDoctorListUseCase _getDoctorListUseCase;

  DoctorsListCubit(
    this._getDoctorListUseCase,
    this._healthSharedData,
  ) : super(DoctorsListInitial());

  void loadData() async {
    await _getDoctors();
  }

  Future<void> _getDoctors() async {
    CliLogger.info('${_healthSharedData.doctorSearchParams.toJson()}');
    final response =
        await _getDoctorListUseCase.call(_healthSharedData.doctorSearchParams);
    response.fold((failure) => emit(DoctorsListError(Labels.errorHappened)),
        (data) => emit(DoctorsListLoaded(data)));
  }
}
