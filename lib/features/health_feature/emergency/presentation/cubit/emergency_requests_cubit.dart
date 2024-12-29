import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/entities/emergency_entity.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/usecases/get_emergency_requests_use_case.dart';

part 'emergency_requests_state.dart';

class EmergencyRequestsCubit extends Cubit<EmergencyRequestsState> {
  EmergencyRequestsCubit(this._getEmergencyRequestsUseCase)
      : super(const EmergencyRequestsState());
  final GetEmergencyRequestsUseCase _getEmergencyRequestsUseCase;

  List<EmergencyEntity> emergencies = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;

  void loadEmergencies(String subCategoryId) async {
    emit(state.copyWith(status: EmergencyRequestsStates.loading));
    emergencies.clear();
    currentPage = 1;
    hasMoreData = true;
    await getEmergencies(subCategoryId);
  }

  getEmergencies(String subCategoryId) async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getEmergencyRequestsUseCase(
      GetEmergencyRequestsParams(
        page: currentPage,
        limit: pageSize,
        subCategoryId: subCategoryId,
      ),
    );

    response.fold(
      (failure) => emit(state.copyWith(
          failure: failure, status: EmergencyRequestsStates.error)),
      (data) {
        emergencies.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(status: EmergencyRequestsStates.success));
      },
    );
  }
}
