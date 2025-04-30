import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_dashboard_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/pages/restaurant_dashboard_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/widgets/restaurant_order_card.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../social_media/instagram/presentation/widgets/comment_widget_insta.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../social_media/twitter/presentation/widgets/report_view.dart';
import '../../../food_cart/presentation/pages/cart_view.dart';
import '../../domain/entity/order_food_entity.dart';


class AvailableRequestFood extends StatefulWidget {
  const AvailableRequestFood({super.key});

  @override
  State<AvailableRequestFood> createState() => _AvailableRequestFoodState();
}

class _AvailableRequestFoodState extends State<AvailableRequestFood> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<RestaurantDashboardCubit>().getOrders(false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<RestaurantDashboardCubit>().getOrders(false);
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
      body: BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
        builder: (context, state) {
          final controller = context.read<RestaurantDashboardCubit>();

          if (controller.orders.isEmpty) {
            return Center(child: Label(text: LocaleKeys.thereNoItems.localize));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final data = controller.orders[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.isDarkMode ? AppColors.whiteColor : Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? AppColors.PRIMARY_COLOR
                            : AppColors.cD9D9D9,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ImageFromInternet(
                                      isCircle: true,
                                      image: data.userId!.userProfile!.profilePictureKey!.mediaKey!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: -15,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 2,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.star, color: Colors.yellow, size: 14),
                                            const SizedBox(width: 2),
                                            Text(
                                              data.userRate?.toStringAsFixed(1) ?? "0",
                                              style: Styles.smallText(
                                                // fontSize: 12,
                                                // color:  context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  // width: 60,
                                  child: Text(
                                    data.userId!.firstName ?? "",
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: Styles.mediumText(
                                      // fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color:  context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,

                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // if (data.orders != null &&
                          //     data.orders!.isNotEmpty &&
                          //     data.orders![index].foodId != null)
                            Expanded(
                              child: Column(
                                // spacing: 10,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(height: 5,),
                                  Label(
                                    // text: data.orders!
                                    //     .map((e) => (e.foodId?.foodName ?? "").toString())
                                    //     .join(', '),
                                    text: data.orders?[index].foodId?.foodName ?? "N/A",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    // textAlign: TextAlign.end,
                                    style: Styles.mediumText(
                                      fontWeight: FontWeight.w600,
                                      color:  context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,


                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Label(
                                    text: data.orders!
                                        .map((e) => (e.price ?? 0).toString())
                                        .join(', '),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    // textAlign: TextAlign.end,
                                    style: Styles.mediumText(
                                      fontWeight: FontWeight.w600,
                                      color:  context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(width: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              Assets.carImage,
                              width: 100,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(
                            text: "30 Mins",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Label(
                            text: "Today",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Text("Here${state.orders?.data?.subcategoryId ?? ""}"),
                    CallMessageReportButtonsDashBoard(item: data, subcategoryId:state.orders?.data?.subcategoryId ?? "", index: index,),
                    const SizedBox(height: 8),
                    AppButton(
                      height: 40,
                      color: AppColors.whiteColor,
                      backColor: AppColors.PRIMARY_COLOR,
                      label: "Complete",
                      onPressed: () {
                        controller.completeOrder(data.id!);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CallMessageReportButtonsDashBoard extends StatelessWidget {
  final OrderEntity item;
  final String subcategoryId;
  final int index;
  const CallMessageReportButtonsDashBoard(
      {super.key, required this.item, 
        required this.subcategoryId,
        required this.index
      });
  @override
  Widget build(BuildContext context) {
    // final isChatEnabled = item.enableOrDisableChat?.toLowerCase() == 'enable';
    final isChatEnabled = item.openCallAndChat != 'disable';
    return Row(
      // spacing: 15,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              Assets.phoneIconRed,
              width: 22,
              height: 22,
              color: isChatEnabled
                  ? AppColors.PRIMARY_COLOR_DARK
                  : AppColors.GREY_DARK_COLOR,
            ),
            color: isChatEnabled
                ? AppColors.PRIMARY_COLOR
                : AppColors.GREY_DARK_COLOR,
            onPressed: isChatEnabled
                ? () {
              showModalBottomSheet(
                context: context,
                backgroundColor: cardDarkColor(context),
                shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      spacing: 16,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppButton(
                          backColor: AppColors.PRIMARY_COLOR,
                          color: AppColors.whiteColor,
                          onPressed: () {
                            Navigator.pop(context); // Close first sheet
                            // _showFreeCallBottomSheet(context, item);
                          },
                          label: LocaleKeys.freeCall.localize,
                        ),
                        AppButton(
                          backColor: AppColors.cD9D9D9,
                          color: AppColors.black,
                          onPressed: () {
                            Navigator.pop(context); // Close first sheet
                            _showRegularCallBottomSheet(
                                context, item); // Open second
                          },
                          label: LocaleKeys.regularCall.localize,
                        ),
                      ],
                    ),
                  );
                },
              );
            }
                : () {
              SubscriptionMethod().subscribe(
                subscribeId: subcategoryId,
                title: item.orders?[index].foodId?.foodName ?? '',
              );
            },
          ),
        ),
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              Assets.mailIconRed,
              width: 18,
              height: 18,
              color: isChatEnabled
                  ? AppColors.PRIMARY_COLOR_DARK
                  : AppColors.GREY_DARK_COLOR,
            ),
            color: isChatEnabled
                ? AppColors.PRIMARY_COLOR
                : AppColors.GREY_DARK_COLOR,
            onPressed: isChatEnabled
                ? () {
              // BlocProvider.of<RestaurantDashboardCubit>(context)
              //     .getExpiredOrders();
              // Implement message functionality here
            }
                : () {
              SubscriptionMethod().subscribe(
                  subscribeId: subcategoryId ?? '',
                title: item.orders?[index].foodId?.foodName ?? '',
              );
            },
          ),
        ),
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              Assets.reportRed,
              width: 18,
              height: 18,
              color: isChatEnabled
                  ? AppColors.PRIMARY_COLOR_DARK
                  : AppColors.GREY_DARK_COLOR,
            ),

            color: AppColors.PRIMARY_COLOR_DARK,
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: cardDarkColor(context),
                builder: (context) {
                  return SizedBox(
                    height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
                    child: ReportView(
                      id: item.id!,
                      categoryId:  subcategoryId ?? '',
                    ),
                  );
                },
              );

              // Implement report functionality here
            },
          ),
        )
      ],
    );
  }

  void _showRegularCallBottomSheet(BuildContext context, OrderEntity item) {
    bool isBookingForAnotherClient = false;
    bool hasPhoneError = false;
    final TextEditingController phoneController =
    TextEditingController(text: item.phone ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardDarkColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            phoneController.addListener(() {
              if (hasPhoneError && phoneController.text.isNotEmpty) {
                setState(() {
                  hasPhoneError = false;
                });
              }
            });

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    activeColor:context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,
                    contentPadding: EdgeInsets.zero,
                    value: isBookingForAnotherClient,
                    onChanged: (value) {
                      setState(() {
                        isBookingForAnotherClient = value!;
                        hasPhoneError = false;
                        if (isBookingForAnotherClient) {
                          phoneController.clear();
                        } else {
                          phoneController.text = item.phone ?? '';
                        }
                      });
                    },
                    title: Text(
                      LocaleKeys.imBookingOfAnotherClient.localize,
                      style:  TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    enabled: isBookingForAnotherClient,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          color: AppColors.PRIMARY_COLOR,
                          Assets.phoneIconRed,
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                        ),
                      ),
                      hintText: LocaleKeys.phone.localize,
                      errorText: hasPhoneError
                          ? LocaleKeys.enterPhoneNumber.localize
                          : null,
                      filled: true,
                      hintStyle: Styles.mediumText(
                        color:  AppColors.PRIMARY_COLOR_DARK
                      ),
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      backColor: AppColors.PRIMARY_COLOR,
                      color: AppColors.whiteColor,
                      label: LocaleKeys.submit.localize,
                      onPressed: () {
                        final enteredNumber = phoneController.text.trim();
                        if (isBookingForAnotherClient) {
                          if (enteredNumber.isEmpty) {
                            setState(() {
                              hasPhoneError = true;
                            });
                            return;
                          }
                          launchUrlString("tel://$enteredNumber");
                        } else {
                          launchUrlString("tel://${item.phone}");
                        }

                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }



}

// class CallMessageReportButtonsDashBoard extends StatelessWidget {
//   final OrderEntity item;
//   final String subcategoryId;
//
//   const CallMessageReportButtonsDashBoard(
//       {super.key, required this.item, required this.subcategoryId});
//
//   @override
//   Widget build(BuildContext context) {
//     // final isChatEnabled = item.enableOrDisableChat != 'disable';
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           //if enabled color = blue
//           _buildButtonWithIcon(
//             // label: LocaleKeys.call.localize,
//             icon:Assets.phoneIconRed,
//             color: item.openCallAndChat != 'disable'
//                 ? AppColors.PRIMARY_COLOR_DARK
//                 : AppColors.GREY_DARK_COLOR,
//             onPressed: item.openCallAndChat != 'disable'
//                 ? () => launchUrlString("tel://${item.phone}")
//                 : () {
//               SubscriptionMethod().subscribe(
//                   subscribeId: subcategoryId,
//                   title: LocaleKeys.restaurantDashboard.localize);
//             },
//           ),
//           const SizedBox(width: 4),
//           _buildButtonWithIcon(
//             // label: LocaleKeys.message.localize,
//             icon: Assets.emailIcon,
//             color: item.openCallAndChat != 'disable'
//                 ? AppColors.PRIMARY_COLOR_DARK
//                 : AppColors.GREY_DARK_COLOR,
//             onPressed: item.openCallAndChat != 'disable'
//                 ? () {
//               // BlocProvider.of<RestaurantsCubit>(context)
//               //     .getExpiredOrders();
//               // Implement message functionality here
//             }
//                 : () {
//               SubscriptionMethod().subscribe(
//                   subscribeId: subcategoryId,
//                   title: LocaleKeys.restaurantDashboard.localize);
//             },
//           ),
//           const SizedBox(width: 4),
//           _buildButtonWithIcon(
//             // label: LocaleKeys.report.localize,
//             icon:  Assets.reportRed,
//             color: AppColors.PRIMARY_COLOR_DARK,
//             onPressed: () async {
//               await showModalBottomSheet(
//                 context: context,
//                 isScrollControlled: true,
//                 backgroundColor: cardDarkColor(context),
//                 builder: (context) {
//                   return SizedBox(
//                     height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
//                     child: ReportView(
//                       id: item.id!,
//                       categoryId: item.restaurantId!,
//                     ),
//                   );
//                 },
//               );
//
//               // Implement report functionality here
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildButtonWithIcon({
//     required String icon,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return IconButton(
//       icon: SvgPicture.asset(icon, color: color ,),
//       onPressed: onPressed,
//     );
//   }
//
// }

class PastRequestFood extends StatefulWidget {
  const PastRequestFood({super.key});

  @override
  State<PastRequestFood> createState() => _PastRequestFoodState();
}


class _PastRequestFoodState extends State<PastRequestFood> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<RestaurantDashboardCubit>().getOrdersPast(false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<RestaurantDashboardCubit>().getOrdersPast(false);
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
      body: BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
        builder: (context, state) {
          final controller = context.read<RestaurantDashboardCubit>();

          if (controller.ordersPast.isEmpty) {
            return Center(child: Label(text: LocaleKeys.thereNoItems.localize));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: controller.ordersPast.length,
            itemBuilder: (context, index) {
              final data = controller.ordersPast[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.isDarkMode ? AppColors.whiteColor : Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? AppColors.PRIMARY_COLOR
                            : AppColors.cD9D9D9,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ImageFromInternet(
                                      isCircle: true,
                                      image: data.userId!.userProfile!.profilePictureKey!.mediaKey!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: -15,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 2,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.star, color: Colors.yellow, size: 14),
                                            const SizedBox(width: 2),
                                            Text(
                                              data.userRate?.toStringAsFixed(1) ?? "0",
                                              style: Styles.smallText(
                                                // fontSize: 12,
                                                // color:  context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  // width: 60,
                                  child: Text(
                                    data.userId!.firstName ?? "",
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: Styles.mediumText(
                                      // fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color:  context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,

                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // if (data.orders != null &&
                          //     data.orders!.isNotEmpty &&
                          //     data.orders![0].foodId != null)
                            Expanded(
                              child: Column(
                                // spacing: 10,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(height: 5,),
                                  Label(
                                    text: data.orders!
                                        .map((e) => (e.foodId?.foodName ?? "N/A").toString())
                                        .join(', '),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    // textAlign: TextAlign.end,
                                    style: Styles.mediumText(
                                      fontWeight: FontWeight.w600,
                                      color:  context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,

                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Label(
                                    text: data.orders!
                                        .map((e) => (e.price ?? 0).toString())
                                        .join(', '),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    // textAlign: TextAlign.end,
                                    style: Styles.mediumText(
                                      fontWeight: FontWeight.w600,
                                      color:  context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(width: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              Assets.carImage,
                              width: 100,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(
                            text: "30 Mins",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Label(
                            text: "Today",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Text("Here${state.orders?.data?.subcategoryId ?? ""}"),
                    CallMessageReportButtonsDashBoard(item: data, subcategoryId:state.orders?.data?.subcategoryId ?? "", index: index,),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}



