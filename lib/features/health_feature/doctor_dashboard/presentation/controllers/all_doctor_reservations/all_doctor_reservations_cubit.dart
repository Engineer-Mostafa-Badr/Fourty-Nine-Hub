import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_all_doctor_reservations_usecase.dart';

part 'all_doctor_reservations_state.dart';

class AllDoctorReservationsCubit extends Cubit<AllDoctorReservationsState> {
  final GetAllDoctorReservationsUsecase _allDoctorReservationsUsecase;

  AllDoctorReservationsCubit(this._allDoctorReservationsUsecase)
      : super(AllDoctorReservationsInitial()) {
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        _getAllDoctorReservations();
      }
    });
  }

  Future<void> loadData() async {
    await _getAllDoctorReservations();
  }

  final ScrollController scrollController = ScrollController();

  int _page = 1;

  final List<DoctorAppointmentEntity> _reservations = [];

  Future<void> _getAllDoctorReservations() async {
    emit(AllDoctorReservationsLoading());
    final result =
        await _allDoctorReservationsUsecase.call(PaginationParams(page: _page));
    result.fold((failure) {
      String message = 'cannotLoadData';
      if (failure is ServerFailure) {
        message = failure.message;
      }
      emit(AllDoctorReservationsError(message));
    }, (data) {
      _page++;
      _reservations.addAll(data);
      emit(AllDoctorReservationsLoaded(_reservations));
    });
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
