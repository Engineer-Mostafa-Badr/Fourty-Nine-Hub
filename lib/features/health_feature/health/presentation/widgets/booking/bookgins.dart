import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking/booking_card.dart';

class HealthBookings extends StatelessWidget {
  const HealthBookings({super.key, this.onClose});
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthCubit, HealthState>(
      builder: (context, state) {
        final cubit = context.read<HealthCubit>();

        // Show loading state
        if (state.status == HealthStates.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show empty state if no bookings
        if (cubit.myBooking.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  context.isArabic ? 'لا توجد حجوزات' : 'No bookings found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        // Show user's bookings
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final booking = cubit.myBooking[index];
            return HealthBookingCard(
              appointment: booking,
            );
          },
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: cubit.myBooking.length,
        );
      },
    );
  }
}
