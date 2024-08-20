import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/repositories/my_ads_repo.dart';
import '../../../../../../core/abstract/use_case.dart';

class CancelAdUseCase extends UseCase<bool, String> {
  final MyAdsRepo _repo;
  CancelAdUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.cancelAd(id: params);
  }
}
