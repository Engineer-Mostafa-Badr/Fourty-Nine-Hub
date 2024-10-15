import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_details_model.dart';

import '../../../../../core/error/failure.dart';
import '../../../ads/data/models/Ad_model.dart';

abstract class AdRequestsRepo {
  Future<Either<Failure, AddDetailsModel>> getAdDetails({required String id});
  Future<Either<Failure, List<AdModel>>> getRelevantAds({required int id});
}
