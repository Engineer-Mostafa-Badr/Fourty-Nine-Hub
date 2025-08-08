import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

import '../repositories/reels_repository.dart';

class UploadVideoReelUseCase extends UseCase<bool, UploadVideoReelParams> {
  final ReelsRepository _repository;

  UploadVideoReelUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(UploadVideoReelParams params) {
    return _repository.uploadVideoReel(params);
  }
}

class UploadVideoReelParams {
  final String thumbnailMediaId;
  String? description;
  String? name;

  UploadVideoReelParams({
    required this.thumbnailMediaId,
    this.description,
    this.name,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> metadata = {
      'size': 41604,
      'type': 'video/mp3',
      'videoWidth': 848,
      'videoHeight': 478,
      'inputAudioId': '',
      'thumbnailMediaId': thumbnailMediaId,
    };

    // Add `description` only if it's not null
    if (description != null) {
      metadata['description'] = description;
    }

    return {
      'subcategoryId': '66684135dbb427ee42aa0141',
      'isAudioOriginal': true,
      'metadata': metadata,
    };
  }
}
