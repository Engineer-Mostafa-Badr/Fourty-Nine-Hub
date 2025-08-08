import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import 'view_all_trip_join_builder.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class AvailableTripsBody extends StatefulWidget {
  const AvailableTripsBody({super.key});

  @override
  State<AvailableTripsBody> createState() => _AvailableTripsBodyState();
}

class _AvailableTripsBodyState extends State<AvailableTripsBody> {
  late final ViewAllTripJoinCubit viewAllTripJoinCubit;
  late final ScrollController scrollController;
  late double scrollPosition;
  late double scrollMaxExtent;
  int nextPage = 1;
  bool isLoading = false;
  @override
  void initState() {
    viewAllTripJoinCubit = context.read<ViewAllTripJoinCubit>()
      ..viewAllTripJoin();
    scrollController = ScrollController();
    _scrollControllerListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5.h),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.isArabic
                    ? "أنشئ إعلانًا لرحلاتك اليومية وشارك تكاليف النقل مع ركاب آخرين."
                    : "Advertise your recurring trips and connect with passengers daily.",
                style: Styles.mediumText(
                  color: AppColors.PRIMARY_COLOR_DARK,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const ViewAllTripJoinCardBuilder(),
          ],
        ),
      ),
    );
  }

  _scrollControllerListener() {
    scrollController.addListener(() async {
      scrollPosition = scrollController.position.pixels;
      scrollMaxExtent = scrollController.position.maxScrollExtent;
      if (scrollPosition >= 0.7 * scrollMaxExtent &&
          scrollPosition <= 0.72 * scrollMaxExtent) {
        if (!isLoading) {
          isLoading = true;
          if (!viewAllTripJoinCubit.noMoreDataInDatabase) {
            viewAllTripJoinCubit.paginationParams.page += 1;
          }
          await viewAllTripJoinCubit.viewAllTripJoin();
          nextPage++;
          isLoading = false;
        }
      }
    });
  }
}
