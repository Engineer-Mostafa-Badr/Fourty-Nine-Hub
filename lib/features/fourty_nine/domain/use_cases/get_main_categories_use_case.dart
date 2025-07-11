import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';

import '../repositories/fourty_nine_repository.dart';

class GetMainCategoriesUseCase
    extends UseCase<List<MainCategoryEntity>, MainCategoriesParams> {
  final FourtyNineRepository _fourtyNineRepository;

  GetMainCategoriesUseCase(this._fourtyNineRepository);

  @override
  Future<Either<Failure, List<MainCategoryEntity>>> call(
    MainCategoriesParams params,
  ) {
    return _fourtyNineRepository.getMainCategories(params);
  }
}

class MainCategoriesParams {
  final int page;
  final int limit;
  final String userId;

  MainCategoriesParams(
      {required this.page, required this.limit, required this.userId});
  Map<String, dynamic> toJson() {
    String? id = UserCubit.to.state.data?.id??'';
    return {
        'page': page,
        'limit': limit,
        if (id.isNotEmpty) 'userId': id,
      };
  }
}
