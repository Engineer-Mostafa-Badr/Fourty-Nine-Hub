import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/create_post_request_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class CreateRequestPostInstagramUseCase extends UseCase<List<CreatePostRequestEntity>, CreatePostRequestInstagramParams> {
  final InstagramRepo _repo;
  CreateRequestPostInstagramUseCase(this._repo);
  @override
  Future<Either<Failure, List<CreatePostRequestEntity>>> call(CreatePostRequestInstagramParams params) async {
    return await _repo.createRequestPost(params);
  }
}

class CreatePostRequestInstagramParams {
  final String content;
  final List<MediaCreatePostInstagramParams> media;
  final LocationCreatePostInstagramParams? location;
  final List<String>? userTagIds;

  CreatePostRequestInstagramParams({
    required this.content,
    required this.media,
    this.location,
    this.userTagIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'media': media.map((e) => e.toJson()).toList(),
      if (location != null) 'location': location!.toJson(),
      if (userTagIds != null) 'userTagIds': userTagIds,
    };
  }
}

class LocationCreatePostInstagramParams {
  final String name;
  final String fullAddress;
  final num lag;
  final num lat;

  LocationCreatePostInstagramParams({
    required this.name,
    required this.fullAddress,
    required this.lag,
    required this.lat,
  });


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fullAddress': fullAddress,
      'coordinates': [lag, lat],
    };
  }
}

class MediaCreatePostInstagramParams {
  final String itemId;
  final String type;
  final num size;

  MediaCreatePostInstagramParams({
    required this.itemId,
    required this.type,
    required this.size,
  });


  Map<String, dynamic>    toJson() {
    return {
      'itemId': itemId,
      'type': type,
      'size': size,
    };
  }
}
