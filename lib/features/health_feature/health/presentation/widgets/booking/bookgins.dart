import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking/booking_card.dart';

class HealthBookings extends StatelessWidget {
  const HealthBookings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthCubit, HealthState>(
      builder: (context, state) {
        if (state.myBookings != null && state.myBookings!.isNotEmpty) {
          return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => HealthBookingCard(
                    appointment: state.myBookings![index],
                  ),
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: state.myBookings?.length ?? 0);
        }else{
          return const SizedBox.shrink();
        }
      },
    );
  }
}
