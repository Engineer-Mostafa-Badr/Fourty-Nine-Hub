import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_doctor_list_usecase.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';

class HealthSharedData {
  List<SubCategoryModel> subCategories = [];

  List<GovernorateEntity> governorates = [];

  final  DoctorSearchParams doctorSearchParams = DoctorSearchParams();
}
