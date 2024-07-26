import 'package:flutter/material.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class CityListTitle extends StatelessWidget {
  final String city;
  const CityListTitle({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(city),
      onTap: () {
        context.push(Routes.FILTERDOCTORAREA);
      },
    );
  }
}
