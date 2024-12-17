import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/repositories/restaurant_details_repo.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';


class AddFoodUseCase
    extends UseCase<RestaurantMenu, AddFoodParams> {
  final RestaurantDetailsRepo _repository;

  const AddFoodUseCase(this._repository);

  @override
  Future<Either<Failure, RestaurantMenu>> call(AddFoodParams params) {
    return _repository.addFood(params:params);
  }
}

class AddFoodParams{
  final String photo;
  final double price;
  final String foodName;

  AddFoodParams({required this.photo, required this.price, required this.foodName});

  Map<String, dynamic> toJson() => {
    "picture": photo,
    "price": price,
    "foodName": foodName
  };
}
