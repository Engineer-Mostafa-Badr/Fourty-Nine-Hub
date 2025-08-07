import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

import '../repositories/reels_repository.dart';

class UploadReelUseCase extends UseCase<bool, UploadReelParams> {
  final ReelsRepository _repository;

  UploadReelUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(UploadReelParams params) {
    return _repository.uploadReel(params);
  }
}

class UploadReelParams {
  List<String>? images;
  String? audioMedia;
  String? description;
  String? name;

  UploadReelParams({
    this.images,
    this.audioMedia,
    this.description,
    this.name,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      "images": images,
    };

    if (description != null) {
      json["description"] = description;
    }
    if (audioMedia != null) {
      json["audioMedia"] = audioMedia;
    }

    if (name != null) {
      json["name"] = name;
    }

    return json;
  }
}
