import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/view_all_trip_join_builder.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                'Users own cars/share the trip with them! ',
                style: Styles.headerText(
                    color: AppColors.SECONDARY_COLOR, fontSize: 35.sp),
                textAlign: TextAlign.start,
              ),
            ),
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
