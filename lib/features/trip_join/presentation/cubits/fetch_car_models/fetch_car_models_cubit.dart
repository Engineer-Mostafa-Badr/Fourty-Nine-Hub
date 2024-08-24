import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/car_model_entity.dart';
import 'package:fourtyninehub/features/trip_join/domain/usecases/fetch_car_model_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'fetch_car_models_state.dart';

class FetchCarModelsCubit extends Cubit<FetchCarModelsState> {
  final FetchCarModelUseCase fetchCarModelUseCase;
  List<CarModelEntity?> carModels = [];
  String? model;
  FetchCarModelsCubit({required this.fetchCarModelUseCase}) : super(FetchCarModelsInitial());
  Future<void> fetchCarModel({required String brand}) async {
    emit(FetchCarModelsLoading());
    final response = await fetchCarModelUseCase.call(brand: brand);
    response.fold(
      (Failure failure) => emit(
        FetchCarModelsFailed(Labels.errorHappened),
      ),
      (List<CarModelEntity> models) {
        print(' ============  inside cubit $models');
        carModels = [];
        carModels = models;
        emit(
          FetchCarModelsSuccess(models),
        );
      },
    );
  }
}
