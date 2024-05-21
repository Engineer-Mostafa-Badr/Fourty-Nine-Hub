import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/dynamic/rating_stars.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/utils/date_helper.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/app_colors.dart';

class VisitaBooking extends StatelessWidget {
  const VisitaBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: const BackAppBar(
        backColor: AppColors.PRIMARY_COLOR,
        iconColor: Colors.white,
        label: 'Confirm Booking',
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
           
            _buildHeaderWidget(),
            _buildBookingTime(),
            _buildInfoWidget(
                widget: Column(
                  children: [
                    FormTextField(
                        label: 'Full Name',
                        initialValue: 'Farouk Mohamed Shahin',
                        action: (v) {}),
                    const Sizer(),
                    FormTextField(
                        label: 'Phone Number',
                        initialValue: '01148337372',
                        action: (v) {}),
                  ],
                ),
                icon: Icons.person,
                height: kToolbarHeight * 2),
            _buildInfoWidget(
                widget:
                    Label(text: 'Amar Bn Yasser', style: Styles.mediumText()),
                icon: Icons.location_on,
                height: kToolbarHeight),
            _buildInfoWidget(
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Label(text: 'Price', style: Styles.mediumText()),
                    Label(text: '400 L.E', style: Styles.mediumText()),
                  ],
                ),
                icon: Icons.attach_money,
                height: kToolbarHeight),
            const Sizer(),
            AppButton(
                label: 'Confirm Booking',
                onPressed: () => context.push(Routes.VISITA)),
            const Sizer(),
          ],
        ),
      ),
    );
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

  Widget _buildBookingTime() {
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
          Label(text: 'May,2024', style: Styles.mediumText()),
          const Sizer(),
          SizedBox(
            height: kToolbarHeight * 1.5,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: kToolbarHeight * 1.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        color: index == 0
                            ? AppColors.PRIMARY_COLOR
                            : Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Label(
                            text: DateTime.now()
                                .add(Duration(days: index))
                                .day
                                .toString(),
                            style: Styles.mediumText(
                                color: index == 0
                                    ? Colors.white
                                    : AppColors.PRIMARY_COLOR,
                                fontSize: 16)),
                        Label(
                            text: DateHelper().getDayName(
                                date:
                                    DateTime.now().add(Duration(days: index))),
                            style: Styles.mediumText(
                                color: index == 0
                                    ? Colors.white
                                    : AppColors.PRIMARY_COLOR))
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Sizer(),
                itemCount: 14),
          ),
          const Sizer(),
          Label(text: '6 Available Times', style: Styles.mediumText()),
          RichText(
              text: TextSpan(
                  children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((e) {
            return WidgetSpan(
                child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.LIGHT_GRAY_COLOR),
              child: Label(
                  text: DateHelper().getHourFormat(
                      date: DateTime.now().add(Duration(minutes: e * 30))),
                  style: Styles.mediumText(
                      fontWeight: FontWeight.w300,
                      decoration: e.isOdd ? TextDecoration.lineThrough : null)),
            ));
          }).toList())),
        ],
      ),
    );
  }
}
