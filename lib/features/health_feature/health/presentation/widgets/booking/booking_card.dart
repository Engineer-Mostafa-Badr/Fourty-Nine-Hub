import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/pages/DoctorDetails.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class HealthBookingCard extends StatelessWidget {
  final BookedAppointmentEntity appointment;
  HealthBookingCard({super.key, required this.appointment});

  final doctorSearchParams =
      serviceLocator<HealthSharedData>().doctorSearchParams;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      ManageVibration.vibrate();
        serviceLocator<HealthSharedData>().doctorSearchParams.bookingType =
            appointment.bookingType;
        serviceLocator<HealthSharedData>().doctorSearchParams.subCategory =
            appointment.doctor!.subCategory;
        context.push(Routes.VISITADOCTORDETAILS,
            extra: DoctorDetailsParams(
                doctorId: appointment.doctor!.id, fromSearch: false));

        // context.push(Routes.VISITADOCTORDETAILS, extra: DoctorDetailsParams(fromSearch: true, doctorId: appointment.doctor.id,type: appointment.bookingType.name,subCategoryId:appointment.doctor.subCategory.id));
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: AppColors.SHADOW,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Label(
                  text:
                      '${appointment.bookingType.translatedName} ${LocaleKeys.booking.localize}: ${appointment.day} - ${appointment.startTime}',
                  style:
                      Styles.mediumText(color: Theme.of(context).primaryColor)),
            ),
            const Divider(
              color: AppColors.DARK_GRAY_COLOR,
            ),
            Row(
              children: [
                SquareImage(
                  radius: 10,
                  height: kToolbarHeight,
                  width: kToolbarHeight,
                  url: appointment.doctor?.image??UIConst.profilePlaceHolder,
                ),
                const Sizer(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(
                        //TODO:delete
                          text: appointment.doctor?.fullName??'Ahmed Mohemd',
                          style: Styles.mediumText(
                              color: Theme.of(context).primaryColor)),
                      Label(
                        //TODO:delete
                          text: appointment.doctor?.description??'sfsdaf fsdafsfa fdsaf asfasdfsaf sdaff dsaf ',
                          style: Styles.mediumText(
                              color: AppColors.DARK_GRAY_COLOR)),
                    ],
                  ),
                ),
                AppButton(
                  label: LocaleKeys.cancel.localize,
                  padding: 15.w,
                  onPressed: () {
      ManageVibration.vibrate();
                    context
                        .read<HealthCubit>()
                        .cancelAppointment(appointment.id);
                  },
                  style: Styles.mediumText(color: Colors.white),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}