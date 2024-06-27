import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/doctor_booking_card.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/utils/date_helper.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/doctor_dashboard_cubit.dart';

class DoctorDashboardView extends StatelessWidget {
  const DoctorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DoctorDashboardCubit>();
    return BlocConsumer<DoctorDashboardCubit, DoctorDashboardState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SharedScaffold(
            mainCategoryId: 1,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: kToolbarHeight * .8,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final date =
                              DateTime.now().add(Duration(days: index));
                          return InkWell(
                            onTap: () => controller.changeDate(v: date),
                            child: Container(
                              width: kToolbarHeight * 1.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey),
                                  color: DateHelper().isSameDate(
                                          date, state.date ?? DateTime.now())
                                      ? AppColors.PRIMARY_COLOR
                                      : Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Label(
                                      text: DateHelper().getDate(date: date),
                                      style: Styles.smallText(
                                        color: DateHelper().isSameDate(date,
                                                state.date ?? DateTime.now())
                                            ? Colors.white
                                            : AppColors.PRIMARY_COLOR,
                                      )),
                                  Label(
                                      text: DateHelper().getDayName(date: date),
                                      style: Styles.smallText(
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
                  Expanded(
                    child: ListView.builder(
                        itemCount: state.bookings?.length ?? 0,
                        itemBuilder: (context, index) {
                          return DoctorBookingCard(
                            appointment: state.bookings![index],
                            onAccept: (int v) =>
                                controller.approveRequest(id: v),
                            onCancel: (int v) =>
                                controller.cancelBooking(id: v),
                          );
                        }),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
