import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/enums/doctor_services.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/filter_option_entity.dart';
import 'package:go_router/go_router.dart';

class HealthOptionCard extends StatelessWidget {
  final HealthFilterOptionModel option;
  const HealthOptionCard({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(option.route, extra: option.service);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ]),
        child: Column(
          children: [
            Expanded(child: Image.asset(option.image)),
            Text(option.service.translatedName),
          ],
        ),
      ),
    );
  }
}
