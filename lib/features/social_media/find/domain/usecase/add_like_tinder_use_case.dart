import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entity/find_like_entity.dart';
import '../repositories/find_repository.dart';



class AddLikeFindUseCase extends UseCase<FindLikeEntity , AddLikeParams> {
  final FindRepository _repo;

  AddLikeFindUseCase(this._repo);
  @override
  Future<Either<Failure, FindLikeEntity >> call(AddLikeParams params) async {
    return await _repo.addFindLike(params: params);
  }

}

class AddLikeParams {
  final String id;

  AddLikeParams({required this.id});


}



