import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_brand_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_brand_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class AddCarModelUseCase
    extends UseCase<String, AddCarModelParams> {
  final RideRepository _repo;
  AddCarModelUseCase(this._repo);

  @override
  Future<Either<Failure, String>> call(AddCarModelParams params) {
    return _repo.addCarModel(params);
  }
}

class AddCarModelParams{
  final String carBrandId;
  final String modelName;
  final String type;

  AddCarModelParams({required this.carBrandId, required this.modelName, required this.type});

  //toJson
  Map<String, dynamic> toJson() => {'carBrandId': carBrandId, 'modelName': modelName, 'type': type};
}