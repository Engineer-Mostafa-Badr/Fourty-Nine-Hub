import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_search_entity.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repository/azkar_repository.dart';

class SearchAzkarUseCase extends UseCase<List<AzkarSearchEntity>, SearchAzkarParams> {
  final AzkarRepository _azkarRepository;

  SearchAzkarUseCase(this._azkarRepository);
  @override
  Future<Either<Failure, List<AzkarSearchEntity>>> call(
      SearchAzkarParams params) async {
    return await _azkarRepository.searchAzkar(params);
  }
}

class SearchAzkarParams {
  final int page;
  final int limit;
  final String search;

  SearchAzkarParams(
      {required this.page, required this.limit, required this.search});
}
