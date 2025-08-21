import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/date_time.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../domain/entity/star_winner_entity.dart';
import '../controller/cubit/star_cubit.dart';
import '../controller/cubit/star_state.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

import '../../../../core/loading/custom_loading.dart';
import '../../../../res/assets/assets.dart';
import '../widgets/all_winner_grid_view.dart';
import '../../../../helpers/manage_vibration.dart';
// import '../../../../../core/widget/custom_scaffold.dart';

class AllWinnerView extends StatefulWidget {
  const AllWinnerView({super.key});

  @override
  State<AllWinnerView> createState() => _AllWinnerViewState();
}

class _AllWinnerViewState extends State<AllWinnerView> {
  late ScrollController _scrollController;
  late StarCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<StarCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
    _cubit.loadInitialDataWinner();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.fetchWinnerStar();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.winners.localize,
          actions: [
            SvgPicture.asset(Assets.cupIcon),
          ],
        ),
      ),
      body: BlocBuilder<StarCubit, StarState>(
        builder: (BuildContext context, state) {
          if (state.status == StarStates.loading) {
            return const CustomLoading();
          }

          return Padding(
            padding: EdgeInsets.all(6.w),
            child: AllWinnerGridView(
              winner: state.winner,
              starCubit: _cubit,
            ),

            //  ListView.separated(
            //   controller: _scrollController,
            //   physics: const AlwaysScrollableScrollPhysics(),
            //   itemBuilder: (context, index) {
            //     if (index == _cubit.winner.length) {
            //       return const Center(child: CustomCircularProgressIndicator());
            //     }
            //     return buildItem(context, state.winner![index]);
            //   },
            //   separatorBuilder: (context, index) => SizedBox(
            //     height: 40.h,
            //     // color: AppColors.GREY_NORMAL_COLOR,
            //   ),
            //   itemCount: state.winner?.length ?? 0,
            // ),
          );
        },
      ),
    );
  }

  Widget buildItem(context, StarWinnerEntity star) {
    DateTime dateTime = DateTime.parse(star.createdAt!);

    // Get the month
    int month = dateTime.month;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              ManageVibration.vibrate();
              // context.push(Routes.OTHERSACCOUNT, extra: star.user.id);
            },
            child: ImageFromInternet(
              image: star.user.image,
              //  isCircle: true,
              defaultLogo: false,
              width: 120.w,
              height: 120.h,
              borderRadius: BorderRadius.circular(10.r),
              fit: BoxFit.fill,
            ),
          ),
          const Sizer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: '${star.user.firstName} ${star.user.lastName}',
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              Label(
                text:
                    '${LocaleKeys.day.localize}: ${formatDateTime(star.createdAt!, context)}',
                style: Styles.smallText(
                  fontSize: 50.sp,
                  color: AppColors.GREY_NORMAL_COLOR,
                ),
              ),
              Label(
                text: '${LocaleKeys.month.localize}: $month',
                style: Styles.smallText(
                  fontSize: 50.sp,
                  color: AppColors.GREY_NORMAL_COLOR,
                ),
              ),
              Label(
                text: '${LocaleKeys.numOfWins.localize}: ${star.numberOfWins}',
                style: Styles.smallText(
                  fontSize: 50.sp,
                  color: AppColors.GREY_NORMAL_COLOR,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '🏆',
            style: Styles.mediumText(
                color: AppColors.SECONDARY_COLOR, fontSize: 150.sp),
          )
        ],
      ),
    );
  }
}
