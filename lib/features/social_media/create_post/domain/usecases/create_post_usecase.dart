import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/place_entity.dart';
import '../repositories/create_post_repo.dart';

class CreatePostUseCase extends UseCase<bool, PostParams> {
  final CreatePostRepo _repo;
  CreatePostUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(PostParams params) {
    return _repo.postData(data: params.toJson());
  }
}

class PostParams {
  final String type;
  final String content;
  final String? color;
  final String? feeling;
  final String? gifUrl;
  final String? activity;
  final String? privacy;
  final PlaceEntity? place;
  final List<String>? mediaId;
  final List<String>? users;
  PostParams({
    required this.type,
    required this.content,
    this.gifUrl,
    this.color,
    this.activity,
    this.feeling,
    this.privacy,
    this.mediaId,
    this.place,
    this.users,
  });
  Map<String, dynamic> toJson() => {
        'content': content,
        'type': type,
    if (gifUrl != null && gifUrl!.isNotEmpty)'gifUrl': gifUrl,
        if (feeling != null && feeling!.isNotEmpty) 'feeling': feeling,
        if (activity != null && activity!.isNotEmpty) 'activity': activity,
        if (place != null)
          "location": {
            "place": place?.name,
            "lat": "${place?.lat}",
            "long": "${place?.lng}"
          },
        if (color != null) 'background_color': color,
        if(mediaId!=null&&mediaId!.isNotEmpty)'media': mediaId,
        'publicationType': privacy ?? 'public',
        "with": users,
      };
}
