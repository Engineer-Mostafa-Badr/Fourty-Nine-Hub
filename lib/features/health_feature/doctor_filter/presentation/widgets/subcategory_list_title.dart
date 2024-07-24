import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/enums/doctor_services.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class SubcategoryListTitle extends StatelessWidget {
  final SubCategoryEntity specialty;
  final DoctorServices service;
  const SubcategoryListTitle(
      {super.key, required this.specialty, required this.service});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        specialty.image,
      ),
      title: Text(specialty.name),
      onTap: () {
        if (service == DoctorServices.CALL) {
          context.push(Routes.VISITADOCTORLISTBYCALL);
        } else {
          context.push(Routes.FILTERDOCTORGOVERNORATE);
        }
      },
    );
  }
}
