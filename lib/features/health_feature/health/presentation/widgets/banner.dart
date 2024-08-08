import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/core/enums/main_services_enum.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class HealthBanner extends StatelessWidget {
  const HealthBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthCubit, HealthState>(
      builder: (context, state) {
        return MainCategoryBanner(
            category: MainCategoryEntity(
              banner:
                  'https://49hub.s3.eu-central-1.amazonaws.com/DO/7143fb33-3a01-44b9-975a-71464a3cadde.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240808%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240808T090217Z&X-Amz-Expires=3600&X-Amz-Signature=f1b171f82a97eb7b1dd5a6795abfc832e5a13bf4263b8713a5e9b430e48fe98a&X-Amz-SignedHeaders=host&x-id=GetObject',
              id: MainServicesEnum.health.value(),
              name: MainServicesEnum.health.displayTitle,
              image: '',
              cover:
                  'https://49hub.s3.eu-central-1.amazonaws.com/DO/24def395-3161-445a-89bf-6238bd8bd380.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240808%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240808T090217Z&X-Amz-Expires=3600&X-Amz-Signature=a39a0cfb9b38bb7cef93314ebfa0aced5d155377d7f621edef97697f5cd79a4a&X-Amz-SignedHeaders=host&x-id=GetObject',
              isFavorite: false,
              total: 4897497645689,
            ),
            canRegister: state.isDoctor == true ? false : true,
            onRegister: () {
              if (context.read<UserCubit>().isLoggedIn) {
                context.push(Routes.CREATEDOCTOR);
              } else {
                context.push(Routes.REGISTER);
              }
            });
      },
    );
  }
}
