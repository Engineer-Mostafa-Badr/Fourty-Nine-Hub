import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../data/models/meal_model.dart';
import '../repositories/restaurant_details_repo.dart';

class GetMealsUseCase
    extends UseCase<List<MealModel>, int> {
  final RestaurantDetailsRepo _repo;
  GetMealsUseCase(this._repo);

  @override
  Future<Either<Failure, List<MealModel>>> call(int params) {
    return _repo.getMeals(restaurantId: params);
  }
}
