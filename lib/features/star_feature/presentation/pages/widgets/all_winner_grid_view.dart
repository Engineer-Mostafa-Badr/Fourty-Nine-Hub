import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/functions/helper/numbers_helper.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/utils/duration_helper.dart';
import '../../../../../res/assets/assets.dart';
import '../../../domain/entity/star_winner_entity.dart';
import '../../controller/cubit/star_cubit.dart';

class AllWinnerGridView extends StatelessWidget {
  final List<StarWinnerEntity>? winner;
  final StarCubit starCubit;
  const AllWinnerGridView({super.key, this.winner, required this.starCubit});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // padding: EdgeInsets.all(16.w),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        if (index == starCubit.winner.length) {
          return const Center(child: CustomCircularProgressIndicator());
        }
        return _buildWinnerCard(winner![index]);
      },
      itemCount: winner?.length ?? 0,
    );
  }

  Widget _buildWinnerCard(StarWinnerEntity star) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: const Color(0xff4d4c4c),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 70.r,
                backgroundImage: Image.network(
                  star.user.image,
                  height: 100.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ).image,
              ),
              Positioned(
                top: -32,
                right: -14,
                child: Image.asset(
                  Assets.crown,
                  height: 100.h,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${star.user.firstName} ${star.user.lastName}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 26.sp,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${star.user.viewNumber.toShortScale} ${LocaleKeys.views.localize} ",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "${LocaleKeys.winner_rating.localize} ${star.user.averageRating.toShortScale} ",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                      ),
                    ),
                    Image.asset(
                      Assets.starGold,
                      height: 20.h,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  DurationHelper()
                      .getTimeDifference(DateTime.parse(star.createdAt!))
                      .localize,
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '1000 ${LocaleKeys.egp.localize}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 26.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
