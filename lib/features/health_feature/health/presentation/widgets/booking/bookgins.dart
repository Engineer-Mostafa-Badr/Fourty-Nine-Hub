import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking/booking_card.dart';

class HealthBookings extends StatelessWidget {
  const HealthBookings({super.key, this.onClose});
  final VoidCallback? onClose;


  @override
  Widget build(BuildContext context) {
    var booking=BookedAppointmentEntity(
      id:'3124',
      bookedPremium:true,
      doctor:null,
      userId:'12321',
      bookingType:BookingTypes.call,
      day:'Sunday',
      startTime:'8:00',
      endTime:'9:00',
      bookingId:'234234',
      expired:true);
    return BlocBuilder<HealthCubit, HealthState>(
      builder: (context, state) {
       // if (state.myBookings != null && state.myBookings!.isNotEmpty) {
          return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => HealthBookingCard(
                    appointment: booking,
                    //state.myBookings![index],
                  ),
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: state.myBookings?.length ?? 2);
        // } else {
        //   return const SizedBox.shrink();
        // }
      },
    );
  }
}
