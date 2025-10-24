import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/find/data/models/find_like_model.dart';
import 'package:fourtyninehub/features/social_media/find/data/models/find_model.dart';
import 'package:fourtyninehub/features/social_media/find/domain/entity/find_like_entity.dart';
import 'package:fourtyninehub/features/social_media/find/domain/usecase/add_like_tinder_use_case.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entity/find_entity.dart';
import '../../domain/usecase/get_find_use_case.dart';

abstract class FindRemoteDataSource {

  Future<Either<Failure, List<FindEntity>>> getFind({required GetFindParams params});

  Future<Either<Failure, FindLikeEntity>> addFindLike({required AddLikeParams params});
  Future<Either<Failure, FindLikeEntity>> addFindDisLike({required AddLikeParams params});
  Future<Either<Failure, FindLikeEntity>> addFindLove({required AddLikeParams params});

}

class FindRemoteDataSourceImpl implements FindRemoteDataSource {
  final ApiConsumer _apiConsumer;

  FindRemoteDataSourceImpl(this._apiConsumer);



  @override
  Future<Either<Failure, FindLikeEntity>> addFindLike({required AddLikeParams params})async {
    final url = "${EndPoints.addLikeFind}${params.id}";
    final response = await _apiConsumer.post(url,);

    return response.fold(
          (l) => Left(l),
          (data) {
        final blockRestaurantModel = FindLikeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, FindLikeEntity>> addFindDisLike({required AddLikeParams params})async {
    final url = "${EndPoints.addDisLikeFind}${params.id}";
    final response = await _apiConsumer.post(url,);

    return response.fold(
          (l) => Left(l),
          (data) {
        final blockRestaurantModel = FindLikeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, FindLikeEntity>> addFindLove({required AddLikeParams params})async {
    final url = "${EndPoints.addLoveFind}${params.id}";
    final response = await _apiConsumer.post(url,);

    return response.fold(
          (l) => Left(l),
          (data) {
        final blockRestaurantModel = FindLikeModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, List<FindEntity>>> getFind({required GetFindParams params}) async{
    // final url =
    //     "${EndPoints.fetchFind}?gender=${params.gender}&page=${params.page}&limit=${params.limit}";
    final url = params.isLoggedIn && params.userId.isNotEmpty
        ? "${EndPoints.fetchFind}?userId=${params.userId}&gender=${params.gender}&page=${params.page}&limit=${params.limit}"
        : "${EndPoints.fetchFind}?gender=${params.gender}&page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        // final rideList = (data['data'] as List)
        //     .map((e) => FindModel.fromJson(e as Map<String, dynamic>))
        //     .toList();
            final rideList = (data['data']?['data'] as List<dynamic>? ?? [])
                .map((e) => FindModel.fromJson(e as Map<String, dynamic>))
                .toList();

            return Right(rideList);
      },
    );
  }


}
