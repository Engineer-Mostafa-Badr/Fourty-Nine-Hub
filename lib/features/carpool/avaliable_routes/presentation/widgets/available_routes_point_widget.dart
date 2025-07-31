import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/numberwidget.dart';
import 'package:fourtyninehub/features/carpool/join_trip/presentation/widgets/show_bottom_sheet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class AvailableRoutesPointInfo extends StatelessWidget {
  AvailableRoutesPointInfo(
      {super.key,
      required this.dotNumber,
      this.status = '',
      this.inProgress = true,
      this.gender = 'male',
      required this.price,
      required this.isComfort,
      required this.tripId,
      required this.seatId,
      required this.userLocation,
      required this.createdAt,
      required this.tripStatus,
      required this.defaultGender,
      required this.entity,
      required this.otpVerified});
  final int dotNumber;
  final String status;
  final DateTime createdAt;
  final bool inProgress;
  final String gender;
  final String defaultGender;
  final String tripId;
  final String seatId;
  final List<double> userLocation;
  final String tripStatus;
  final bool otpVerified;
  final num price;

  final bool isComfort;
  final CarpoolTripParam entity;
  final userId = serviceLocator<UserCubit>().state.data?.id ?? '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.center,
            child: Text(
                status == "Free" && tripStatus == "expired"
                    ? context.isArabic
                        ? "كان متاحا"
                        : "ًWas free"
                    : status == "Free" && tripStatus == "Completed"
                        ? ""
                        : status == "Free"
                            ? LocaleKeys.free.localize
                            : status == "Booked"
                                ? LocaleKeys.booked.localize
                                : "",
                style: Styles.headerText(
                  fontSize: 24,
                  color: status == "Free"
                      ? AppColors.SECONDARY_COLOR
                      : context.isDarkMode
                          ? AppColors.LIGHT_COLOR
                          : AppColors.PRIMARY_COLOR,
                )),
          ),
        ),
        Expanded(
          flex: 7,
          child: _buildImageOrProgressWidget(context,
              createdAt: createdAt, entity: entity),
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
                        color: status == "Free" || otpVerified
                            ? AppColors.CHECK_MARK_COLOR
                            : status == "Booked"
                                ? Colors.grey
                                : Colors.blue),
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

  Widget _buildImageOrProgressWidget(BuildContext context,
      {required final DateTime createdAt, required CarpoolTripParam entity}) {
    // Show "In Progress" or "Finished" when dotNumber is 4
    if (dotNumber == 4) {
      return Center(
        child: Text(
          tripStatus == "Pending"
              ? LocaleKeys.inProgress.localize
              : tripStatus == "expired"
                  ? LocaleKeys.expired.localize
                  : tripStatus == "Running"
                      ? LocaleKeys.running.localize
                      : tripStatus == "Completed"
                          ? LocaleKeys.completed.localize
                          : LocaleKeys.inProgress.localize,
          // inProgress ? LocaleKeys.inProgress.localize : 'Finished',
          style: Styles.headerText(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (status.toLowerCase() == 'free') {
          if(!context.read<UserCubit>().isLoggedIn){
            return pleaseLoginDialog(context);
          }
               tripStatus != "expired" && tripStatus != "Completed"
                  ? context.read<UserCubit>().isLoggedIn &&
                          entity.locations[0].bookedUser?.id != userId &&
                          entity.locations[1].bookedUser?.id != userId &&
                          entity.locations[2].bookedUser?.id != userId
                      ? showCreateRouteModalSheet(context,
                          seatId: seatId,
                          tripId: tripId,
                          userLocation: userLocation,
                          isComfort: isComfort,
                          price: price)
                      : const SizedBox()
                  : const SizedBox();
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (status.toLowerCase() == 'free')
              tripStatus != "expired" && tripStatus != "Completed"
                  ? context.read<UserCubit>().isLoggedIn &&
                          entity.locations[0].bookedUser?.id != userId &&
                          entity.locations[1].bookedUser?.id != userId &&
                          entity.locations[2].bookedUser?.id != userId
                      ? Container(
                          width: 65, // Size of the outer circle (border)
                          height: 65, // Size of the outer circle (border)
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.red, width: 3), // Red border
                          ),
                        )
                      : const SizedBox()
                  : const SizedBox(),
            // Display the image inside the circle
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle, // Circle shape for the image
              ),
              child: tripStatus == "Completed"
                  ? Image.asset(
                      width: 60,

                      defaultGender.toLowerCase() == 'female'
                          ? Assets.femaleImagePlacehlder
                          : Assets.maleImagePlaceholder,
                      fit: BoxFit.cover, // Cover the entire circle
                    )
                  : status.toLowerCase() == 'free'
                      ? Image.asset(
                          width: 40,

                          Assets.tripjoin,
                          fit: BoxFit.cover, // Cover the entire circle
                        )
                      : context.read<UserCubit>().isLoggedIn &&
                                  entity.locations[0].bookedUser?.id ==
                                      userId &&
                                  dotNumber == 1 ||
                              entity.locations[1].bookedUser?.id == userId &&
                                  dotNumber == 2 ||
                              entity.locations[2].bookedUser?.id == userId &&
                                  dotNumber == 3
                          ? Image.network(
                              serviceLocator<UserCubit>().state.data != null
                                  ? serviceLocator<UserCubit>()
                                      .state
                                      .data!
                                      .profilePicture!
                                  : UIConst.profilePlaceHolder,
                              width: 60,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              width: 60,

                              gender.toLowerCase() == 'female'
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
