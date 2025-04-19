import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../doctor_details/presentation/cubit/doctor_details_cubit.dart';
import '../cubit/book_doctor_appointment_cubit.dart';
import '../widgets/booking_confirmation/booking_check_box_widget.dart';
import '../widgets/booking_confirmation/booking_submit_button.dart';
import '../widgets/booking_confirmation/confirm_header.dart';
import '../widgets/booking_confirmation/custom_user_info_section.dart';
import '../widgets/booking_confirmation/doctor_information.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final dynamic doctorDetailsCubit;

  const BookingConfirmationScreen({super.key, this.doctorDetailsCubit});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isBookingForSomeoneElse = false;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    context.read<BookDoctorAppointmentCubit>().init(widget.doctorDetailsCubit);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctor = context.read<BookDoctorAppointmentCubit>().doctor;
    final bookingController = context.read<BookDoctorAppointmentCubit>();

    final user=context.read<UserCubit>().state.data;
    return CustomScaffold(
      appBar: const HomeAppbar(
        isWithBackArrow: true,
      ),
      body: BlocBuilder<BookDoctorAppointmentCubit, BookDoctorAppointmentState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Sizer(height: 40),

                  /// Header
                  const ConfirmHeader(),
                  const Sizer(height: 30),

                  /// Doctor Information
                  DoctorInfo(
                    doctor: doctor,
                  ),

                  /// Booking on behalf checkbox
                  BookingCheckBoxWidget(
                    value: _isBookingForSomeoneElse,
                    onChanged: (newValue) {
                      setState(() {
                        _isBookingForSomeoneElse = newValue ?? false;
                      });
                    },
                    activeColor: AppColors.PRIMARY_COLOR,
                    // checkbox fill color when checked
                    checkColor: Colors.white,
                    // checkmark color
                    borderColor:
                        Colors.white, // checkbox border when unchecked,
                  ),
                  const Sizer(height: 24),

                  /// User Information
                  CustomUserInfoSection(
                      isBookingForSomeoneElse: _isBookingForSomeoneElse,
                      currentFocusNode: bookingController.phoneFousNode,
                      nextFocusNode: bookingController.phoneFousNode,
                      context: context,
                      phoneController:
                          bookingController.phoneNumberTextController,
                      nameController: bookingController.nameTextController,
                      Time:  "${widget.doctorDetailsCubit.selectedAppointment.startTime } : ${widget.doctorDetailsCubit.selectedAppointment.endTime }  ",
                      location: "${ user?.city}"??" ",
                      fees: "${doctor?.clinicPrice} ${LocaleKeys.egp.localize} "??" ",
                      patientName: user?.fullName??" " ,
                      patientPhone: user?.phone??""),

                  const Sizer(height: 170),
                  // Submit Button
                  BookingButton(
                    onTap: () {
                      context.pushNamed(Routes.SUCCESSFULLBOOKING
                      ,extra: widget.doctorDetailsCubit

                      );
                    },
                    title: LocaleKeys.submit.localize,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );


  }
}
