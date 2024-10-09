import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/get_all_counts_usecase.dart';
import 'package:fourtyninehub/features/chance_feature/domain/repository/chance_repository.dart';

class AddChanceUseCase extends UseCase<bool, AddChanceParams> {
  final ChanceRepository _chanceRepository;

  AddChanceUseCase(this._chanceRepository);

  @override
  Future<Either<Failure, bool>> call(AddChanceParams params) async {
    return await _chanceRepository.addChance(params);
  }
}

class AddChanceParams {
  String title;
  int price;
  List<String> images;
  String description;
  String subCategoryId;
  String mainCategoryId;

  AddChanceParams({
    required this.title,
    required this.price,
    required this.images,
    required this.description,
    required this.subCategoryId,
    required this.mainCategoryId,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'price': price,
    'images': images,
    'description': description,
    'subCategoryId': subCategoryId,
    'mainCategoryId': mainCategoryId,
  };
}
