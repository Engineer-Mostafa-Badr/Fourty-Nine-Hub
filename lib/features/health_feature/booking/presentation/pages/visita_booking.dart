import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/widgets/doctor_profile.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/widgets/info.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/widgets/patient_info.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../res/style/app_colors.dart';
import '../cubit/book_doctor_appointment_cubit.dart';

class VisitaBooking extends StatelessWidget {
  final DoctorDetailsCubit doctorDetailsCubit;
  const VisitaBooking({super.key, required this.doctorDetailsCubit});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<BookDoctorAppointmentCubit>();

    return Scaffold(
        backgroundColor: AppColors.BACKGROUND_COLOR,
        appBar: const BackAppBar(
          label: Labels.confirmBooking,
        ),
        body: BlocConsumer<BookDoctorAppointmentCubit,
            BookDoctorAppointmentState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  BookingDoctorProfileWidget(
                    doctor: doctorDetailsCubit.doctor,
                  ),
                  const BookDoctorAppointmentPatientInfoCard(),
                  BookDoctorAppointmentCardInfo(
                      widget: Label(
                          text: doctorDetailsCubit.doctor.address.address,
                          style: Styles.mediumText()),
                      icon: Icons.location_on,
                      height: kToolbarHeight),
                  BookDoctorAppointmentCardInfo(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(text: Labels.price, style: Styles.mediumText()),
                          Label(
                              text:
                                  '${doctorDetailsCubit.doctor.priceToShow} ${Labels.currency}',
                              style: Styles.mediumText()),
                        ],
                      ),
                      icon: Icons.attach_money,
                      height: kToolbarHeight),
                  const Sizer(),
                  AppButton(
                      label: Labels.book,
                      onPressed: () => controller.confirmBooking()),
                  const Sizer(),
                ],
              ),
            );
          },
        ));
  }
}
