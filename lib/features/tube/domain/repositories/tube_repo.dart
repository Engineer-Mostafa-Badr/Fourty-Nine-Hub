import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/get_all_tube_videos_entity.dart';
import '../usecases/get_all_tube_videos_use_case.dart';


abstract class TubeRepository {

  Future<Either<Failure, List<GetAllTubeVideosEntity>>> getAllTubeVideos({required GetAllTubeVideosParams params});


}
