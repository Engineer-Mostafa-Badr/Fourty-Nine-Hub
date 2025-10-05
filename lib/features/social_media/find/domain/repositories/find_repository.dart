import 'package:dartz/dartz.dart';


import '../../../../../core/error/failure.dart';
import '../entity/find_entity.dart';
import '../entity/find_like_entity.dart';
import '../usecase/add_like_tinder_use_case.dart';
import '../usecase/get_find_use_case.dart';

abstract class FindRepository {

   Future<Either<Failure, FindLikeEntity>> addFindLike({required AddLikeParams params});
   Future<Either<Failure, List<FindEntity>>> getFind({required GetFindParams params});
   Future<Either<Failure, FindLikeEntity>> addFindDisLike({required AddLikeParams params});
   Future<Either<Failure, FindLikeEntity>> addFindLove({required AddLikeParams params});

}
