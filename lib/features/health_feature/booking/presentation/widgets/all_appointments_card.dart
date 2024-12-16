import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/entities/all_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/cubit/all_appointments_cubit/all_appointments_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AllAppointmentsCard extends StatelessWidget {
  const AllAppointmentsCard({super.key, required this.appointment});
  final AllAppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                text: '${appointment.appointmentType.toBookingType.translatedName} ${LocaleKeys.booking.localize}: \n${LocaleKeys.from.localize} ${appointment.startTime} ${LocaleKeys.to.localize} ${appointment.endTime}',
                style: Styles.mediumText(color: Theme.of(context).primaryColor)),
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
                source: AssetImage(appointment.gender=='male'?Assets.maleImagePlaceholder:Assets.femaleImagePlacehlder),
              ),
              const Sizer(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                        text: appointment.firstName,
                        style: Styles.mediumText(
                            color: Theme.of(context).primaryColor)),
                    Label(
                        text: appointment.additionalNotes,
                        style: Styles.mediumText(
                            color: AppColors.DARK_GRAY_COLOR)),
                  ],
                ),
              ),
            ],
          ),
          const Sizer(),
          if(appointment.status=='pending')Row(
            children: [
              Expanded(
                child: AppButton(label: LocaleKeys.Accept.localize,backColor: AppColors.PRIMARY_COLOR,padding: 30.w, onPressed: (){
                  context.read<AllAppointmentsCubit>().acceptAppointment(appointment.id, context);
                },style: Styles.mediumText(color: Colors.white),),
              ),
              const Sizer(),
              Expanded(
                child: AppButton(label: LocaleKeys.reject.localize,backColor: AppColors.SECONDARY_COLOR,padding: 30.w, onPressed: (){
                  context.read<AllAppointmentsCubit>().rejectAppointment(appointment.id, context);
                },style: Styles.mediumText(color: Colors.white),),
              )
            ],
          ),
          if(appointment.status=='rejected')Center(child: Label(text: LocaleKeys.rejectedAppointment.localize,style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),)),
          if(appointment.status=='accepted')AppButton(label: LocaleKeys.cancel.localize,backColor: AppColors.PRIMARY_COLOR,padding: 30.w, onPressed: (){
            context.read<AllAppointmentsCubit>().cancelAppointment(appointment.bookingId, context);
              },style: Styles.mediumText(color: Colors.white),)],
      ),
    );
  }
}
