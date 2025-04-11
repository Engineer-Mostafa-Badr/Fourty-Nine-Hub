import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';

class PostInstagramState {}

class InitialPostInstagramState extends PostInstagramState {}

class LoadingPostInstagramState extends PostInstagramState {}

class FailurePostInstagramState extends PostInstagramState {
  final Failure failure;

  FailurePostInstagramState({required this.failure});
}

class SuccessCreatePostInstagramState extends PostInstagramState {
  final List<InstagramPostEntity>? posts;
  SuccessCreatePostInstagramState({this.posts});
}
