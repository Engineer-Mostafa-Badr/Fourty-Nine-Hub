import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_details_entity.dart';
import 'package:fourtyninehub/features/azkaar/domain/repository/azkar_repository.dart';

class FetchDetailsAzkarUseCase
    extends UseCase<List<AzkarDetailsEntity>, AzkarDetailsParams> {
  final AzkarRepository _azkarRepository;

  FetchDetailsAzkarUseCase(this._azkarRepository);
  @override
  Future<Either<Failure, List<AzkarDetailsEntity>>> call(
      AzkarDetailsParams params) async {
    return await _azkarRepository.fetchAzkarDetail(params);
  }
}

class AzkarDetailsParams {
  final int page;
  final int limit;
  final String category;

  AzkarDetailsParams(
      {required this.page, required this.limit, required this.category});
}
