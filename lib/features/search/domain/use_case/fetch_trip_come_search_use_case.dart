import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/search/domain/entity/trip_come_with_you_entity.dart';
import 'package:fourtyninehub/features/search/domain/repository/search_repository.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';

class FetchTripComeSearchUseCase
    extends UseCase<List<TripComeWithYouEntity>, SearchParams> {
  final SearchRepository _searchRepository;

  FetchTripComeSearchUseCase(this._searchRepository);

  @override
  Future<Either<Failure, List<TripComeWithYouEntity>>> call(
      SearchParams params) async {
    return await _searchRepository.fetchTripComeSearch(params);
  }
}
