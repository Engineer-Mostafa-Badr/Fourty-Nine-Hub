import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/car_years_and_types_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_statistics_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetCarYearsAndTypesUseCase
    extends UseCase<List<CarYearsAndTypesEntity>, GetCarYearsAndTypesParams> {
  final RideRepository _repo;
  GetCarYearsAndTypesUseCase(this._repo);

  @override
  Future<Either<Failure, List<CarYearsAndTypesEntity>>> call(GetCarYearsAndTypesParams params) {
    return _repo.getCarYearsAndTypes(params);
  }
}

class GetCarYearsAndTypesParams{
  final String brand;
  final String model;
  GetCarYearsAndTypesParams({required this.brand,required this.model});

  //toJson
  Map<String,dynamic> toJson(){
    return {
      "brand":brand,
      "model":model
    };
  }
}