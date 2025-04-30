import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/rating_stars.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/create_resturant_view.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/pages/restaurant_orders.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/widgets/restaurant_statistics_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcatigories_restaurant_card.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/elevated_button.dart';
import '../../../../../core/utils/custom_show_dialog.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../core/widget/custom_switch_button.dart';
import '../../../../../core/widget/custom_switch_button.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../create_restaurant/views/widgets/photo/restaurant_photo_picker.dart';
import '../../../edit_food/presentation/pages/edit_food_view.dart';
import '../cubit/restaurant_dashboard_cubit.dart';
import '../widgets/restaurant_order_card.dart';
import '../widgets/restaurant_photo_widget.dart';

class RestaurantDashboardView extends StatefulWidget {
  final String restaurantId;

  RestaurantDashboardView({super.key, required dynamic payload})
      : restaurantId =
            payload is String ? payload : (payload['id'] as String?) ?? "";

  @override
  State<RestaurantDashboardView> createState() =>
      _RestaurantDashboardViewState();
}

class _RestaurantDashboardViewState extends State<RestaurantDashboardView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    context.read<RestaurantDashboardCubit>().initialize();
  }
  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: 3, vsync: this); // 3 tabs
  //   context.read<RestaurantDashboardCubit>().initialize();
  // }
  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      final cubit = context.read<RestaurantDashboardCubit>();
      switch (_tabController.index) {
        case 0:
          cubit.loadData(); // التبويب الخاص بـ Available
          break;
        case 1:
          cubit.loadDataPast(); // التبويب الخاص بـ Past
          break;
        case 2:
        // إذا كان عندك تبويب ثالث (مثل الفلتر)، ضع ما يناسبك هنا
          break;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTab(String text, int index) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        bool isSelected = _tabController.index == index;
        return GestureDetector(
          onTap: () => _tabController.animateTo(index),
          child: AnimatedContainer(
            // width: 130,
            duration: const Duration(milliseconds: 300),
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.isDarkMode
                      ? AppColors.PRIMARY_COLOR_DARK
                      : AppColors.PRIMARY_COLOR
                  : context.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10.0),
            ),
            alignment: Alignment.center,
            child: Label(
              text: text,
              style: Styles.mediumText(
                // fontSize: 12,
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabIcon(IconData icon, int index) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        bool isSelected = _tabController.index == index;
        return GestureDetector(
          onTap: () => _tabController.animateTo(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.isDarkMode
                      ? AppColors.PRIMARY_COLOR_DARK
                      : AppColors.PRIMARY_COLOR
                  : context.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocListener<RestaurantDashboardCubit, RestaurantDashboardState>(
          listener: (context, state) {
            // if (state.actionType == RideAction.download) {
            //   showSuccessMessage(
            //       context, state.downloadCompleted ?? "Download Successful");
            //   context.read<ReviewHealthCubit>().emit(
            //     state.copyWith(showSnackbar: false, actionType: RideAction.none),
            //   );
            // }
          },
          child:  CustomScaffold(
            appBar: AppBar(
              title: Text(LocaleKeys.restaurantDashboard.localize),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50.0),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: _buildTab(LocaleKeys.availableRequest.localize, 0),
                      ),
                      Expanded(
                        child: _buildTab(LocaleKeys.pastRequests.localize, 1),
                      ),
                      _buildTabIcon(Icons.tune, 2),
                    ],
                  ),
                ),
              ),
            ),
            body: BlocConsumer<RestaurantDashboardCubit, RestaurantDashboardState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return TabBarView(
                    // physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      const AvailableRequestFood(),
                      const PastRequestFood(),
                      RestaurantSettingScreen(widget: widget),
                    ],
                  );
                }),
          )));

  }
}

class RestaurantSettingScreen extends StatelessWidget {
  const RestaurantSettingScreen({
    super.key,
    required this.widget,
  });

  final RestaurantDashboardView widget;
  // bool editFood = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantDashboardCubit, RestaurantDashboardState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Label(
                          text: state.isRestaurant?.isActive ?? false
                              ? LocaleKeys.ready.localize
                              : LocaleKeys.notAvailable.localize,
                          style: Styles.headerText(),
                        )),
                    CustomSwitchButton(

                      value: state.isRestaurant?.isActive ?? false,
                      onChanged: (v) async {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Title centered at top
                                Text(
                                  LocaleKeys.alert.localize,
                                  textAlign: TextAlign.center,
                                  style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR_DARK,
                                    // fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Confirmation message
                                Text(
                                  LocaleKeys.areYouSureUpdate.localize,
                                  // 'Are you sure you want to ${v ? 'activate' : 'deactivate'} your restaurant?',
                                  textAlign: TextAlign.center,
                                  style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR_DARK,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Buttons row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Close button
                                    Expanded(
                                      child: AppButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext); // Close dialog
                                        },
                                        label: LocaleKeys.cancel.localize,
                                        // variant: AppButtonVariant.outlined,
                                        // width: 100,
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    // Open button
                                    Expanded(
                                      child: AppButton(
                                        backColor: AppColors.PRIMARY_COLOR,
                                        onPressed: () async {
                                          Navigator.pop(dialogContext); // Close dialog
                                          await context
                                              .read<RestaurantDashboardCubit>()
                                              .changeConnectivityStatus(v);
                                        },
                                        label:  LocaleKeys.update.localize,
                                        // width: 100,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )

                  ],
                ),
                const SizedBox(height: 16,),
                if (state.info != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Label(text: LocaleKeys.myRating.localize,
                        style: Styles.mediumText(
                          fontWeight: FontWeight.w500,
                          color: context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR
                        ),
                      ),
                      Row(
                        children: [
                          RatingBar(
                            initialRating:state.info!.totalRating?.toDouble() ?? 0,
                            ignoreGestures: true,
                            itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                            ratingWidget: RatingWidget(
                              full: SvgPicture.asset(Assets.star1),
                              half: SvgPicture.asset(Assets.star1),
                              empty: SvgPicture.asset(Assets.starEmpty),
                            ),
                            itemSize: 13,
                            onRatingUpdate: (double value) {},
                          ),
                          Label(text: "${state.info?.totalRating ?? 0}",
                            style:  Styles.mediumText(
                              fontWeight: FontWeight.w700,
                                color: context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 16,),
                // const Divider(),
                const RestaurantStatisticsView(),
                const Sizer(),
                RestaurantPhotoPicker(
                    subcategoryId: state.info
                        ?.subcategoryId?.id ??
                        ''
                ),
                const Sizer(height: 50,),
                AppButton(
                  label: LocaleKeys.editFood.localize,
                  onPressed: () {
                    context.push(Routes.EditFoodView,
                        extra: EditFoodParams(
                            restaurantId: widget.restaurantId ?? '',
                            subCategoryId:
                            state.info
                                ?.subcategoryId?.id ??
                                ''));
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => BlocProvider.value(
                    //         value: serviceLocator<RestaurantDetailsCubit>(),
                    //         child:
                    //             EditFoodView(payload: widget.restaurantId!),
                    //       ),
                    //     ));
                    // setState(() {
                    //   editFood = true;
                    // });
                  },
                  backColor: AppColors.PRIMARY_COLOR,
                  style: Styles.headerText(color: Colors.white),
                ),
                const SizedBox(height: 15,),
                AppButton(
                  label: LocaleKeys.deleteRegistration.localize,
                  onPressed: () {
                    showConfirmationDialog(
                      context,
                      title: LocaleKeys.deleteRegistration.localize,
                      message:
                      LocaleKeys.sureRemoveRestaurant.localize,
                      onConfirm: () async {
                        if (widget.restaurantId.isNotEmpty) {
                          await context
                              .read<RestaurantDashboardCubit>()
                              .deleteRestaurantById(context,
                              id: widget.restaurantId,
                              subCategoryId: state.info
                                  ?.subcategoryId?.id ??
                                  '');
                          context.pop(true);
                        }
                      },
                    );
                  },
                  backColor: AppColors.PRIMARY_COLOR_DARK,
                  style: Styles.headerText(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



// class RestaurantSetting2Screen extends StatelessWidget {
//   const RestaurantSetting2Screen({
//     super.key,
//     required this.widget,
//   });
//
//   final RestaurantDashboardView widget;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<RestaurantDashboardCubit, RestaurantDashboardState>(
//       listener: (context, state) {
//         // TODO: implement listener
//       },
//       builder: (context, state) {
//         return Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: CustomScrollView(
//             slivers: [
//               SliverToBoxAdapter (
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                               child: Label(
//                                 text: state.isRestaurant?.isActive ?? false
//                                     ? LocaleKeys.ready.localize
//                                     : LocaleKeys.notAvailable.localize,
//                                 style: Styles.headerText(),
//                               )),
//                           CustomSwitchButton(
//                               value: state.isRestaurant?.isActive ?? false,
//                               onChanged: (v) async {
//                                 print("vsssss${!v}");
//                                 await context
//                                     .read<RestaurantDashboardCubit>()
//                                     .changeConnectivityStatus(v);
//                               })
//                         ],
//                       ),
//                       SizedBox(height: 16,),
//                       if (state.info != null)
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Label(text: LocaleKeys.myRating.localize,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 RatingBar(
//                                   initialRating:state.info!.totalRating ?? 0,
//                                   ignoreGestures: true,
//                                   itemPadding: const EdgeInsets.symmetric(horizontal: 3),
//                                   ratingWidget: RatingWidget(
//                                     full: SvgPicture.asset(Assets.star1),
//                                     half: SvgPicture.asset(Assets.star1),
//                                     empty: SvgPicture.asset(Assets.starEmpty),
//                                   ),
//                                   itemSize: 13,
//                                   onRatingUpdate: (double value) {},
//                                 ),
//                                 Label(text: "${state.info?.totalRating ?? 0}",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       // Text(
//                       //   '${state.info!.totalRating?.toStringAsFixed(1) ?? '0.0'} (${state.info!.numberOfReviews ?? 0} reviews)',
//                       //   style: TextStyle(fontSize: 12),
//                       // ),
//
//                       // SizedBox(
//                       //   height: 0.25.sh,
//                       //   child: PropertyCard(
//                       //     myRestaurant: true,
//                       //     item: state.info!,
//                       //     mealId: 'mealId',
//                       //     favouriteRestaurant: (String id) {},
//                       //   ),
//                       // ),
//                       SizedBox(height: 16,),
//                       // const Divider(),
//                       RestaurantStatisticsView(),
//                       const Sizer(),
//                       Padding(
//                         padding: EdgeInsets.all(4.w),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Expanded(
//                               child: AppButton(
//                                 label: LocaleKeys.editRegistration.localize,
//                                 onPressed: () async {
//                                   if (state.isRestaurant?.restaurantId != null &&
//                                       state.isRestaurant?.restaurantId != '' &&
//                                       state.info?.subcategoryId?.id != null) {
//                                     await Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               BlocProvider<CreateRestaurantCubit>(
//                                                 create: (context) => serviceLocator(),
//                                                 child: CreateRestaurantForm(
//                                                     from: 'update',
//                                                     restaurantId: state
//                                                         .isRestaurant?.restaurantId,
//                                                     subcategoryId: state.info
//                                                         ?.subcategoryId?.id ??
//                                                         ''),
//                                               ),
//                                         ));
//                                     context
//                                         .read<RestaurantDashboardCubit>()
//                                         .initialize();
//                                   }
//                                 },
//                                 backColor: AppColors.PRIMARY_COLOR,
//                                 style: Styles.headerText(color: Colors.white),
//                               ),
//                             ),
//                             const Sizer(),
//                             Expanded(
//                               child: AppButton(
//                                 label: LocaleKeys.deleteRegistration.localize,
//                                 onPressed: () {
//                                   showConfirmationDialog(
//                                     context,
//                                     title: LocaleKeys.deleteRegistration.localize,
//                                     message:
//                                     LocaleKeys.sureRemoveRestaurant.localize,
//                                     onConfirm: () async {
//                                       if (widget.restaurantId.isNotEmpty) {
//                                         await context
//                                             .read<RestaurantDashboardCubit>()
//                                             .deleteRestaurantById(context,
//                                             id: widget.restaurantId,
//                                             subCategoryId: state.info
//                                                 ?.subcategoryId?.id ??
//                                                 '');
//                                         context.pop(true);
//                                       }
//                                     },
//                                   );
//                                 },
//                                 backColor: AppColors.PRIMARY_COLOR_DARK,
//                                 style: Styles.headerText(color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // SliverToBoxAdapter(
//               //   child: Padding(
//               //     padding: EdgeInsets.only(
//               //         top: 15.h, left: 4.w, right: 4.w, bottom: 15.h),
//               //     child: AppButton(
//               //       label: LocaleKeys.subscribe.localize,
//               //       onPressed: () {
//               //         SubscriptionMethod().subscribe(
//               //             subscribeId: state.info?.subcategoryId?.id ?? '',
//               //             title: LocaleKeys.restaurantDashboard.localize);
//               //       },
//               //       backColor: AppColors.PRIMARY_COLOR_DARK,
//               //       style: Styles.headerText(color: Colors.white),
//               //     ),
//               //   ),
//               // ),
//               // SliverToBoxAdapter(
//               //   child: ListView.separated(
//               //       shrinkWrap: true,
//               //       physics: const NeverScrollableScrollPhysics(),
//               //       itemBuilder: (context, index) {
//               //         if (state.orders?.data.orders.length != null &&
//               //             index < (state.orders?.data.orders.length ?? 0)) {
//               //           final order = state.orders!.data.orders[index];
//               //           return Column(
//               //             children: [
//               //               RestaurantOrderCard(
//               //                 item: order,
//               //                 subCategoryId:
//               //                 state.info?.subcategoryId?.id ?? '',
//               //               ),
//               //               if (state.orders!.data.restaurantSubscriptionType !=
//               //                   'Not subscribed')
//               //                 Text(
//               //                   LocaleKeys.subscribeToContactTheClient.localize,
//               //                   style: Styles.headerText(
//               //                       color: AppColors.PRIMARY_COLOR_DARK),
//               //                 )
//               //               else
//               //                 const Sizer(),
//               //             ],
//               //           );
//               //         }
//               //         return const SizedBox();
//               //       },
//               //       separatorBuilder: (context, index) => const Sizer(
//               //         height: 20,
//               //       ),
//               //       itemCount: state.orders?.data.orders.length ?? 0),
//               // )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }



class CustomBottomSheet extends StatelessWidget {
  final String phone;

  const CustomBottomSheet({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              height: 44,
              color: AppColors.LIGHT_COLOR,
              backColor: context.isDarkMode
                  ? AppColors.PRIMARY_COLOR_DARK
                  : AppColors.PRIMARY_COLOR,
              label: LocaleKeys.freeCall.localize,
              style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
              onPressed: () async {
                final Uri phoneUri = Uri(scheme: 'tel', path: phone);
                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch $phone')),
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            AppButton(
              height: 44,
              color: AppColors.LIGHT_COLOR,
              backColor: AppColors.cD9D9D9,
              label: LocaleKeys.regularCall.localize,
              style: const TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
              onPressed: () {
                // You can implement another action for regular calls here
              },
            ),
          ],
        ),
      ),
    );
  }
}
void showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
}) {
  showAnimatedDialog(
      context,
      AlertDialog(
        title: Text(
          title,
          style: Styles.headerText(
              color:context.isDarkMode ?  AppColors.PRIMARY_COLOR : AppColors.whiteColor,
          ),
        ),
        content: Text(
          message,
          style: Styles.mediumText(
              color:context.isDarkMode ?  AppColors.whiteColor : AppColors.PRIMARY_COLOR,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
            child: Text(
              LocaleKeys.no.localize,
              style: Styles.mediumText(color:context.isDarkMode ?  AppColors.PRIMARY_COLOR : AppColors.whiteColor,),
            ),
          ),
          ElevatedButton(
            onPressed: onConfirm,
            child: Text(
              LocaleKeys.yes.localize,
              style: Styles.mediumText(color: context.isDarkMode ?  AppColors.PRIMARY_COLOR : AppColors.whiteColor,),
            ),
          ),
        ],
      ));
}

void deleteItem(BuildContext context) {
  Navigator.of(context).pop();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(LocaleKeys.deleteSuccessfully.localize,style: Styles.mediumText(
      color: context.isDarkMode ?  AppColors.PRIMARY_COLOR : AppColors.whiteColor,
    ),)),
  );
}
