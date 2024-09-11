import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/pagination_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';
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
      loadingWidget: const SizedBox.shrink(),
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

