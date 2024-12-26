import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_dashboard/doctor_dashboard_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorTodayAppointmentsWidget extends StatelessWidget {
  const DoctorTodayAppointmentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: LocaleKeys.todayAppointments.localize,
          style: Styles.headerText(),
        ),
        const Sizer(),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: cardDarkColor(context),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ]),
          child: BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
            builder: (context, state) {
              if (state.todayAppointments != null &&
                  state.todayAppointments!.isNotEmpty) {
                return Column(
                  children: [
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.todayAppointments!.length > 2
                          ? 2
                          : state.todayAppointments!.length,
                      itemBuilder: (context, index) => DoctorAppointmentCard(
                        appointment: state.todayAppointments![index],
                        cancelAppointment: (id) {
                          context
                              .read<DoctorDashboardCubit>()
                              .cancelAppointment(id, context);
                        },
                      ),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ),
                    if (state.todayAppointments!.length > 2)
                      AppButton(
                          label: LocaleKeys.showMore.localize,
                          style: Styles.mediumText(color: Colors.white),
                          onPressed: () {
                            context.push(Routes.DOCTORTODAYAPPOINTMENTS);
                          })
                  ],
                );
              } else {
                return Center(
                    child: Text(
                  LocaleKeys.noAppointments.localize,
                  style: Styles.headerText(
                      color: Theme.of(context).textTheme.bodyMedium?.color),
                ));
              }
            },
          ),
        ),
      ],
    );
  }
}

class DoctorAppointmentCard extends StatelessWidget {
  final DoctorAppointmentEntity appointment;
  final Function(String id) cancelAppointment;
  const DoctorAppointmentCard(
      {super.key, required this.appointment, required this.cancelAppointment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                ImageFromInternet(
                  width: 120.w,
                  height: 100.h,
                  image: appointment.image ?? '',
                  borderRadius: BorderRadius.circular(15.r),
                  defaultLogo: true,
                  fit: BoxFit.cover,
                ),
                const Sizer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.firstName,
                      style: Styles.headerText(
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                    const Sizer(),
                    Text(
                      appointment.type.translatedName,
                      style: Styles.headerText(
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                  ],
                )
              ],
            ),
          ),
          Column(
            children: [
              Text(appointment.startTime),
              const Sizer(),
              AppButton(
                  label: LocaleKeys.cancel.localize,
                  color: Colors.white,
                  padding: 15.w,
                  backColor: AppColors.PRIMARY_COLOR,
                  onPressed: () {
                    cancelAppointment(appointment.id);
                  })
            ],
          ),
        ],
      ),
    );
    // return ListTile(
    //   title: Text(
    //     appointment.type.translatedName,
    //     style: TextStyle(color: Theme.of(context).primaryColor),
    //   ),
    //   subtitle: Text(appointment.startTime),
    // );
  }
}
