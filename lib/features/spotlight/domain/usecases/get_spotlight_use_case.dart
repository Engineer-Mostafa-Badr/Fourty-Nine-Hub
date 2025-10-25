import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/spotlight/domain/entities/spotlight_entity.dart';


import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repositories/spotlight_repo.dart';

class GetSpotlightUseCase extends UseCase<SpotlightEntity  , NoParams> {
  final SpotlightRepository _repo;

  GetSpotlightUseCase(this._repo);
  @override
  Future<Either<Failure, SpotlightEntity  >> call( NoParams params) async {
    return await _repo.getSpotLight();
  }

}






