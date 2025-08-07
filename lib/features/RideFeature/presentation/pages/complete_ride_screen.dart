import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/location_info_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/map_section.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

Widget buildActionCircle({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: AppColors.buttonDialog,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 28,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ),
  );
}

class CompleteRideScreen extends StatelessWidget {
  const CompleteRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SharedScaffold(
          mainCategoryId: 2,
          body: Stack(
            children: [
              const MapSection(),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            buildActionCircle(
                              icon: Icons.security,
                              label: LocaleKeys.safety.localize,
                              onTap: () {
                                ManageVibration.vibrate();
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                // width: double.infinity,
                                height: 45,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  LocaleKeys.reportClient.localize,
                                  style: const TextStyle(
                                    fontSize: FontSize.s16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.PRIMARY_COLOR_DARK,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 8,
                        ),

                        SizedBox(
                          height: 8,
                        ),

                        // PaymentInfoWidget(price: price),
                        //

                        LocationInfoWidget(
                          from: 'أول العاشر من رمضان',
                          to: 'المنطقة الصناعية الثالثة العاشر من رمضان (10th of Ramadan City 1) العالمية',
                        ),

                        // const SizedBox(height: 12),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Text(
                                "100 Egy",
                                style: TextStyle(
                                    color: Colors.red, fontSize: FontSize.s16),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: double.infinity,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            LocaleKeys.completeRide.localize,
                            style: const TextStyle(
                              fontSize: FontSize.s16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.PRIMARY_COLOR_DARK,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: double.infinity,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.PRIMARY_COLOR,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            LocaleKeys.completeRide.localize,
                            style: const TextStyle(
                              fontSize: FontSize.s16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomRideButton extends StatelessWidget {
  final String text;
  const CustomRideButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          ManageVibration.vibrate();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // لون الخلفية
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // تدوير الزوايا
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
