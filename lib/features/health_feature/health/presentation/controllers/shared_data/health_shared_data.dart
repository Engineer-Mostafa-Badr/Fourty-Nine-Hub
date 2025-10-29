import 'package:fourtyninehub/features/health_feature/shared/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/city_entity.dart';
import 'package:fourtyninehub/features/health_feature/fast_booking/domain/usecases/get_doctor_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';

class HealthSharedData {
  List<HealthSubcategoryEntity> subCategories = [];

  List<GovernorateEntity> governorates = [];

  final DoctorSearchParams doctorSearchParams = DoctorSearchParams();
}
