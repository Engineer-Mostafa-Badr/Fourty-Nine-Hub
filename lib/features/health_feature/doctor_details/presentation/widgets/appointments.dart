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
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class DoctorDetailsAppointmentsCard extends StatelessWidget {
  const DoctorDetailsAppointmentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorDetailsCubit = context.read<DoctorDetailsCubit>();
    final List<AppointmentEntity> callsAppointments =
        (doctorDetailsCubit.state.doctor?.appointments ?? [])
            .where((element) => element.appointmentType == 'calls')
            .toList();
    final List<AppointmentEntity> visitHomeAppointments =
        (doctorDetailsCubit.state.doctor?.appointments ?? [])
            .where((element) => element.appointmentType == 'visitHome')
            .toList();
    final List<AppointmentEntity> clinicAppointments =
        (doctorDetailsCubit.state.doctor?.appointments ?? [])
            .where((element) => element.appointmentType == 'clinic')
            .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
            text: LocaleKeys.chooseBookingTime.localize,
            style: Styles.headerText()),
        const Sizer(),
        if (clinicAppointments.isNotEmpty || true) ...[
          const Sizer(),
          Text(LocaleKeys.clinicVisit.localize, style: Styles.mediumText()),
          const Sizer(),
          SizedBox(
            height: kToolbarHeight * 2.5,
            child: _DaysRow(appointments: clinicAppointments),
          )
        ],
        if (callsAppointments.isNotEmpty || true) ...[
          const Sizer(),
          Text(LocaleKeys.call.localize, style: Styles.mediumText()),
          const Sizer(),
          SizedBox(
            height: kToolbarHeight * 2.5,
            child: _DaysRow(appointments: callsAppointments),
          )
        ],
        if (visitHomeAppointments.isNotEmpty || true) ...[
          const Sizer(),
          Text(LocaleKeys.homeVisit.localize, style: Styles.mediumText()),
          const Sizer(),
          SizedBox(
            height: kToolbarHeight * 2.5,
            child: _DaysRow(appointments: visitHomeAppointments),
          )
        ],
      ],
    );
  }
}

bool isBeforeNow(String dateTimeString) {
  final dateTime = _safeParseDateTime(dateTimeString);
  if (dateTime == null) {
    return false;
  }
  return dateTime.isBefore(DateTime.now().toUtc());
}

String extractTime(String input) {
  return input.split(' ').first; // Extracts "10:00"
}

String extractPeriod(String input) {
  return input.split(' ').last; // Extracts "PM"
}

/// Safely parses a date string with multiple format support
DateTime? _safeParseDateTime(String dateTimeString) {
  try {
    // Handle ISO 8601 format with timezone (e.g., "2025-09-23T10:40:00.245Z")
    if (dateTimeString.contains('T') && dateTimeString.contains('Z')) {
      return DateTime.parse(dateTimeString);
    }

    // Handle ISO 8601 format without timezone (e.g., "2025-09-23T10:40:00")
    if (dateTimeString.contains('T')) {
      return DateTime.parse(dateTimeString);
    }

    // Handle regular date format (e.g., "2025-09-23")
    return DateTime.parse(dateTimeString);
  } catch (e) {
    print("Failed to parse date: $dateTimeString");
    print("Error: $e");
    return null;
  }
}

class _DaysRow extends StatelessWidget {
  final List<AppointmentEntity> appointments;
  const _DaysRow({required this.appointments});

  static const List<String> _daysOrder = [
    'saturday',
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _daysOrder.length,
      separatorBuilder: (context, _) => const Sizer(),
      itemBuilder: (context, index) {
        final dayKey = _daysOrder[index];
        final daySlots =
            appointments.where((a) => a.day.toLowerCase() == dayKey).toList();
        return _DaySlotsCard(dayKey: dayKey, slots: daySlots);
      },
    );
  }
}

class _DaySlotsCard extends StatelessWidget {
  final String dayKey;
  final List<AppointmentEntity> slots;
  const _DaySlotsCard({required this.dayKey, required this.slots});

  @override
  Widget build(BuildContext context) {
    final hasSlots = slots.isNotEmpty;
    final first = hasSlots ? slots.first : null;
    return Container(
      width: kToolbarHeight * 1.8,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: .5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: AppColors.PRIMARY_COLOR,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Label(
              text: dayKey.localize,
              textAlign: TextAlign.center,
              style: Styles.mediumText(color: Colors.white),
            ),
          ),
          Expanded(
            child: Center(
              child: hasSlots
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Label(
                          text:
                              "${context.isArabic ? 'من' : 'From'} ${first!.startTime}",
                          textAlign: TextAlign.center,
                          style: Styles.mediumText(),
                        ),
                        Label(
                          text:
                              "${context.isArabic ? 'إلى' : 'To'} ${first.endTime}",
                          textAlign: TextAlign.center,
                          style: Styles.mediumText(),
                        ),
                      ],
                    )
                  : Label(
                      text: context.isArabic
                          ? 'لا توجد مواعيد'
                          : 'No Available Slots',
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
          AppButton(
            label: LocaleKeys.book.localize,
            radius: 10,
            backColor: hasSlots
                ? AppColors.SECONDARY_COLOR
                : (context.isDarkMode
                    ? AppColors.DARK_GRAY_COLOR
                    : AppColors.LIGHT_GRAY_COLOR),
            onPressed: () {
              ManageVibration.vibrate();
              if (hasSlots) {
                context.read<DoctorDetailsCubit>().selectedAppointment = first!;
                context.push(Routes.VISITABOOKING,
                    extra: context.read<DoctorDetailsCubit>());
              }
            },
          ),
        ],
      ),
    );
  }
}
