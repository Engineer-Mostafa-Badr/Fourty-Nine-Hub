import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/repositories/ad_details_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class MakeAdRequestUsecase extends UseCase<bool, AdRequestParams> {
  final AdDetailsRepo _repo;
  MakeAdRequestUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(AdRequestParams params) {
    return _repo.makeAdRequest(params: params);
  }
}

class AdRequestParams {
  final String adId;
  final String phone;
  AdRequestParams({
    required this.adId,
    required this.phone,
  });
  Map<String, dynamic> toJson() => {"adId": adId, "phone": phone};
}
