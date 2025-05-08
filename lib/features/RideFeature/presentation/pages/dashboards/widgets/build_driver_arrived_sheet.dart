import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_arrived_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_status_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/location_info_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class BuildDriverArrivedSheet extends StatelessWidget {
  const BuildDriverArrivedSheet({super.key, required this.onPressed});
  final Function(String) onPressed;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.76,
      minChildSize: 0.2,
      maxChildSize: 0.76,
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
                    driverImageUrl: "driverImage",
                    driverRating: 12.2,
                    driverName: "Driver Name",
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

                  const SizedBox(
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
                      context.isArabic ? "تقرير العميل" : "Report Client",
                      style: const TextStyle(
                        fontSize: FontSize.s16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.PRIMARY_COLOR_DARK,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // PaymentInfoWidget(price: price),
                  //
                  const LocationInfoWidget(
                    from: 'أول العاشر من رمضان',
                    to: 'المنطقة الصناعية الثالثة العاشر من رمضان (10th of Ramadan City 1) العالمية',
                  ),
                  CustomRideButton(text: "I've Arrived",onPressed: (){
                    onPressed('iveArrived');
                  },),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10, // المسافة بين الأزرار
                    runSpacing: 10, // المسافة بين الصفوف
                    alignment: WrapAlignment.center,
                    children: [
                      CustomRideButton(text: "Im Here",onPressed: (){
                        onPressed('imHere');
                      },),
                      CustomRideButton(text: "Hello",onPressed: (){
                        onPressed('hello');
                      },),
                      CustomRideButton(text: "Where are You?",onPressed: (){
                        onPressed('whereAreYou');
                      },),
                      CustomRideButton(text: "Yes",onPressed: (){
                        onPressed('yes');
                      },),
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.black54),
                          SizedBox(width: 5),
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
    );
  }
}
