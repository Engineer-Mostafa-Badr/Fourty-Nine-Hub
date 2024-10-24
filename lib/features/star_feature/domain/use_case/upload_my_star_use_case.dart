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
  final String videoUrl;
  final String description;

  StarParams(
      {required this.title, required this.videoUrl, required this.description});

  Map<String,dynamic>toJson()=>{
    'title':title,
    'videoUrl':videoUrl,
    'description':description,
  };
}
