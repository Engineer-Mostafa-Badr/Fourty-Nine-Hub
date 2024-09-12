import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/pagination_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_audio_streaming/zego_uikit_prebuilt_live_audio_room.dart';
import 'package:shimmer/shimmer.dart';
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
                padding: EdgeInsets.only(bottom: 15.zH),
                child: Container(
                  height: MediaQuery.of(context).size.height * .15.zH,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10.zW),
                  padding: EdgeInsets.symmetric(horizontal: 10.zW),
                  decoration: BoxDecoration(
                    color: AppColors.AUTH_CONTAINER_COLOR,
                    borderRadius: BorderRadius.circular(20.zR),
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
            function();
          },
          child: Container(
            margin: const EdgeInsetsDirectional.only(bottom: 20),
            padding: const EdgeInsetsDirectional.symmetric(vertical: 7, horizontal: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: Styles.headerText(color: Theme.of(context).scaffoldBackgroundColor),
                ),
                const SizedBox(width: 6),
                if(numberOfAdvertises >0)
                  Text(
                    '($numberOfAdvertises)',
                    style: Styles.mediumText(color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                const Spacer(),
                if(numberOfAdvertises >0)
                Text(
                  '$totalPrice',
                  style: Styles.mediumText(color: Theme.of(context).scaffoldBackgroundColor),
                ),
                IconButton(
                  onPressed: () {},
                  icon:  Icon(
                    Icons.check_circle,
                    color:numberOfAdvertises >0? AppColors.SECONDARY_COLOR :Colors.transparent,
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

