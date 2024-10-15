import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/numberwidget.dart';
import 'package:fourtyninehub/features/carpool/join_trip/presentation/widgets/show_bottom_sheet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AvailableRoutesPointInfo extends StatelessWidget {
  const AvailableRoutesPointInfo({
    super.key,
    required this.dotNumber,
    this.status = '',
    this.inProgress = true,
    this.gender = 'male',
    required this.price,
    required this.isComfort,
  });
  final int dotNumber;
  final String status;
  final bool inProgress;
  final String gender;
  final String tripId;
  final String seatId;
  final List<double> userLocation;
  final num price;
  final bool isComfort;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.center,
            child: Text(
                status == "Free"
                    ? LocaleKeys.free.localize
                    : status == "Booked"
                        ? LocaleKeys.booked.localize
                        : "",
                style: Styles.headerText(
                    fontSize: 24,
                    color: status == "Free"
                        ? AppColors.SECONDARY_COLOR
                        : AppColors.PRIMARY_COLOR)),
          ),
        ),
        Expanded(
          flex: 7,
          child: _buildImageOrProgressWidget(context),
        ),
        // Expanded(flex: 1, child: Container(color: Colors.grey.withOpacity(0.3))),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: 5,
                    // height: 200,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 3),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        // color: status == "Free"
                        color: status == "Free"
                            ? AppColors.CHECK_MARK_COLOR
                            : status == "Booked"
                                ? Colors.grey
                                : Colors.blue
                        //     ? Colors.green
                        //     : dotNumber == 4
                        //         ? Colors.blue
                        //         : Colors.grey,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.only(top: 5),
            alignment: Alignment.center,
            child: NumberWidget(number: dotNumber),
          ),
        ),
      ],
    );
  }

  Widget _buildImageOrProgressWidget(BuildContext context) {
    // Show "In Progress" or "Finished" when dotNumber is 4
    if (dotNumber == 4) {
      return Center(
        child: Text(
          inProgress ? LocaleKeys.inProgress.localize : 'Finished',
          style: Styles.headerText(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (status.toLowerCase() == 'free') {
          showCreateRouteModalSheet(context,
          
              isComfort: isComfort, price: price);
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center, // Center the image and the border
          children: [
            // Create the red circular border
            if (status.toLowerCase() == 'free')
              Container(
                width: 65, // Size of the outer circle (border)
                height: 65, // Size of the outer circle (border)
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 3), // Red border
                ),
              ),
            // Display the image inside the circle
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Circle shape for the image
              ),
              child: Image.asset(
                width: status.toLowerCase() == 'free' ? 40 : 60,
                // Use the appropriate image based on status and gender
                status.toLowerCase() == 'free'
                    ? Assets.tripjoin
                    : gender.toLowerCase() == 'female'
                        ? Assets.femaleImagePlacehlder
                        : Assets.maleImagePlaceholder,
                fit: BoxFit.cover, // Cover the entire circle
              ),
            ),
          ],
        ),
      ),
    );
  }
}
