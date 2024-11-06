import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/food_order_entity.dart';

import '../repositories/restaurant_dashboard_repo.dart';

class UpdateRestaurantUseCase
    extends UseCase<bool, UpdateRestaurantParams> {
  final RestaurantDashboardRepo _repository;

  const UpdateRestaurantUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(UpdateRestaurantParams params) {
    return _repository.updateRestaurant(params);
  }
}

class UpdateRestaurantParams{
  final String? name;
  final String? number;
  final String? subcategoryId;
  final List<String>? restaurantMedia;
  final String? government;
  final String? city;

  UpdateRestaurantParams({ this.name,  this.number,this.subcategoryId,  this.restaurantMedia,  this.government,  this.city});

  //toJson
  Map<String, dynamic> toJson() => {
    if (name != null) "name": name,
    if (number != null) "phone": number,
    if (subcategoryId != null) "subcategoryId": subcategoryId,
    if (restaurantMedia != null)
      "restaurantMedia": restaurantMedia,
    // if (licenseMedia!=null) "licenseMedia": licenseMedia,
    if (government != null) "government": government,
    if (city != null) "city": city,
  };
}