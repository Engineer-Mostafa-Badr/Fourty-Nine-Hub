// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/entities/car_year_type_entity.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_car_year_type_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'fetch_car_year_type_state.dart';

class FetchCarYearTypeCubit extends Cubit<FetchCarYearTypeState> {
  final FetchCarYearTypeUseCase fetchCarYearTypeUseCase;
  List<CarYearTypeEntity?> carYears = [];
  String? year;
  FetchCarYearTypeCubit({
    required this.fetchCarYearTypeUseCase,
  }) : super(FetchCarYearTypeInitial());
  Future<void> getCarYears({
    required String brand,
    required String model,
  }) async {
    emit(FetchCarYearTypeLoading());
    final response = await fetchCarYearTypeUseCase.call(
      brand: brand,
      model: model,
    );
    response.fold(
      (Failure failure) => emit(
        FetchCarYearTypeFailed(Labels.errorHappened),
      ),
      (List<CarYearTypeEntity> models) {
        carYears = [];
        carYears = models;
        emit(
          FetchCarYearTypeSuccess(models),
        );
      },
    );
  }
}
