import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/create_post_repo.dart';

class GetFeelingsUseCase extends UseCase<List<FeelingEntity>, PaginationParams> {
  final CreatePostRepo _repo;
  GetFeelingsUseCase(this._repo);
  @override
  Future<Either<Failure, List<FeelingEntity>>> call(PaginationParams params) {
    return _repo.getFeelingsList(params);
  }
}
