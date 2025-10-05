import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../domain/tinder_like_entity.dart';
import '../repositories/tinder_repository.dart';
import 'add_like_tinder_use_case.dart';



class AddDisLikeTinderUseCase extends UseCase<TinderLikeEntity , AddLikeParams> {
  final TinderRepository _repo;

  AddDisLikeTinderUseCase(this._repo);
  @override
  Future<Either<Failure, TinderLikeEntity >> call(AddLikeParams params) async {
    return await _repo.addTinderDisLike(params: params);
  }

}



