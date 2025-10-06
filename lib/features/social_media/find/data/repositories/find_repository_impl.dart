import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/find/data/data_sources/find_data_source.dart';
import 'package:fourtyninehub/features/social_media/find/domain/entity/find_entity.dart';
import 'package:fourtyninehub/features/social_media/find/domain/entity/find_like_entity.dart';
import 'package:fourtyninehub/features/social_media/find/domain/repositories/find_repository.dart';
import 'package:fourtyninehub/features/social_media/find/domain/usecase/add_like_tinder_use_case.dart';
import 'package:fourtyninehub/features/social_media/find/domain/usecase/get_find_use_case.dart';

import '../../../../../core/error/failure.dart';


class FindRepositoryImpl extends FindRepository {
  final FindRemoteDataSource _storiesRemoteDataSource;

  FindRepositoryImpl(this._storiesRemoteDataSource);


  @override
  Future<Either<Failure, FindLikeEntity>> addFindLike({required AddLikeParams params}) {
    return _storiesRemoteDataSource.addFindLike(params: params);
  }

  @override
  Future<Either<Failure, FindLikeEntity>> addFindDisLike({required AddLikeParams params}) {
    return _storiesRemoteDataSource.addFindDisLike(params: params);
  }

  @override
  Future<Either<Failure, FindLikeEntity>> addFindLove({required AddLikeParams params}) {
    return _storiesRemoteDataSource.addFindLove(params: params);
  }

  @override
  Future<Either<Failure, List<FindEntity>>> getFind({required GetFindParams params}) {
    return _storiesRemoteDataSource.getFind(params: params);
  }


}
