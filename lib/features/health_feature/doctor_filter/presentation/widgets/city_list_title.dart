import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class CityListTitle extends StatelessWidget {
  final CityEntity city;
  const CityListTitle({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(city.nameEn),
      onTap: () {
        context.push(Routes.VISITADOCTORLISTBYLOCATION);
      },
    );
  }
}
