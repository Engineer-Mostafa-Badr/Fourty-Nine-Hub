import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/launch_url.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateful/dynamic/collabsable_info_widget.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../common/widgets/stateless/dynamic/rating_stars.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/styles.dart';
import '../../../../health_care/data/models/working_day_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../common/widgets/stateless/dynamic/review_card.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../ride/RideRequest/domain/entity/driver_review_entity.dart';
import 'all_reviews.dart';

class DoctorDetails extends StatelessWidget {
  final int id;
  const DoctorDetails({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorDetailsCubit, DoctorDetailsState>(
        listener: (context, state) {},
        builder: (context, state) {
          final doctor = state.doctor;
          return Scaffold(
            appBar: const BackAppBar(),
            body: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: [
                        if (doctor != null)
                          _buildAccountHeader(
                              context: context, doctor: state.doctor!),
                        const Sizer(),
                        _buildFeaturesWidget(
                            languages: doctor?.languages ?? []),
                        _buildInfoItem(
                            icon: Icons.wallet_rounded,
                            label:
                                '${Labels.startPrice}: ${doctor?.startPrice ?? 0} ${Labels.currency}'),
                        _buildInfoItem(
                            icon: Icons.access_time,
                            label:
                                '${Labels.waitingTime}: ${doctor?.waitingTime} ${Labels.minutes}'),
                        InkWell(
                          onTap: () => LaunchURLHelper().openLocation(
                              lat: doctor?.address.coordinates[0] ?? 0,
                              lng: doctor?.address.coordinates[1] ?? 0),
                          child: _buildInfoItem(
                              icon: Icons.location_on_outlined,
                              label: doctor?.address.address ?? ''),
                        ),
                        if (doctor != null)
                          _buildChooseDateWidget(
                              context: context, doctor: doctor),
                        if (doctor != null) _buildImagesWidget(doctor: doctor),
                        if (doctor != null)
                          _buildDoctorInfoWidget(doctor: doctor),
                        if (doctor != null)
                          _buildReviewsWidget(
                              context: context, reviews: doctor.reviews ?? []),
                      ],
                    ),
                  ),
          );
        });
  }

  Widget _buildAccountHeader(
      {required BuildContext context, required DoctorEntity doctor}) {
    return Row(
      children: [
        SquareImage(
          source: NetworkImage(
            doctor.image,
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
                text: doctor.name,
                style: Styles.mediumText(fontWeight: FontWeight.w500)),
            RatingStars(
              rating: doctor.rate,
              color: AppColors.ACCENT_COLOR,
              iconSize: 18,
            ),
            TextAppButton(
                label: ' ${doctor.numberOfReviews}',
                style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
                onPressed: () {
                  bottomSheet(
                      context: context,
                      isScrollControlled: true,
                      widget: AllReviews(
                        reviews: doctor.reviews ?? [],
                      ));
                }),
            Label(text: doctor.bio, maxLines: 1, style: Styles.mediumText()),
          ],
        ))
      ],
    );
  }

  Widget _buildFeaturesWidget({required List<String> languages}) {
    return RichText(
        text: TextSpan(
            children: languages.map((e) {
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
    return Row(
      children: [
        Icon(
          icon,
          color: color ?? AppColors.PRIMARY_COLOR,
          size: 24,
        ),
        const Sizer(),
        Expanded(child: Label(text: label, style: Styles.mediumText())),
      ],
    );
  }

  Widget _buildChooseDateWidget(
      {required BuildContext context, required DoctorEntity doctor}) {
    return Column(
      children: [
        Label(text: Labels.chooseBookingTime, style: Styles.mediumText()),
        const Sizer(),
        SizedBox(
            height: kToolbarHeight * 2.5,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: doctor.appointments?.length ?? 0,
              itemBuilder: (context, index) {
                return _buildDayScheduleWidget(
                    context: context, item: doctor.appointments![index]);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Sizer(),
            )),
      ],
    );
  }

  Widget _buildDayScheduleWidget(
      {required AppointmentEntity item, required BuildContext context}) {
    return Container(
      width: kToolbarHeight * 1.5,
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
                text: item.date,
                textAlign: TextAlign.center,
                style: Styles.mediumText(color: Colors.white)),
          ),
          Expanded(
              child: Center(
            child: item.available
                ? Label(
                    text: 'From ${item.fromTime}\nTo ${item.toTime}',
                    textAlign: TextAlign.center,
                  )
                : Label(
                    textAlign: TextAlign.center,
                    text: Labels.noAvailableTimes,
                    style: Styles.mediumText()),
          )),
          AppButton(
              label: Labels.book,
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
    );
  }

  Widget _buildImagesWidget({required DoctorEntity doctor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(text: Labels.clinic, style: Styles.headerText()),
        const Sizer(
          height: 3,
        ),
        Container(
          height: kToolbarHeight * 1.5,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (cotnext, index) => SquareImage(
                    source: NetworkImage(doctor.clinicImages[index]),
                    radius: 10,
                  ),
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: doctor.clinicImages.length),
        ),
      ],
    );
  }

  Widget _buildDoctorInfoWidget({required DoctorEntity doctor}) {
    return ListView.builder(
        itemCount: doctor.details?.length ?? 0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final detail = doctor.details![index];
          return CollabsableInfoWidget(
              details: detail.details, label: detail.label);
        });
  }

  Widget _buildReviewsWidget(
      {required BuildContext context, required List<ReviewEntity> reviews}) {
    return Column(
      children: [
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => ReviewCard(
                  review: reviews[index],
                ),
            separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                ),
            itemCount: reviews.length),
        const Sizer(),
        AppButton(
            label: 'Show More',
            onPressed: () {
              bottomSheet(
                  context: context,
                  isScrollControlled: true,
                  widget: AllReviews(
                    reviews: reviews,
                  ));
            })
      ],
    );
  }
}
