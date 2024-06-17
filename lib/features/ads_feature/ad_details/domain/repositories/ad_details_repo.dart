import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../ads/data/models/Ad_model.dart';

abstract class AdDetailsRepo {
  Future<Either<Failure, AdModel>> getAdDetails({required int id});
  Future<Either<Failure, List<AdModel>>> getRelevantAds({required int id});

}
