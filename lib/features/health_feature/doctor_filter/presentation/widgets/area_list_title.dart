import 'package:flutter/material.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class AreaListTitle extends StatelessWidget {
  final String area;
  const AreaListTitle({
    super.key,
    required this.area,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(area),
      onTap: () {
        context.push(Routes.VISITADOCTORLISTBYLOCATION);
      },
    );
  }
}
