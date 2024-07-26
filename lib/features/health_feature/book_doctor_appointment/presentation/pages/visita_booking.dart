import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/dynamic/rating_stars.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/utils/date_helper.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../health/domain/entities/appointment_booking_entity.dart';
import '../cubit/book_doctor_appointment_cubit.dart';

class VisitaBooking extends StatelessWidget {
  const VisitaBooking({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<BookDoctorAppointmentCubit>();

    return Scaffold(
        backgroundColor: AppColors.BACKGROUND_COLOR,
        appBar: const BackAppBar(
          label: 'Confirm Booking',
        ),
        body: BlocConsumer<BookDoctorAppointmentCubit,
            BookDoctorAppointmentState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  // _buildHeaderWidget(),
                  _buildBookingTime(context: context),
                  _buildInfoWidget(
                      widget: Column(
                        children: [
                          FormTextField(
                            label: 'Full Name',
                            controller: controller.fullNameTextController,
                          ),
                          const Sizer(),
                          FormTextField(
                            label: 'Phone Number',
                            controller: controller.phoneNumberTextController,
                          ),
                        ],
                      ),
                      icon: Icons.person,
                      height: kToolbarHeight * 2),
                  _buildInfoWidget(
                      widget: Label(
                          text: state.doctor?.address.address ?? '',
                          style: Styles.mediumText()),
                      icon: Icons.location_on,
                      height: kToolbarHeight),
                  _buildInfoWidget(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(text: Labels.price, style: Styles.mediumText()),
                          Label(
                              text:
                                  '${state.doctor?.startPrice ?? 0} ${Labels.currency}',
                              style: Styles.mediumText()),
                        ],
                      ),
                      icon: Icons.attach_money,
                      height: kToolbarHeight),
                  const Sizer(),
                  AppButton(
                      label: Labels.book,
                      onPressed: () =>
                          controller.confirmBooking(context: context)),
                  const Sizer(),
                ],
              ),
            );
          },
        ));
  }

  Widget _buildHeaderWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const ProfileImage(
            accountId: 0,
            size: 25,
          ),
          const Sizer(),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                  text: 'Dr. Karim Khalil',
                  style: Styles.mediumText(fontWeight: FontWeight.bold)),
              const RatingStars(
                rating: 4,
                color: AppColors.ACCENT_COLOR,
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget _buildInfoWidget({
    required Widget widget,
    required IconData icon,
    required double height,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppColors.PRIMARY_COLOR,
              ),
              Container(
                height: 2,
                width: kToolbarHeight * .5,
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: AppColors.SECONDARY_COLOR,
              )
            ],
          ),
          Container(
            height: height,
            width: .5,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: AppColors.GREY_DARK_COLOR,
          ),
          Expanded(child: widget),
        ],
      ),
    );
  }

  Widget _buildBookingTime({required BuildContext context}) {
    final controller = context.read<BookDoctorAppointmentCubit>();
    return BlocBuilder<BookDoctorAppointmentCubit, BookDoctorAppointmentState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                  text:
                      DateHelper().getDate(date: state.date ?? DateTime.now()),
                  style: Styles.mediumText()),
              const Sizer(),
              SizedBox(
                height: kToolbarHeight * 1.5,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final date = DateTime.now().add(Duration(days: index));
                      return InkWell(
                        onTap: () => controller.changeDate(v: date),
                        child: Container(
                          width: kToolbarHeight * 1.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                              color: DateHelper().isSameDate(
                                      date, state.date ?? DateTime.now())
                                  ? AppColors.PRIMARY_COLOR
                                  : Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Label(
                                  text: date.day.toString(),
                                  style: Styles.mediumText(
                                      color: DateHelper().isSameDate(date,
                                              state.date ?? DateTime.now())
                                          ? Colors.white
                                          : AppColors.PRIMARY_COLOR,
                                      fontSize: 16)),
                              Label(
                                  text: DateHelper().getDayName(date: date),
                                  style: Styles.mediumText(
                                      color: DateHelper().isSameDate(date,
                                              state.date ?? DateTime.now())
                                          ? Colors.white
                                          : AppColors.PRIMARY_COLOR))
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Sizer(),
                    itemCount: 14),
              ),
              const Sizer(),
              Row(
                children: [
                  BadgedLabel(
                      onTap: () =>
                          controller.changeBookingType(v: BookingTypes.clinic),
                      color: state.bookingType == BookingTypes.clinic
                          ? AppColors.PRIMARY_COLOR
                          : AppColors.LIGHT_GRAY_COLOR,
                      label: 'Clinic'),
                  const Sizer(),
                  BadgedLabel(
                      onTap: () =>
                          controller.changeBookingType(v: BookingTypes.call),
                      color: state.bookingType == BookingTypes.call
                          ? AppColors.PRIMARY_COLOR
                          : AppColors.LIGHT_GRAY_COLOR,
                      label: 'Online'),
                ],
              ),
              const Sizer(),
              Label(
                  text:
                      '${state.appointments?.length ?? 0} ${Labels.availableTimes}',
                  style: Styles.mediumText()),
              RichText(
                  text: TextSpan(
                      children: state.appointments?.map((e) {
                            return WidgetSpan(
                                child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.LIGHT_GRAY_COLOR),
                              child: Label(
                                  text: e.fromTime,
                                  style: Styles.mediumText(
                                      fontWeight: FontWeight.w300,
                                      decoration: !e.available
                                          ? TextDecoration.lineThrough
                                          : null)),
                            ));
                          }).toList() ??
                          [])),
            ],
          ),
        );
      },
    );
  }
}
