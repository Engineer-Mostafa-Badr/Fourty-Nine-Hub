import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_entity.dart';
import 'package:fourtyninehub/features/azkaar/domain/repository/azkar_repository.dart';

class FetchAzkarUseCase extends UseCase<List<AzkarEntity>,AzkarParams>{
  final AzkarRepository _azkarRepository;

  FetchAzkarUseCase(this._azkarRepository);
  @override
  Future<Either<Failure, List<AzkarEntity>>> call(AzkarParams params) async{
    return await _azkarRepository.fetchAzkar(params);
  }
}

class AzkarParams{
  final int page;
  final int limit;

  AzkarParams({required this.page, required this.limit});

}