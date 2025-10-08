import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

import '../entity/find_entity.dart';
import '../repositories/find_repository.dart';

class GetFindUseCase extends UseCase<List<FindEntity>, GetFindParams> {
  final FindRepository _repository;

  GetFindUseCase(this._repository);

  @override
  Future<Either<Failure, List<FindEntity>>> call(GetFindParams params) {
    return _repository.getFind(params:params);
  }
}

class GetFindParams {
  final String gender;
  final int page;
  final int limit;
  // final String userId;
  // final bool isLoggedIn;

  GetFindParams(
      {required this.gender, required this.page, required this.limit,

      });

  //toJson
  Map<String, dynamic> toJsonNotLoggedIn() => {
        'gender': gender,
        'page': page,
        'limit': limit,
      };


}
