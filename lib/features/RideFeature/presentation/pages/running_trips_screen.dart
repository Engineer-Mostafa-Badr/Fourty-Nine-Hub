import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/car_circle_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/info_column_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/person_trip_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/rate_car_widget.dart';
import 'package:intl/intl.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class RunningTripParams {
  final RideCubit rideCubit;
  RunningTripParams({required this.rideCubit});
}

class RunningTripScreen extends StatefulWidget {
  final RunningTripParams params;
  const RunningTripScreen({super.key, required this.params});

  @override
  _RunningTripScreenState createState() => _RunningTripScreenState();
}

class _RunningTripScreenState extends State<RunningTripScreen> {
  late ScrollController _scrollController;
  int page = 1;
  final int limit = 10;
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.params.rideCubit.fetchAllRunningTrips(limit: limit, page: page);
    });
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 100 && !isFetching) {
      _fetchMoreTrips();
    }
  }

  void _fetchMoreTrips() {
    if (isFetching) return;
    setState(() => isFetching = true);

    widget.params.rideCubit.fetchAllRunningTrips(limit: limit, page: ++page).then((_) {
      if (mounted) setState(() => isFetching = false);
    }).catchError((_) {
      if (mounted) setState(() => isFetching = false);
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.params.rideCubit,
      child: Builder(
        builder: (context) {
          return CustomScaffold(
            appBar: AppBar(
              titleSpacing: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: false,
              title: Transform(
                transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                child: Text(
                  LocaleKeys.runningTrips.localize,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                ),
              ),
            ),
            body: BlocBuilder<RideCubit, RideState>(
              builder: (context, state) {
                if (state.status == RideStates.loading && page == 1) {
                  return const Center(child: CustomCircularProgressIndicator());
                } else if (state.status == RideStates.error) {
                  return const SizedBox();
                } else if (state.status == RideStates.success) {
                  if(state.runningTrips?.isEmpty??true) {
                    return Center(child: Text(context.isArabic ? "لا يوجد رحلات حالية" : "No running trips"));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: (state.runningTrips?.length ?? 0) + (isFetching ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.runningTrips?.length) {
                        return const Center(child: CustomCircularProgressIndicator());
                      }
                      final trip = state.runningTrips?[index];
                      if (trip == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CarContainer(title: context.isArabic ? trip.categoryNameAr : trip.categoryNameEn, image: trip.categoryPicture),
                            const SizedBox(width: 16),
                            PriceColumn(
                              title: trip.address,
                              date: DateFormat('hh:mm a', context.isArabic ? 'ar' : 'en').format(trip.createdAt),
                              price: '${NumberFormat('#,##0', context.isArabic ? 'ar' : 'en').format(trip.price)} ${context.isArabic ? trip.currencyAr : trip.currencyEn}',
                            ),

                            const Spacer(),
                            PersonTripWidget(image: trip.clientGender.toLowerCase() == 'male' ? Assets.maleImagePlaceholder : Assets.femaleImagePlacehlder, name: trip.clientFirstName.split(' ').first, rate: trip.rating,),
                          ],
                        ),
                      );
                    },
                  );
                }
                return Center(child: context.isArabic ? const Text("لا يوجد رحلات مشغلة حاليا") : const Text("No running trips available"));
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
