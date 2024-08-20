import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../ads/data/models/Ad_model.dart';
import '../usecases/make_ad_request_usecase.dart';

abstract class AdDetailsRepo {
  Future<Either<Failure, AdModel>> getAdDetails({required String id});
  Future<Either<Failure, List<AdModel>>> getRelevantAds({required int id});
  Future<Either<Failure, bool>> makeAdRequest(
      {required AdRequestParams params});
}
