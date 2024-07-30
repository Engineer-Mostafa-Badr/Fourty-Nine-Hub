import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class SubcategoryListTitle extends StatelessWidget {
  final SubCategoryEntity specialty;
  const SubcategoryListTitle({super.key, required this.specialty});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        specialty.image,
      ),
      title: Text(specialty.name),
      onTap: () {
        serviceLocator<HealthSharedData>().doctorSearchParams.subCategory =
            specialty;
        if (serviceLocator<HealthSharedData>().doctorSearchParams.bookingType ==
            BookingTypes.call) {
          context.push(Routes.VISITADOCTORLIST);
        } else {
          context.push(Routes.FILTERDOCTORGOVERNORATE);
        }
      },
    );
  }
}
