import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/trip_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/ads_repo.dart';

class GetAllComeWithMeUseCase extends UseCase<List<TripEntity>, NoParams> {
  final AdsRepo _repo;
  GetAllComeWithMeUseCase(this._repo);

  @override
  Future<Either<Failure, List<TripEntity>>> call(NoParams params) {
    return _repo.getComeWithMeAds();
  }
}
