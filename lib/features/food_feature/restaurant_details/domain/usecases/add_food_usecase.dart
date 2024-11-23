import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/repositories/restaurant_details_repo.dart';

class AddFoodUseCase extends UseCase<bool, AddFoodParams> {
  final RestaurantDetailsRepo _repository;

  const AddFoodUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(AddFoodParams params) {
    return _repository.addFood(params: params);
  }
}

class AddFoodParams {
  final String photo;
  final double price;
  final String foodName;

  AddFoodParams(
      {required this.photo, required this.price, required this.foodName});

  Map<String, dynamic> toJson() =>
      {"picture": photo, "price": price, "foodName": foodName};
}
