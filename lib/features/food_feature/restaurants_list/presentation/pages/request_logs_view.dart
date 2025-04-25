import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/expired_requests_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../domain/entities/logs_entity.dart';
import '../cubit/restaurants_list_cubit.dart';
import 'log_details_screen.dart';

class RestaurantRequestLogsScreen extends StatefulWidget {
  const  RestaurantRequestLogsScreen({super.key, this.onClose});
  final VoidCallback? onClose;

  @override
  State<RestaurantRequestLogsScreen> createState() =>
      _RestaurantRequestLogsScreenState();
}

class _RestaurantRequestLogsScreenState
    extends State<RestaurantRequestLogsScreen> {
  late ScrollController _scrollController;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<RestaurantsCubit>().getReqLogs();
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
    return BlocBuilder<RestaurantsCubit, RestaurantsListState>(
        builder: (context, state) {
          final controller = context.read<RestaurantsCubit>();
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (controller.reqLogs.isEmpty ) {
            return Center(
              child: Text(
                LocaleKeys.noData.tr(),
              ),
            );
          }

          if (!state.isLoading) {
            return SizedBox(
              height:MediaQuery.sizeOf(context).height ,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: controller.reqLogs.length,
                      itemBuilder: (context, index) {
                        final request = controller.reqLogs[index];
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TripLogRequestCard(orderData: request,index: index,),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Sizer();
                      },
                    ),
                  ),
                  if (controller.isLoadingMoreLogs)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class TripLogRequestCard extends StatelessWidget {
  final LogsRequestLogsEntity orderData;
  final int index;

  const TripLogRequestCard({super.key, required this.orderData, required this.index});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16,),
        Label(text: orderData.restaurantId?.name ?? "N/A",
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20
        ),
        ),
        InkWell(
          onTap: () async {
            if(orderData.seen == false)
              context.read<RestaurantsCubit>().setReqSeen(params: orderData.id ?? '');
            final updatedLogsEntity = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider<RestaurantsCubit>(
                  create: (context) => serviceLocator<RestaurantsCubit>(),
                  child: LogDetailsScreen(logsEntity: orderData),
                ),
              ),
            );
            if (updatedLogsEntity != null) {
              context.read<RestaurantsCubit>().loadInitialReqLogs();
            }
          },
          // onTap: () async {
          //   if(orderData.seen == false)
          //   context.read<RestaurantsCubit>().setReqSeen(params: orderData.id ?? '');
          //
          //   final updatedLogsEntity = await Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (_) => BlocProvider<RestaurantsCubit>(
          //         create: (context) => serviceLocator<RestaurantsCubit>(),
          //         child: LogDetailsScreen(logsEntity: orderData),
          //       ),
          //     ),
          //   );
          //
          //   if (updatedLogsEntity != null) {
          //     // Update your list with the new data here
          //     context.read<RestaurantsCubit>().updateLogEntity(updatedLogsEntity);
          //   }
          // },

          child: Container(
                  // elevation: context.isDarkMode ? 0 : 2,
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? (orderData.seen == true ? AppColors.PRIMARY_COLOR : AppColors.PRIMARY_COLOR_LIGHT)
                  : (orderData.seen == true ? AppColors.GRAY_LIGHT_COLOR3 : AppColors.cD9D9D9),
              borderRadius: BorderRadius.circular(15),
            ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: orderData.userId?.userProfile?.profilePictureKey != null && orderData.userId!.userProfile!.profilePictureKey!.mediaKey!.isNotEmpty
                            ? Image.network(
                          orderData.userId!.userProfile!.profilePictureKey!.mediaKey!,
                          width: 100,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 70,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.broken_image,
                                size: 40,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                            : Container(
                          width: 100,
                          height: 70,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // MAIN CONTENT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              (orderData.orders != null && index < orderData.orders!.length)
                                  ? orderData.orders![index].foodId?.foodName ?? 'Unknown'
                                  : 'Unknown',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              (orderData.orders != null && index < orderData.orders!.length)
                                  ? (orderData.orders![index].price ?? 0.0).toStringAsFixed(2)
                                  : '0.00',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),
                ),
        ),
      ],
    );
  }


}

/*
  child: Container(
            decoration: BoxDecoration(
              color: orderData.seen == true ? Colors.white : AppColors.cD9D9D9,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: orderData.userId?.userProfile?.profilePictureKey != null &&
                      orderData.userId!.userProfile!.profilePictureKey!.mediaKey!.isNotEmpty
                      ? Image.network(
                    orderData.userId!.userProfile!.profilePictureKey!.mediaKey!,
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 70,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  )
                      : Container(
                    width: 100,
                    height: 70,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 🛠️ MAIN CONTENT (Fixed)
                Expanded(
                  child: SizedBox(
                    height: 80,
                    child: Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start, // 👈 force top alignment
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          (orderData.orders != null && index < orderData.orders!.length)
                              ? orderData.orders![index].foodId?.foodName ?? 'Unknown'
                              : 'Unknown',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          (orderData.orders != null && index < orderData.orders!.length)
                              ? (orderData.orders![index].price ?? 0.0).toStringAsFixed(2)
                              : '0.00',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
   */