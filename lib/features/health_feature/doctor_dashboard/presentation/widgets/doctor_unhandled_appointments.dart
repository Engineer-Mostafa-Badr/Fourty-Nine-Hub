import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_dashboard/doctor_dashboard_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorUnhandledAppointmentsWidget extends StatelessWidget {
  const DoctorUnhandledAppointmentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: LocaleKeys.unhandledAppointments.localize,
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
              ]
          ),
          child: BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
            builder: (context, state) {
              if (state.unhandledAppointments!=null&&state.unhandledAppointments!.isNotEmpty) {
                print("state.unhandledAppointments!.isNotEmpty${state.unhandledAppointments!.isNotEmpty}");
                return Column(
                  children: [
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.unhandledAppointments!.length>2?2:state.unhandledAppointments!.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final appointment = state.unhandledAppointments![index];
                          return DoctorUnhandledAppointmentCard(
                            appointment: appointment,
                            onAccept: () => context
                                .read<DoctorDashboardCubit>()
                                .acceptAppointment(appointment.id,context),
                            onReject: () => context
                                .read<DoctorDashboardCubit>()
                                .rejectAppointment(appointment.id,context),
                          );
                        }),
                    const Sizer(),
                    if(state.unhandledAppointments!.length>2)AppButton(
                        label: LocaleKeys.showMore.localize,
                        style: Styles.mediumText(color: Colors.white),
                        onPressed: () {
                          context.push(Routes.DOCTORUNHANDLEDAPPOINTMENTS);
                        })
                  ],
                );
              }else{
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

class DoctorUnhandledAppointmentCard extends StatelessWidget {
  final DoctorAppointmentEntity appointment;
  final Function()? onAccept;
  final Function()? onReject;
  const DoctorUnhandledAppointmentCard(
      {super.key, required this.appointment, this.onAccept, this.onReject});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: SquareImage(
              url: appointment.image ?? UIConst.profilePlaceHolder,
            )),
        const Sizer(),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: appointment.fullName,
                style: Styles.headerText(),
              ),
              Label(
                text:
                    '${appointment.type.translatedName} - ${appointment.day.name}\n${appointment.startTime}',
                style: Styles.mediumText(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              AppButton(
                label: Labels.accept,
                color: Colors.white,
                onPressed: () => onAccept?.call(),
                backColor: AppColors.PRIMARY_COLOR,
              ),
              const Sizer(),
              AppButton(
                label: Labels.reject,
                color: Colors.white,
                onPressed: () => onReject?.call(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
