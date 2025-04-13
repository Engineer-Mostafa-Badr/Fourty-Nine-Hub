import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../cubit/book_doctor_appointment_cubit.dart';
import '../widgets/booking_confirmation/booking_submit_button.dart';
import '../widgets/booking_successed/booking_summary_info.dart';
import '../widgets/booking_successed/thanks_header.dart';

class SuccessfulBookingScreen extends StatelessWidget {
  const SuccessfulBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const HomeAppbar(),
      body: BlocBuilder<BookDoctorAppointmentCubit, BookDoctorAppointmentState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// make size
                const Sizer(height: 40),

                /// Header
                const ThanksHeader(),

                /// make size
                const Sizer(height: 30),

                /// Booking summary info
                const BookingSummaryInfo(),

                /// make size
                const Sizer(height: 194),
                // Submit Button
                BookingButton(
                  onTap: () {},
                  title: 'Done',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
