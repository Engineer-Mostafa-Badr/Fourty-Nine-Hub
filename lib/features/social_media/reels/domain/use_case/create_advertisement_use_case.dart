import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../repositories/reels_repository.dart';

class CreateAdvertisementUseCase
    extends UseCase<bool, CreateAdvertisementParams> {
  final ReelsRepository _repository;

  CreateAdvertisementUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(CreateAdvertisementParams params) {
    return _repository.createAdvertisement(params);
  }
}

class CreateAdvertisementParams {
  final List<String> mediaIds;
  final String type;
  final double totalPrice;

  CreateAdvertisementParams(
      {required this.mediaIds, required this.type, required this.totalPrice});

  Map<String, dynamic> toJson() => {
        "media": mediaIds,
        "advertisement_type": type,
        "totalPrice": totalPrice,
      };
}
