import 'package:bloc/bloc.dart';
import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/car_model_entity.dart';
import '../../../domain/usecases/fetch_car_model_usecase.dart';
import '../../../../../../res/strings/labels.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
part 'fetch_car_models_state.dart';

class FetchCarModelsCubit extends Cubit<FetchCarModelsState> {
  final FetchCarModelUseCase fetchCarModelUseCase;
  List<CarModelEntity?> carModels = [];
  String? model;
  FetchCarModelsCubit({required this.fetchCarModelUseCase})
      : super(FetchCarModelsInitial());
  Future<void> fetchCarModel({required String brand}) async {
    emit(FetchCarModelsLoading());
    final response = await fetchCarModelUseCase.call(brand: brand);
    response.fold(
      (Failure failure){
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
         emit(
        FetchCarModelsFailed(getFailureMessage(failure, currentContext)),
      );},
      (List<CarModelEntity> models) {
        // print(' ============  inside cubit $models');
        carModels = [];
        carModels = models;
        emit(
          FetchCarModelsSuccess(models),
        );
      },
    );
  }
}
