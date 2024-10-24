import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/ad_request_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/usecases/get_ad_requests_usecase.dart';

import '../../../../../core/error/failure.dart';

abstract class AdRequestsRepo {
  Future<Either<Failure, List<AdRequestEntity>>> getAdRequests({required GetAdRequestsParams params});
}
