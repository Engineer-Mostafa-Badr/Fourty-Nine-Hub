import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/models/public/state_model.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
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
  final String content;
  final Color? color;
  final String? feeling;
  final String? activity;
  final String? location;
  PostParams(
      {required this.content,
      this.color,
      this.activity,
      this.feeling,
      this.location});
  Map<String, dynamic> toJson() => {
        'content': content,
      };
}
