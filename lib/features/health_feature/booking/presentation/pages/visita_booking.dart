import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/widgets/doctor_profile.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/widgets/location.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/widgets/patient_info.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/widgets/price.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/widgets/time.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../cubit/book_doctor_appointment_cubit.dart';

class VisitaBooking extends StatefulWidget {
  final DoctorDetailsCubit doctorDetailsCubit;
  const VisitaBooking({super.key, required this.doctorDetailsCubit});

  @override
  State<VisitaBooking> createState() => _VisitaBookingState();
}

class _VisitaBookingState extends State<VisitaBooking> {
  @override
  void initState() {
    context.read<BookDoctorAppointmentCubit>().init(widget.doctorDetailsCubit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<BookDoctorAppointmentCubit>();

    return Scaffold(
        appBar: const BackAppBar(
          label: Labels.confirmBooking,
        ),
        body: BlocConsumer<BookDoctorAppointmentCubit,
            BookDoctorAppointmentState>(
          listener: (context, state) {
            switch (state) {
              case BookDoctorAppointmentSuccessState _:
                showSuccessMessage(context, Labels.waitingDoctorAppointment);
                Future.delayed(const Duration(seconds: 1));
                context.pushAndRemoveUntil(Routes.VISITA);
                break;

              case BookDoctorAppointmentStartLoadingState _:
                showLoadingDialog(context);
                break;
              case BookDoctorAppointmentEndLoadingState _:
                context.pop();
                break;

              case BookDoctorAppointmentErrorState _:
                showErrorMessage(context, state.message);
                break;
              default:
                break;
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  const BookingDoctorProfileWidget(),
                  const BookDoctorAppointmentPatientInfoCard(),
                  const BookDoctorAppointmentTimeCard(),
                  const BookDoctorAppointmentLocationInfoCard(),
                  const BookDoctorAppointmentFeesCard(),
                  const Sizer(),
                  AppButton(
                      height: 50,
                      label: Labels.book,
                      backColor: AppColors.PRIMARY_COLOR,
                      onPressed: () => controller.regularBooking()),
                  const Sizer(),
                  AppButton(
                      height: 50,
                      label: "${Labels.premium} ${Labels.book}",
                      onPressed: () {
                        serviceLocator<SubscriptionController>()
                            .checkIfUserSubscribed(
                          onSubscribed: () async {
                            await controller.premiumBook();
                          },
                          subCategoryId: serviceLocator<HealthSharedData>()
                              .doctorSearchParams
                              .subCategory
                              .id,
                        );
                      }),
                  const Sizer(),
                ],
              ),
            );
          },
        ));
  }
}
