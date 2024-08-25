import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/place_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/repositories/create_post_repo.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/friends-followers_usecase.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetPlacesUseCase extends UseCase<List<PlaceEntity>, FriendsFollowersParams> {
  final CreatePostRepo _repo;
  GetPlacesUseCase(this._repo);
  @override
  Future<Either<Failure, List<PlaceEntity>>> call(FriendsFollowersParams params) async {
    return await _repo.getPlaces(params: params);
  }
}
