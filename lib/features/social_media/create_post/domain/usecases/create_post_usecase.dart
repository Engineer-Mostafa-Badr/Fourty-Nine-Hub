import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/life_event_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/place_entity.dart';
import '../repositories/create_post_repo.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';

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
  final bool? onTweet;
  final bool? onInsta;
  final ActivityEntity? activity;
  final String? privacy;
  final PlaceEntity? place;
  final LifeEventEntity? lifeEvent;
  final List<String>? mediaId;
  final List<String>? users;
  PostParams({
    required this.type,
    required this.content,
    this.gifUrl,
    this.lifeEvent,
    this.color,
    this.activity,
    this.feeling,
    this.onTweet,
    this.onInsta,
    this.privacy,
    this.mediaId,
    this.place,
    this.users,
  });
  Map<String, dynamic> toJson() => {
        'content': content,
        'type': type,
        if (lifeEvent != null && (lifeEvent?.id.isNotEmpty ?? false))
          "liveEvent": {
            "liveEventTypeId": lifeEvent?.id,
            "title": lifeEvent?.title,
            "description": lifeEvent?.desc,
            "mediaIds": lifeEvent?.media.map((model) => model.mediaId).toList(),
            "date": lifeEvent?.date.toString()
          },
        if (gifUrl != null && gifUrl!.isNotEmpty) 'gifUrl': gifUrl,
        if (feeling != null && feeling!.isNotEmpty) 'feelingId': feeling,
        if (activity != null && (activity?.id.isNotEmpty ?? false))
          'activity': {
            'mainId': activity?.mainActivity?.id,
            'subId': activity?.id
          },
        if (place != null && (place?.name.isNotEmpty ?? false))
          "location": {
            "name": place?.name,
            "fullAddress": place?.name,
            "coordinates": [place?.lat, place?.lng],
          },
        if ((lifeEvent == null || (lifeEvent?.id.isEmpty ?? false)) &&
            (gifUrl == null || (gifUrl?.isEmpty ?? false))
            && (mediaId == null || (mediaId?.isEmpty ?? false)))
          'backgroundColor': color,
        if(mediaId!=null&&(mediaId?.isNotEmpty??false))'media': mediaId,
        'publicationType': privacy ?? 'public',
        "userTagIds": users,
        "shared": {"twitter": onTweet, "instagram": onInsta}
      };
}
