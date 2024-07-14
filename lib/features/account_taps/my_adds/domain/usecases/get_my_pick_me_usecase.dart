import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/repositories/my_ads_repo.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/trip_entity.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../ride/trip_details/domain/entities/trip_and_request_entity.dart';

class GetMyPickMeAdsUseCase
    extends UseCase<List<TripAndRequestEntity>, NoParams> {
  final MyAdsRepo _repo;
  GetMyPickMeAdsUseCase(this._repo);

  @override
  Future<Either<Failure, List<TripAndRequestEntity>>> call(NoParams params) {
    return _repo.getPickMeAds();
  }
}
