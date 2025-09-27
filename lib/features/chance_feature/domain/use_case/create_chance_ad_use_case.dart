import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../data/model/create_chance_ad_model.dart';
import '../entity/chance_ad_entity.dart';
import '../repository/chance_repository.dart';

class CreateChanceAdUseCase {
  final ChanceRepository repository;

  CreateChanceAdUseCase(this.repository);

  Future<Either<Failure, ChanceAdEntity>> call(
      CreateChanceAdParams params) async {
    return await repository.createChanceAd(params);
  }
}

class CreateChanceAdParams {
  final String mainCategoryId;
  final String subCategoryId;
  final String title;
  final double price;
  final String description;
  final List<String> mediaIds;

  CreateChanceAdParams({
    required this.mainCategoryId,
    required this.subCategoryId,
    required this.title,
    required this.price,
    required this.description,
    required this.mediaIds,
  });

  CreateChanceAdModel toModel() {
    return CreateChanceAdModel(
      mainCategoryId: mainCategoryId,
      subCategoryId: subCategoryId,
      title: title,
      price: price,
      description: description,
      mediaIds: mediaIds,
    );
  }
}
