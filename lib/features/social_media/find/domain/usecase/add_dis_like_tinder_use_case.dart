import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/find/domain/entity/find_like_entity.dart';
import 'package:fourtyninehub/features/social_media/find/domain/usecase/add_like_tinder_use_case.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/find_repository.dart';




class AddDisLikeFindUseCase extends UseCase<FindLikeEntity , AddLikeParams> {
  final FindRepository _repo;

  AddDisLikeFindUseCase(this._repo);
  @override
  Future<Either<Failure, FindLikeEntity >> call(AddLikeParams params) async {
    return await _repo.addFindDisLike(params: params);
  }

}



