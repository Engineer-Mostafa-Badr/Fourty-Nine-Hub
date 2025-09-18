import 'package:dartz/dartz.dart';
import '../repositories/create_post_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class CreateTwitterThreadUseCase extends UseCase<bool, CreateTwitterThreadParams> {
  final CreatePostRepo _repo;
  CreateTwitterThreadUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(CreateTwitterThreadParams params) async {
    return _repo.createTwitterPost(params: params);
  }
}

class CreateTwitterThreadParams {
  final bool isPublished;
  final List<TwitterPostItem> posts;
  const CreateTwitterThreadParams({required this.isPublished, required this.posts});

  Map<String, dynamic> toJson() => {
    'isPublished': isPublished,
    'posts': posts.map((p) => p.toJson()).toList(),
  };
}

class TwitterPostItem {
  final String content;
  final List<String> media;
  const TwitterPostItem({required this.content, this.media = const []});

  Map<String, dynamic> toJson() => {
    'content': content,
    'media': media,
  };
}
