import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/Ad_model.dart';
import '../repositories/ads_repo.dart';

class GetMyAdByIdUseCase extends UseCase<List<AdModel>, GetMyAdByIdParams> {
  final AdsRepo _repo;

  GetMyAdByIdUseCase(this._repo);

  @override
  Future<Either<Failure, List<AdModel>>> call(GetMyAdByIdParams params) {
    return _repo.getMyAdById(params);
  }
}

class GetMyAdByIdParams{
  final String mainCategoryId;
  final int page;

  GetMyAdByIdParams({required this.mainCategoryId, required this.page});
}
