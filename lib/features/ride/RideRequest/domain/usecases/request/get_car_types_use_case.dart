import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/car_type_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/ride_request_repo.dart';
import '../../../../../../core/abstract/use_case.dart';

class GetCarTypesUseCase extends UseCase<List<CarTypeModel>, String> {
  final RideRequestRepo _repo;
  GetCarTypesUseCase(this._repo);

  @override
  Future<Either<Failure, List<CarTypeModel>>> call(String params) {
    return _repo.getCarTypes(subCategoryId: params);
  }
}
