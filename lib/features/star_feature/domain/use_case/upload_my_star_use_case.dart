import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/star_feature/domain/repository/star_repository.dart';

class UploadMyStarUseCase extends UseCase<bool, StarParams> {
  final StarRepository _starRepository;

  UploadMyStarUseCase(this._starRepository);

  @override
  Future<Either<Failure, bool>> call(StarParams params) async {
    return await _starRepository.uploadMyStar(params);
  }
}

class StarParams {
  final String title;
  final List<String>? mediaUrl;
  final String description;
  final String type;

  StarParams({
    required this.title,
    required this.mediaUrl,
    required this.description,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'mediaUrl': mediaUrl,
        'description': description,
        'type': type,
      };
}
