import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

import '../../../../requests_history/domain/entities/trip_entity.dart';
import '../usecases/request_come_with_me_usecase.dart';

abstract class AdsRepo {
  Future<Either<Failure, List<AdModel>>> getAds({
    required String subCategoryId
  });
    Future<Either<Failure, List<TripEntity>>> getComeWithMeAds();
  Future<Either<Failure, List<TripEntity>>> getPickMeAds();
 Future<Either<Failure, bool>> requestPickMe({required RequestParams params});
  Future<Either<Failure, bool>> requestComeWithMe({required RequestParams params});

}
