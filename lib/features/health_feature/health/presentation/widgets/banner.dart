import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/enums/main_services_enum.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class HealthBanner extends StatelessWidget {
  const HealthBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      decoration: BoxDecoration(
          color: AppColors.YELLOW_COLOR,
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(MainServicesEnum.health.banner),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.favorite_border,
            color: AppColors.SECONDARY_COLOR,
          ),
          Text(
            'Health',
            style: Styles.headerText(color: AppColors.DARK_BLUE_COLOR),
          ),
          Text('Register',
              style: Styles.smallText(color: AppColors.DARK_BLUE_COLOR)),
        ],
      ),
    );
  }
}
