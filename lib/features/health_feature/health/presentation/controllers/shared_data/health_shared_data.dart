import 'package:fourtyninehub/core/enums/main_services_enum.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_doctor_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';

class HealthSharedData {
  List<HealthSubcategoryEntity> subCategories = [];

  List<GovernorateEntity> governorates = [];

  final DoctorSearchParams doctorSearchParams = DoctorSearchParams();

  MainCategoryEntity mainCategory = MainCategoryEntity(
    id: MainServicesEnum.health.value(),
    name: MainServicesEnum.health.displayTitle,
    image: '',
    banner:
        "https://49hub.s3.eu-central-1.amazonaws.com/DO/7143fb33-3a01-44b9-975a-71464a3cadde.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240808%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240808T132013Z&X-Amz-Expires=3600&X-Amz-Signature=c35ddf3ee6059abef6956d8fe73ad2905552acd5d1532a858cf14d1b6cc88288&X-Amz-SignedHeaders=host&x-id=GetObject",
    cover:
        'https://49hub.s3.eu-central-1.amazonaws.com/DO/24def395-3161-445a-89bf-6238bd8bd380.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240808%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240808T090217Z&X-Amz-Expires=3600&X-Amz-Signature=a39a0cfb9b38bb7cef93314ebfa0aced5d155377d7f621edef97697f5cd79a4a&X-Amz-SignedHeaders=host&x-id=GetObject',
    isFavorite: false,
    total: 4897497645689,
  );
}
