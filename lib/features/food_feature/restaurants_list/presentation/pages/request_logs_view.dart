import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/expired_requests_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../core/widget/olx_pagination/banner.dart';
import '../../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../domain/entities/logs_entity.dart';
import '../cubit/restaurants_list_cubit.dart';
import 'log_details_screen.dart';

class RestaurantRequestLogsScreen extends StatefulWidget {
  const RestaurantRequestLogsScreen({super.key, this.onClose});

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
    _scrollController = ScrollController()
      ..addListener(_onScroll);
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
            return SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height *
                  .65, // Make sure it takes up full height
              child: const Center(
                child: CustomCircularProgressIndicator(),
              ),
            );
          }
          if (controller.reqLogs.isEmpty) {
            return Center(
              child: SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height *
                    .65, // Make sure it takes up full height
                child: Center(
                  // This will center it vertically and horizontally
                  child: CustomEmptyWidget(
                    label: LocaleKeys.noResultsFound.tr(),
                  ),
                ),
              ),
            );
          }

          if (!state.isLoading) {
            return OlxPaginationWidget(
              itemsPerPage: 2,
              loadPage: (page) async {},
              banners: bannersList,
              items: List.generate(
                controller.reqLogs.length,
                    (index) {
                      final request = controller.reqLogs[index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TripLogRequestCard(
                          orderData: request,
                          index: index,
                        ),
                      );
                    },
              ),
            );
           /* return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.reqLogs.length,
              itemBuilder: (context, index) {
                final request = controller.reqLogs[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TripLogRequestCard(
                    orderData: request,
                    index: index,
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Sizer();
              },
            );*/
          } else {
            return SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height *
                  .7, // Make sure it takes up full height
              child: const Center(
                child: CustomCircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

class TripLogRequestCard extends StatelessWidget {
  final LogsRequestLogsEntity orderData;
  final int index;

  const TripLogRequestCard(
      {super.key, required this.orderData, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Label(
          text: orderData.restaurantId?.name ?? "N/A",
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        ...?orderData.orders?.map((order) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                  onTap: () async {
                    if (orderData.seen == false) {
                      context
                          .read<RestaurantsCubit>()
                          .setReqSeen(params: orderData.id ?? '');
                    }
                    final updatedLogsEntity = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            BlocProvider<RestaurantsCubit>(
                              create: (context) =>
                                  serviceLocator<RestaurantsCubit>(),
                              child: LogDetailsScreen(logsEntity: orderData),
                            ),
                      ),
                    );
                    if (updatedLogsEntity != null) {
                      context.read<RestaurantsCubit>().loadInitialReqLogs();
                    }
                  },
                  child: Container(
                    // elevation: context.isDarkMode ? 0 : 2,
                      decoration: BoxDecoration(
                        color: (
                            orderData.seen == true
                            ?
                            AppColors.getButtonPrimaryColor(context)
                            : AppColors.getRedColor(context)
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: order.foodId?.picture?.mediaKey !=
                                  null
                                  ? Image.network(
                                order.foodId?.picture?.mediaKey??UIConst.imageBaseUrl,
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
                                    order.foodId?.foodName ?? (context.isArabic ? 'غير معروف' : 'Unknown'),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.getReversedTextColor(context)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${
                              context.isArabic
                                  ? numAr(order.price ?? 0)
                                  : order.price.toString()
                            } ${context.isArabic?orderData.currencyAr:orderData.currencyEn}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.getReversedTextColor(context)),
                                  ),
                                ],
                              ),
                            ),
                          ]))),
            ) ),
        // InkWell(
        //   onTap: () async {
        //     if (orderData.seen == false) {
        //       context
        //           .read<RestaurantsCubit>()
        //           .setReqSeen(params: orderData.id ?? '');
        //     }
        //     final updatedLogsEntity = await Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (_) => BlocProvider<RestaurantsCubit>(
        //           create: (context) => serviceLocator<RestaurantsCubit>(),
        //           child: LogDetailsScreen(logsEntity: orderData),
        //         ),
        //       ),
        //     );
        //     if (updatedLogsEntity != null) {
        //       context.read<RestaurantsCubit>().loadInitialReqLogs();
        //     }
        //   },
        //   child: Container(
        //     // elevation: context.isDarkMode ? 0 : 2,
        //     decoration: BoxDecoration(
        //       color: (
        //           // orderData.seen == true
        //           // ?
        //           AppColors.getFindFillColor(context)
        //           //: AppColors.getRedColor(context)
        //           ),
        //       borderRadius: BorderRadius.circular(15),
        //     ),
        //     child: Row(
        //       children: [
        //         ClipRRect(
        //           borderRadius: BorderRadius.circular(15),
        //           child: orderData.userId?.userProfile?.profilePictureKey !=
        //                       null &&
        //                   orderData.userId!.userProfile!.profilePictureKey!
        //                       .mediaKey!.isNotEmpty
        //               ? Image.network(
        //                   orderData.userId!.userProfile!.profilePictureKey!
        //                       .mediaKey!,
        //                   width: 100,
        //                   height: 80,
        //                   fit: BoxFit.cover,
        //                   errorBuilder: (context, error, stackTrace) {
        //                     return Container(
        //                       width: 100,
        //                       height: 70,
        //                       color: Colors.grey[200],
        //                       child: const Icon(
        //                         Icons.broken_image,
        //                         size: 40,
        //                         color: Colors.grey,
        //                       ),
        //                     );
        //                   },
        //                 )
        //               : Container(
        //                   width: 100,
        //                   height: 70,
        //                   color: Colors.grey[200],
        //                   child: const Icon(
        //                     Icons.broken_image,
        //                     size: 40,
        //                     color: Colors.grey,
        //                   ),
        //                 ),
        //         ),
        //         const SizedBox(width: 12),
        //
        //         // MAIN CONTENT
        //         Expanded(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             children: [
        //               Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //
        //               Text(
        //                 (orderData.orders != null &&
        //                         index < orderData.orders!.length)
        //                     ? orderData.orders![index].foodId?.foodName ??
        //                         'Unknown'
        //                     : context.isArabic?'غير معروف':'Unknown',
        //                 style: TextStyle(
        //                     fontSize: 16,
        //                     fontWeight: FontWeight.w600,
        //                     color: AppColors.getTextColor(context)),
        //                 maxLines: 1,
        //                 overflow: TextOverflow.ellipsis,
        //               ),
        //               const SizedBox(height: 8),
        //               Text(
        //                 (orderData.orders != null &&
        //                         index < orderData.orders!.length) ?
        //                 (context.isArabic?numAr(orderData.orders![index].price??0):orderData.orders![index].price.toString()
        //                 ): context.isArabic?'صفر':'00',
        //                 style: TextStyle(
        //                     fontSize: 16,
        //                     fontWeight: FontWeight.w600,
        //                     color: AppColors.getTextColor(context)),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],);
  }
}
