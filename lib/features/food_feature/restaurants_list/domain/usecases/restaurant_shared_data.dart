import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_doctor_list_usecase.dart';

class RestaurantSharedData {
  List<FoodCategoryEntity> subCategories = [];

  List<GovernorateEntity> governorates = [];

  final DoctorSearchParams doctorSearchParams = DoctorSearchParams();
}
