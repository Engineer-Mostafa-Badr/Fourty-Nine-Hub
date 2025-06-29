import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_status_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/location_info_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/map_section.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class RideArrivedScreen extends StatelessWidget {
  const RideArrivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const driverName = 'Mohamed';
    const driverImage =
        'https://maps.gstatic.com/tactile/pane/default_geocode-2x.png';

    return Scaffold(
      // خريطة في الخلفية مثلاً
      body: SafeArea(
        child: SharedScaffold(
          mainCategoryId: 2,
          body: Stack(
            children: [
              const MapSection(),
              DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.2,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ActionButtonsWidget(
                              driverImageUrl: driverImage,
                              driverRating: 12.2,
                              driverName: driverName,
                              onContactDriver: () {
                                context.push(Routes.ratingDriverScreen);
                              },
                              onSafety: () {
                                context.push(Routes.ratingClientScreen);
                              },
                              is_show_message: true,
                              onMessage: () {
                                context.push(Routes.completeRideScreen);
                              },
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
                                LocaleKeys.reportClient.localize,
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

                            // PaymentInfoWidget(price: price),
                            //

                            LocationInfoWidget(
                              from: 'أول العاشر من رمضان',
                              to: 'المنطقة الصناعية الثالثة العاشر من رمضان (10th of Ramadan City 1) العالمية',
                            ),
                            CustomRideButton(text: "I've Arrived",onPressed: (){},),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10, // المسافة بين الأزرار
                              runSpacing: 10, // المسافة بين الصفوف
                              alignment: WrapAlignment.center,
                              children: [
                                CustomRideButton(text: "Im Here"),
                                CustomRideButton(text: "Hello"),
                                CustomRideButton(text: "Where are You?"),
                                CustomRideButton(text: "Yes"),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.info_outline,
                                        color: Colors.black54),
                                    const SizedBox(width: 5),
                                    Text(
                                      "Travel time: ~14 min. Distance: 6.58 Km.",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                LocaleKeys.cancelTheRide.localize,
                                style: const TextStyle(
                                  fontSize: FontSize.s16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.PRIMARY_COLOR_DARK,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomRideButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomRideButton({super.key, required this.text,this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
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
