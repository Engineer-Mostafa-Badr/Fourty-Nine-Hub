import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/repositories/my_ads_repo.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/edit_my_ads_entity.dart';
import '../../../../../../core/abstract/use_case.dart';

class FetchMyAdsByIdUseCase extends UseCase<EditMyAdsEntity, String> {
  final MyAdsRepo _repo;
  FetchMyAdsByIdUseCase(this._repo);

  @override
  Future<Either<Failure, EditMyAdsEntity>> call(String params) {
    return _repo.fetchMyAdsById(id: params);
  }
}
