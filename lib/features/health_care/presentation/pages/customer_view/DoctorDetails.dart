import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateful/dynamic/collabsable_info_widget.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../common/widgets/stateless/dynamic/rating_stars.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../data/models/working_day_model.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/dynamic/review_card.dart';
import '../../../../../res/style/app_colors.dart';
import 'doctor_reviews.dart';

class DoctorDetails extends StatelessWidget {
  const DoctorDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            _buildAccountHeader(context: context),
            const Sizer(),
            _buildFeaturesWidget(),
            const Divider(
              height: 10,
              color: Colors.grey,
            ),
            _buildInfoItem(
                icon: Icons.wallet_rounded,
                label: 'Price starts from: 550 L.E'),
            _buildInfoItem(
                icon: Icons.access_time, label: 'Waiting Time: 23 Minutes'),
            _buildInfoItem(
                icon: Icons.location_on_outlined,
                label: 'New Giza: Al Khalifa Al Maamoun St.'),
            _buildChooseDateWidget(context: context),
            const Divider(),
            _buildInfoItem(
                icon: Icons.monetization_on,
                color: AppColors.YELLOW_COLOR,
                label: 'You will get ## L.E in your wallet after booking'),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                      color: AppColors.ACCENT_COLOR,
                      icon: Icons.star,
                      label: 'Clinic 4/5 Stars'),
                ),
                const Sizer(),
                Expanded(
                  child: _buildInfoItem(
                      color: AppColors.ACCENT_COLOR,
                      icon: Icons.star,
                      label: 'Assistant 4/5 Stars '),
                ),
              ],
            ),
            _buildImagesWidget(),
            _buildDoctorInfoWidget(),
            _buildReviewsWidget(context: context),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountHeader({required BuildContext context}) {
    return Row(
      children: [
        const SquareImage(
          source: NetworkImage(
            UIConst.profilePlaceHolder,
          ),
          radius: 10,
          height: kToolbarHeight * 1.5,
          width: kToolbarHeight * 1.5,
        ),
        const Sizer(),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
                text: 'Dr Mohamed El Samalawy',
                style: Styles.mediumText(fontWeight: FontWeight.w500)),
            const RatingStars(
              rating: 4,
              color: AppColors.ACCENT_COLOR,
              iconSize: 18,
            ),
            TextAppButton(
                label: 'General Reviews 977 visitors',
                style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
                onPressed: () {
                  bottomSheet(
                      context: context,
                      isScrollControlled: true,
                      widget: const DoctorReviews());
                }),
            Label(
                text: UIConst.placeholderText,
                maxLines: 1,
                style: Styles.mediumText()),
          ],
        ))
      ],
    );
  }

  Widget _buildFeaturesWidget() {
    final features = [
      'Clean',
      'Professional',
    ];
    return RichText(
        text: TextSpan(
            children: features.map((e) {
      return WidgetSpan(
          child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Label(text: e, style: Styles.mediumText()),
      ));
    }).toList()));
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color ?? AppColors.PRIMARY_COLOR,
              size: 24,
            ),
            const Sizer(),
            Expanded(child: Label(text: label, style: Styles.mediumText())),
          ],
        ),
        const Divider(
          color: Colors.grey,
        )
      ],
    );
  }

  Widget _buildChooseDateWidget({required BuildContext context}) {
    return Column(
      children: [
        Label(text: 'Choose Booking Time', style: Styles.mediumText()),
        const Sizer(),
        SizedBox(
          height: kToolbarHeight * 2.5,
          child: Row(
            children: [
              IconAppButton(
                icon: Icons.arrow_back,
                onPressed: () {},
                isCircle: true,
              ),
              ...[0, 1, 2].map((index) {
                return _buildDayScheduleWidget(
                    context: context,
                    item: WorkingDayModel(
                        label: 'Available',
                        date: DateTime.now().add(Duration(days: index)),
                        available: index.isEven,
                        startHour: 6,
                        endHour: 10));
              }),
              IconAppButton(
                icon: Icons.arrow_forward,
                onPressed: () {},
                isCircle: true,
              ),
            ],
          ),
        ),
        const Sizer(),
        Label(
            text: 'Entry is by earlier reservation',
            style: Styles.mediumText()),
      ],
    );
  }

  Widget _buildDayScheduleWidget(
      {required WorkingDayModel item, required BuildContext context}) {
    return Expanded(
      child: Container(
        // width: kToolbarHeight * 1.8,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: AppColors.PRIMARY_COLOR,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Label(
                  text: item.formattedDate,
                  textAlign: TextAlign.center,
                  style: Styles.mediumText(color: Colors.white)),
            ),
            Expanded(
                child: Center(
              child: Label(
                  textAlign: TextAlign.center,
                  text: 'There is no available times',
                  style: Styles.mediumText()),
            )),
            AppButton(
                label: 'Book',
                backColor: item.available
                    ? AppColors.SECONDARY_COLOR
                    : AppColors.LIGHT_GRAY_COLOR,
                onPressed: () {
                  if (item.available) {
                    context.push(Routes.VISITABOOKING);
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget _buildImagesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(text: 'Clinic', style: Styles.headerText()),
        const Sizer(
          height: 3,
        ),
        Container(
          height: kToolbarHeight * 1.5,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (cotnext, index) => const SquareImage(
                    source: NetworkImage(UIConst.socialImagePlaceHolder),
                    radius: 10,
                  ),
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: 10),
        ),
      ],
    );
  }

  Widget _buildDoctorInfoWidget() {
    return const Column(
      children: [
        CollabsableInfoWidget(
            details: UIConst.placeholderText,
            label: 'Informations about doctor'),
        Divider(),
        CollabsableInfoWidget(
            details: UIConst.placeholderText,
            label: 'Informations about doctor'),
        Divider(),
        CollabsableInfoWidget(
            details: UIConst.placeholderText,
            label: 'Informations about doctor'),
        Divider(),
        CollabsableInfoWidget(
            details: UIConst.placeholderText,
            label: 'Informations about doctor'),
        Divider(),
        CollabsableInfoWidget(
            details: UIConst.placeholderText,
            label: 'Informations about doctor'),
        Divider(),
      ],
    );
  }

  Widget _buildReviewsWidget({required BuildContext context}) {
    return Column(
      children: [
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => const ReviewCard(),
            separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                ),
            itemCount: 3),
        const Sizer(),
        AppButton(
            label: 'Show More',
            onPressed: () {
              bottomSheet(
                  context: context,
                  isScrollControlled: true,
                  widget: const DoctorReviews());
            })
      ],
    );
  }
}
