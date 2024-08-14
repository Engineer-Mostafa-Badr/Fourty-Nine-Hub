import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/repositories/my_ads_repo.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../repositories/ads_repo.dart';
import 'request_come_with_me_usecase.dart';

class RequestPickMeUseCase extends UseCase<bool, RequestParams> {
  final AdsRepo _repo;
  RequestPickMeUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(RequestParams params) {
    return _repo.requestPickMe(params: params);
  }
}
