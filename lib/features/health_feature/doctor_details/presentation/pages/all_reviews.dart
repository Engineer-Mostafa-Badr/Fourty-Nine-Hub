import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/doctor_review_card.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/stateless/dynamic/rating_stars.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/styles.dart';

import '../../../../../res/style/app_colors.dart';

class AllReviews extends StatefulWidget {
  const AllReviews({
    super.key,
    this.doctorId = '',
  });
  final String? doctorId;
  @override
  State<AllReviews> createState() => _AllReviewsState();
}

class _AllReviewsState extends State<AllReviews> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScroll);
    widget.doctorId == ''
        ? context.read<DoctorDetailsCubit>().loadInitialData()
        : context
            .read<DoctorDetailsCubit>()
            .loadReviewsData(widget.doctorId ?? '');
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 800) {
      widget.doctorId == ''
          ? context.read<DoctorDetailsCubit>().fetchDoctorReviews()
          : context
              .read<DoctorDetailsCubit>()
              .fetchDoctorSubReviews(doctorId: widget.doctorId ?? '');
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
    return Scaffold(
      appBar: BackAppBar(
        label: Labels.reviews,
        backColor: cardDarkColor(context),
      ),
      body: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
          builder: (context, state) {
        var cubit = context.read<DoctorDetailsCubit>();

        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (cubit.rates.isEmpty) {
            return const Center(child: Text('No reviews yet'));
          } else {
            print(cubit.rates);
            return ListView.separated(
                controller: _scrollController,
                itemBuilder: (context, index) => DoctorReviewCard(
                      review: cubit.rates[index],
                      fromDashboard: widget.doctorId == '',
                    ),
                separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,
                    ),
                itemCount: cubit.rates.length);
          }
        }
      }),
    );
  }

  Widget _buildOverReviewsWidget({
    required int rate,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          RatingStars(
            rating: rate,
            iconSize: 20,
            color: AppColors.ACCENT_COLOR,
          ),
          const Sizer(),
          Label(
              text: label,
              style: Styles.mediumText(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
