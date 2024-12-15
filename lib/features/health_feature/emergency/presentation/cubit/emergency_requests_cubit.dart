import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/entities/emergency_entity.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/usecases/book_emergency.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/usecases/get_emergency_requests_use_case.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_health_subcategories.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'emergency_requests_state.dart';

class EmergencyRequestsCubit extends Cubit<EmergencyRequestsState> {
  EmergencyRequestsCubit( this._getEmergencyRequestsUseCase)
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

  getEmergencies(String subCategoryId) async{
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getEmergencyRequestsUseCase(
      GetEmergencyRequestsParams( page: currentPage, limit: pageSize, subCategoryId: subCategoryId,),
    );

    response.fold(
          (failure) => emit(state.copyWith(failure: failure, status: EmergencyRequestsStates.error)),
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
