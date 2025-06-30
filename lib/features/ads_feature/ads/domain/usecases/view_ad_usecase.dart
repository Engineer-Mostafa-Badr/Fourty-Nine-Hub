import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/ads_repo.dart';

class ViewAdUseCase extends UseCase<bool, String> {
  final AdsRepo _repo;
  ViewAdUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.viewAd(params: params);
  }
}
