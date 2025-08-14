import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/pagination_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../../common/models/public/pagination_params.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../domain/entities/company_ad_entity.dart';

class CustomContainerAdvertise extends StatelessWidget {
  const CustomContainerAdvertise({
    super.key,
    required this.title,
    required this.price,
    required this.function,
    required this.filter,
    this.context,
    required this.onTotalPriceUpdated, // New callback
  });

  final String title;
  final num price;
  final Function function;
  final String filter;
  final BuildContext? context;
  final ValueChanged<num> onTotalPriceUpdated; // New callback

  @override
  Widget build(BuildContext context) {
    return PaginationView<CompanyAdEntity>(
      loadingWidget: Shimmer.fromColors(
        baseColor: Colors.grey[100]!,
        highlightColor: Colors.white24,
        child: Column(
          children: List.generate(
              1,
              (index) => Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .15.h,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: AppColors.AUTH_CONTAINER_COLOR,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                  )),
        ),
      ),
      build: (ScrollController scrollController, List<CompanyAdEntity> data) {
        final numberOfAdvertises = data.length;
        final totalPrice = price * numberOfAdvertises;

        // Notify the parent widget about the total price for this container
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onTotalPriceUpdated(totalPrice);
        });

        return GestureDetector(
          onTap: () {
            ManageVibration.vibrate();
            function();
          },
          child: Container(
            margin: EdgeInsetsDirectional.only(bottom: 20.h),
            padding: EdgeInsetsDirectional.symmetric(
                vertical: 15.h, horizontal: 15.w),
            width: double.infinity,
            height: 80.h,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Styles.headerText(
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
                const SizedBox(width: 6),
                if (numberOfAdvertises > 0)
                  Text(
                    '($numberOfAdvertises)',
                    style: Styles.mediumText(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                if (numberOfAdvertises > 0) const Spacer(),
                if (numberOfAdvertises > 0)
                  Text(
                    '$totalPrice',
                    style: Styles.mediumText(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                if (numberOfAdvertises > 0)
                  IconButton(
                    onPressed: () {
                      ManageVibration.vibrate();
                    },
                    icon: Icon(
                      Icons.check_circle,
                      color: numberOfAdvertises > 0
                          ? AppColors.SECONDARY_COLOR
                          : Colors.transparent,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      fetchData: (PaginationParams paginationParams) {
        return context.read<CreateCompanyAdCubit>().getCompanyAdPosts(
              filter,
              params: paginationParams,
            );
      },
    );
  }
}
