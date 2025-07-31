import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class DoctorDetailsAppointmentsCard extends StatelessWidget {
  const DoctorDetailsAppointmentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorDetailsCubit = context.read<DoctorDetailsCubit>();
    final doctor = doctorDetailsCubit.state.doctor;
    final List<AppointmentEntity> callsAppointments = (doctorDetailsCubit.state
        .doctor?.appointments??[])
        .where((element) => element.appointmentType == 'calls')
        .toList();
    final List<AppointmentEntity> visitHomeAppointments = (doctorDetailsCubit
        .state.doctor?.appointments??[])
        .where((element) => element.appointmentType == 'visitHome')
        .toList();
    final List<AppointmentEntity> clinicAppointments = (doctorDetailsCubit.state.doctor?.appointments??[]).where((element) => element.appointmentType == 'clinic')
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
            text: LocaleKeys.chooseBookingTime.localize,
            style: Styles.headerText()),
        const Sizer(),
        if (clinicAppointments.isNotEmpty) ...[
          const Sizer(),
          Text(LocaleKeys.clinicVisit.localize, style: Styles.mediumText()),
          const Sizer(),
          SizedBox(
              height: kToolbarHeight * 2.5,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: clinicAppointments.length,
                itemBuilder: (context, index) {
                  return _DayScheduleWidget(
                    item: clinicAppointments[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Sizer(),
              ))
        ],
        if (callsAppointments.isNotEmpty) ...[
          const Sizer(),
          Text(LocaleKeys.call.localize, style: Styles.mediumText()),
          const Sizer(),
          SizedBox(
              height: kToolbarHeight * 2.5,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: callsAppointments.length,
                itemBuilder: (context, index) {
                  return _DayScheduleWidget(
                    item: callsAppointments[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Sizer(),
              ))
        ],
        if (visitHomeAppointments.isNotEmpty) ...[
          const Sizer(),
          Text(LocaleKeys.homeVisit.localize, style: Styles.mediumText()),
          const Sizer(),
          SizedBox(
              height: kToolbarHeight * 2.5,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: visitHomeAppointments.length,
                itemBuilder: (context, index) {
                  return _DayScheduleWidget(
                    item: visitHomeAppointments[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Sizer(),
              ))
        ],
      ],
    );
  }
}

bool isBeforeNow(String dateTimeString) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return dateTime.isBefore(DateTime.now().toUtc());
  } catch (e) {
    print("Invalid date string: $e");
    return false;
  }
}

String extractTime(String input) {
  return input.split(' ').first; // Extracts "10:00"
}

String extractPeriod(String input) {
  return input.split(' ').last; // Extracts "PM"
}

bool _isTimeOfDayAfter(String dateTimeString) {
  final dateTime = DateTime.parse(dateTimeString);
  final now = DateTime.now().toUtc();
  TimeOfDay t1 = TimeOfDay.fromDateTime(dateTime);
  TimeOfDay t2 = TimeOfDay.now();
  if (dateTime.day > now.day) {
    return true;
  } else if (dateTime.day == now.day) {
    return (t1.hour > t2.hour) || (t1.hour == t2.hour && t1.minute > t2.minute);
  } else {
    return false;
  }
}

class _DayScheduleWidget extends StatelessWidget {
  final AppointmentEntity item;
  const _DayScheduleWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kToolbarHeight * 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: .5,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
                color: AppColors.PRIMARY_COLOR,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Label(
                text: item.day.localize,
                textAlign: TextAlign.center,
                style: Styles.mediumText(color: Colors.white)),
          ),
          Expanded(
              child: Center(
            child: Label(
              text:
                  "${extractTime(item.startTime)} ${(extractPeriod(item.startTime).toLowerCase() == 'pm') ? (context.isArabic ? 'مساءا' : 'PM') : (context.isArabic ? 'صباحا' : 'AM')}",
              textAlign: TextAlign.center,
            ),
          )),
          AppButton(
              label: LocaleKeys.book.localize,
              backColor: (item.isAvailable && _isTimeOfDayAfter(item.dateOfDay))
                  ? AppColors.SECONDARY_COLOR
                  : (context.isDarkMode
                      ? AppColors.DARK_GRAY_COLOR
                      : AppColors.LIGHT_GRAY_COLOR),
              onPressed: () {
                if (item.isAvailable) {
                  context.read<DoctorDetailsCubit>().selectedAppointment = item;
                  context.push(Routes.VISITABOOKING,
                      extra: context.read<DoctorDetailsCubit>());
                }
              })
        ],
      ),
    );
  }
}
