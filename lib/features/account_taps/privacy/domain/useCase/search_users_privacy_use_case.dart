import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/search_users_entity.dart';
import '../repository/privacy_repository.dart';

class SearchUsersPrivacyUseCase
    extends UseCase<List<SearchUsersEntity >, SearchUserPrivacyParams> {
  final PrivacyRepository _repo;
  SearchUsersPrivacyUseCase(this._repo);
  @override
  Future<Either<Failure, List<SearchUsersEntity >>> call(
      SearchUserPrivacyParams params) async {
    return await _repo.searchUsers(params: params);
  }
}

class SearchUserPrivacyParams {
  final String searchKeyWord;

  SearchUserPrivacyParams({
    required this.searchKeyWord,

  });

}
