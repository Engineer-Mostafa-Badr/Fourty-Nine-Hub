import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/search/domain/repository/search_repository.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';


class FetchPostsSearchUseCase
    extends UseCase<List<PostEntity>, SearchParams> {
  final SearchRepository _searchRepository;

  FetchPostsSearchUseCase(this._searchRepository);

  @override
  Future<Either<Failure, List<PostEntity>>> call(SearchParams params)async {
    return await _searchRepository.fetchPostsSearch(params);
  }
}