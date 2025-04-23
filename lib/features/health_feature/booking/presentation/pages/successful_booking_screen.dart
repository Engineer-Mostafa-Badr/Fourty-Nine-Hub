import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../routes/routes.dart';
import '../cubit/book_doctor_appointment_cubit.dart';
import '../widgets/booking_confirmation/booking_submit_button.dart';
import '../widgets/booking_successed/booking_summary_info.dart';
import '../widgets/booking_successed/thanks_header.dart';

class SuccessfulBookingScreen extends StatelessWidget {
  final dynamic doctorDetailsCubit;

  const SuccessfulBookingScreen({super.key, this.doctorDetailsCubit});

  @override
  Widget build(BuildContext context) {
    context.read<BookDoctorAppointmentCubit>().init(doctorDetailsCubit);
    final bookingController = context.read<BookDoctorAppointmentCubit>();

    return CustomScaffold(
      appBar: const HomeAppbar(
        isWithBackArrow: true,
      ),
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

                 BookingSummaryInfo(
                  doctor:bookingController.doctor
                ),

                /// make size
                const Sizer(height: 194),
                // Submit Button
                BookingButton(
                  onTap: () {
                    context.pushAndRemoveUntil(
                        Routes.SUCCESSFULLBOOKING, (route) => route == Routes.HOME);
                  },
                  title: LocaleKeys.done.localize,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
