import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/format_numbers.dart';
import 'widgets/bottom_button_ride_status_widget.dart';
import 'widgets/driver_header_widget.dart';
import 'widgets/feedback_widget.dart';
import 'widgets/map_section.dart';

class RideStatusScreen extends StatelessWidget {
  const RideStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const driverName = 'Mohamed';
    const driverImage =
        'https://maps.gstatic.com/tactile/pane/default_geocode-2x.png';
    const carModel = 'Gray Hyundai Verna';
    const carNumber = '224 ع';
    // const price = 78;

    const rideStatus = 'You\'ll be Arriving in 15:40';

    return Scaffold(
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
                            const DriverHeaderWidget(
                              carModel: carModel,
                              carColor: "",
                              rideStatusWidget: SizedBox(),
                              carImageUrl: driverImage,
                              carName: driverName,
                              carNumber: carNumber,
                            ),
                            const Divider(
                              height: 2,
                            ),

                            ActionButtonsWidget(
                              driverImageUrl: driverImage,
                              driverRating: 12.2,
                              driverName: driverName,
                              onContactDriver: () {
                                context.push(Routes.ratingClientScreen);
                              },
                              onSafety: () {
                                context.push(Routes.rideArrivedScreen);
                              },
                              is_show_message: true,
                              onMessage: () {},
                            ),
                            const Divider(
                              height: 2,
                            ),

                            const FeedbackWidget(),
                            const Divider(
                              height: 2,
                            ),

                            // PaymentInfoWidget(price: price),
                            //

                            // LocationInfoWidget(
                            //   from: 'أول العاشر من رمضان',
                            //   to: 'المنطقة الصناعية الثالثة العاشر من رمضان (10th of Ramadan City 1) العالمية',
                            // ),

                            BottomRideStatusWidget(
                              price: 200,
                              isStarted: true,
                              onStartRecord: () {
                                // cubit.startRecord();
                              },
                              onStopRecord: () {
                                // cubit.stopRecord(context: context, subcategoryId: state.activeTrip?.subCategoryId ?? '', tripId: state.activeTrip?.tripId ?? '');
                              },
                              fromLocation: 'أول العاشر من رمضان',
                              toLocation:
                                  'المنطقة الصناعية الثالثة العاشر من رمضان (10th of Ramadan City 1) العالمية',
                              onGoogleMap: () {},
                              showOTP: false,
                              showCancelButton: false,
                              onPartialPayment: () {},
                              onCallEmergency: () {},
                              onCancelRide: () {},
                              isRecording: true,
                              audioDuration: '',
                              onMicTap: () {},
                              paymentMethod: "cash",
                              wayPointOne: null,
                              wayPointTwo: null,
                              otp: "",
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

class ActionButtonsWidget extends StatelessWidget {
  final String? driverImageUrl;
  final double? driverRating;
  final String driverName;
  final VoidCallback onContactDriver;
  final VoidCallback onSafety;
  final VoidCallback? onMessage;
  final bool? is_show_message;
  const ActionButtonsWidget({
    super.key,
    required this.driverImageUrl,
    required this.driverRating,
    required this.driverName,
    required this.onContactDriver,
    this.is_show_message = false,
    required this.onSafety,
    this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildDriverCircle(
            driverImageUrl: driverImageUrl,
            driverName: driverName,
            driverRating: driverRating,
            context: context,
          ),
          _buildActionCircle(
            icon: Icons.phone,
            label: context.isArabic ? 'اتصل بالعميل' : 'Contact Client',
            onTap: onContactDriver,
          ),
          _buildActionCircle(
            icon: Icons.messenger_outline,
            label: LocaleKeys.message.localize,
            onTap: onMessage ?? () {},
          ),
          _buildActionCircle(
            icon: Icons.security,
            label: LocaleKeys.safety.localize,
            onTap: onSafety,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCircle({
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
}

Widget buildDriverCircle({
  required String? driverImageUrl,
  required String driverName,
  required double? driverRating,
  required BuildContext context,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Stack(
        alignment: Alignment.topRight,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppColors.buttonDialog,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: ImageFromInternet(
                image: driverImageUrl ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Positioned(
            bottom: 4,
            right: 0,
            child: Icon(Icons.verified, color: Colors.blue, size: 16),
          ),
          if (driverRating != null)
            if (driverRating > 0)
              Positioned(
                top: 4,
                right: -16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        FormatNumbers().convertNumberToLocalizedString(
                            driverRating.toStringAsFixed(1),
                            isArabic: context.isArabic),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
      const SizedBox(height: 4),
      Text(
        driverName,
        style: const TextStyle(fontSize: 12),
      ),
    ],
  );
}
