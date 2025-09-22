import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class AvailablePickMeCard extends StatefulWidget {
  const AvailablePickMeCard({
    super.key,


  });

  @override
  State<AvailablePickMeCard> createState() => _AvailablePickMeCardState();
}

class _AvailablePickMeCardState extends State<AvailablePickMeCard> {

  late ScrollController _scrollController;

  @override
  void initState() {
    context.read<ViewAllTripJoinCubit>().getTripJoin();
    _scrollController = ScrollController()..addListener(_onScroll);
    super.initState();

  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // context.read<ViewAllTripJoinCubit>().getTripJoin();

    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  final Map<String, DateTime> _lastTapTimes = {};


  @override
  Widget build(BuildContext context) {
    return GlowingOverscrollIndicator(
      color: AppColors.SECONDARY_COLOR,
        axisDirection: AxisDirection.down,
      child: ListView.builder(
          controller: _scrollController,
          itemCount: 20,
          itemBuilder: (context,index){
            return  Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
              ),
              child:SizedBox(),
            );
          }),
    );
  }


}



