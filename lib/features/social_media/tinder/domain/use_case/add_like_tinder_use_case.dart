import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../domain/tinder_like_entity.dart';
import '../repositories/tinder_repository.dart';



class AddLikeTinderUseCase extends UseCase<TinderLikeEntity , AddLikeParams> {
  final TinderRepository _repo;

  AddLikeTinderUseCase(this._repo);
  @override
  Future<Either<Failure, TinderLikeEntity >> call(AddLikeParams params) async {
    return await _repo.addTinderLike(params: params);
  }

}

class AddLikeParams {
  final String id;

  AddLikeParams({required this.id});


}



