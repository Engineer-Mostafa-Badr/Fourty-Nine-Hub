import 'package:bloc/bloc.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/data/models/create_carpool_model.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/domain/entities/create_carpool.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/domain/usecases/create_carpool_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'create_car_pool_state.dart';

class CreateCarPoolCubit extends Cubit<CreateCarPoolState> {
  final CreateCarpoolUsecase createCarpoolUsecase;
  CreateCarPoolModel? createCarPoolModel;

  CreateCarPoolCubit({required this.createCarpoolUsecase})
      : super(CreateCarPoolInitial());

  Future<void> createCarPool(
      {required CreateCarpoolParam createCarpoolParam}) async {
    emit(CreateCarPoolLoading());
    final response =
        await createCarpoolUsecase.call(createCarpoolParam: createCarpoolParam);
    response.fold(
        (Failure failure) =>
            emit(CreateCarPoolFailure(errorMessage: Labels.errorHappened)),
        (data) {
      print("dataaaaaa $data");
      emit(CreateCarPoolSuccess(createCarPoolModel: data));
    });
  }
}
