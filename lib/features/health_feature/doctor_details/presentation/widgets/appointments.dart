import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/divider.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class DoctorDetailsAppointmentsCard extends StatelessWidget {
  const DoctorDetailsAppointmentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorDetailsCubit = context.read<DoctorDetailsCubit>();
    final doctor = doctorDetailsCubit.doctor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(text: Labels.chooseBookingTime, style: Styles.headerText()),
        const Sizer(),
        SizedBox(
            height: kToolbarHeight * 2.5,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: doctor.appointments.length,
              itemBuilder: (context, index) {
                return _DayScheduleWidget(
                  item: doctor.appointments[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Sizer(),
            )),
        const DoctorDetailsDivider(),
      ],
    );
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
                text: item.day,
                textAlign: TextAlign.center,
                style: Styles.mediumText(color: Colors.white)),
          ),
          Expanded(
              child: Center(
            child: Label(
              text: item.time,
              textAlign: TextAlign.center,
            ),
          )),
          AppButton(
              label: Labels.book,
              backColor: item.isAvailable
                  ? AppColors.SECONDARY_COLOR
                  : AppColors.LIGHT_GRAY_COLOR,
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
