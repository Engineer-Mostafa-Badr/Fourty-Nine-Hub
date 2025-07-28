import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../domain/entities/client/driver_all_rating_entity.dart';
import '../../controllers/client_trips_cubit/client_trips_cubit.dart';

class AllDriverRatingScreen extends StatelessWidget {
  const AllDriverRatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: SafeArea(
        child: BlocBuilder<ClientTripsCubit, ClientTripsState>(
          builder: (context, state) {
            // ✅ First check if loading
            if (state.status == ClientTripsStates.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            // ✅ Then check for errors
            if (state.status == ClientTripsStates.error) {
              return Center(child: Text(LocaleKeys.errorHappen.localize));
            }

            // ✅ Then check for null data
            final entity = state.driverAllRating;
            if (entity == null) {
              return const Center(child: Text("No data available."));
            }

            final ratings = entity.ratings ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: entity.pictureUrl != null
                        ? NetworkImage(entity.pictureUrl!)
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: entity.pictureUrl == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  InfoTile(label: LocaleKeys.name.localize, value: entity.firstName ?? 'N/A'),
                  InfoTile(label: LocaleKeys.gender.localize, value: entity.gender ?? 'N/A'),
                  InfoTile(label: LocaleKeys.averageRate.localize, value: entity.rating?.toStringAsFixed(1) ?? '0'),
                  InfoTile(label: LocaleKeys.ratingsCount.localize, value: entity.totalRatings?.toString() ?? '0'),
                  const SizedBox(height: 10),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: AppButton(
                  //     backColor: context.isDarkMode ? AppColors.PRIMARY_COLOR_DARK : AppColors.PRIMARY_COLOR,
                  //     onPressed: () {},
                  //     label:LocaleKeys.trip.localize,
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                   Align(
                    alignment: context.isArabic ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(
                      LocaleKeys.commentsRates.localize,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...ratings.map((review) => ReviewCard(review: review)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }


}


class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const InfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text('$label : $value'),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final DriverRating review;

  const ReviewCard({super.key, required this.review});

  String getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return LocaleKeys.poor2.localize;
      case 2:
        return LocaleKeys.bad.localize;
      case 3:
        return LocaleKeys.good.localize;
      case 4:
        return LocaleKeys.veryGood.localize;
      case 5:
        return LocaleKeys.excellent.localize;
      default:
        return 'No Rating';
    }
  }

  @override
  Widget build(BuildContext context) {
    final int ratingValue = review.rating ?? 0;

    return Card(
      color: context.isDarkMode ? AppColors.whiteColor : AppColors.grey.shade200,
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.comment?.isNotEmpty == true ? 'Comment' :   LocaleKeys.noComments.localize,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  review.createdAt != null
                      ? "${review.createdAt!.day}/${review.createdAt!.month}/${review.createdAt!.year}"
                      : '',
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  getRatingLabel(ratingValue),
                  style:Styles.mediumText(
                      fontWeight: FontWeight.w600
                  ),
                ),
                RatingBar(
                  initialRating: ratingValue.toDouble(),
                  ignoreGestures: true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                  ratingWidget: RatingWidget(
                    full: SvgPicture.asset(Assets.star1),
                    half: SvgPicture.asset(Assets.halfStar),
                    empty: SvgPicture.asset(Assets.starEmpty),
                  ),
                  itemSize: 14,
                  onRatingUpdate: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 4),

            const SizedBox(height: 8),
            Text(
              review.comment?.isNotEmpty == true ? review.comment! :   LocaleKeys.noCommentsYet.localize,
              style:Styles.mediumText(
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ),
    );
  }
}

