import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/search/domain/entity/user_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/repository/search_repository.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';

class FetchUserSearchUseCase
    extends UseCase<List<UserSearchEntity>, SearchParams> {
  final SearchRepository _searchRepository;

  FetchUserSearchUseCase(this._searchRepository);

  @override
  Future<Either<Failure, List<UserSearchEntity>>> call(
      SearchParams params) async {
    return await _searchRepository.fetchUserSearch(params);
  }
}
