import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/numbers_extensions.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import 'restaurant_orders.dart';
import '../widgets/restaurant_statistics_view.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/utils/custom_show_dialog.dart';
import '../../../../../core/widget/common/tab_widget.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../core/widget/custom_switch_button.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../edit_food/presentation/pages/edit_food_view.dart';
import '../cubit/restaurant_dashboard_cubit.dart';
import '../widgets/restaurant_photo_widget.dart';
import '../../../../../helpers/manage_vibration.dart';

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
  late RestaurantDashboardCubit _cubit;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit = context.read<RestaurantDashboardCubit>();
    _cubit.initialize();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          _cubit.loadData(); // التبويب الخاص بـ Available
          break;
        case 1:
          _cubit.loadDataPast(); // التبويب الخاص بـ Past
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
            child: CustomScaffold(
              enableCustomAppBar: true,
              appBar: BackAppBar(
                label: LocaleKeys.restaurantMode.localize,
              ),
              body: BlocBuilder<RestaurantDashboardCubit,
                      RestaurantDashboardState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        // const Sizer(),
                        // Align(
                        //     alignment: AlignmentDirectional.topStart,
                        //     child: Padding(
                        //       padding:
                        //           const EdgeInsets.symmetric(horizontal: 6.0),
                        //       child: Text(
                        //         LocaleKeys.restaurantMode.localize,
                        //         style: Styles.headerText(fontSize: 40),
                        //       ),
                        //     )),
                        Container(
                          color:
                              context.isDarkMode ? Colors.black : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: List.generate(3, (index) {
                              final labels = [
                                context.isArabic
                                    ? 'طلبات متاحة'
                                    : LocaleKeys.availableRequest.localize,
                                context.isArabic
                                    ? 'طلبات سابقة'
                                    : LocaleKeys.pastRequests.localize,
                                '', // Empty for icon tab
                              ];

                              return Expanded(
                                child: AnimatedBuilder(
                                  animation: _tabController,
                                  builder: (context, _) {
                                    final isSelected =
                                        _tabController.index == index;

                                    // For the third tab (Settings/Filter), show icon
                                    if (index == 2) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        child: GestureDetector(
                                          onTap: () {
                                            ManageVibration.vibrate();
                                            _tabController.animateTo(index);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(top: 10.h),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.h),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40.h),
                                              color: isSelected
                                                  ? AppColors
                                                      .getButtonPrimaryColor(
                                                          context)
                                                  : AppColors.getFillColor(
                                                      context),
                                              border: Border.all(
                                                color: AppColors
                                                    .getButtonPrimaryColor(
                                                        context),
                                                width: 2,
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.tune,
                                                color: isSelected
                                                    ? (context.isDarkMode
                                                        ? Colors.black
                                                        : Colors.white)
                                                    : AppColors.getTextColor(
                                                        context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    // For normal tabs
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      child: TabWidget(
                                        textSize: 18,
                                        title: labels[index],
                                        selected: isSelected,
                                        onTap: () {
                                          ManageVibration.vibrate();
                                          _tabController.animateTo(index);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            // physics: const NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: [
                              const AvailableRequestFood(),
                              const PastRequestFood(),
                              RestaurantSettingScreen(widget: widget),
                            ],
                          ),
                        ),
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

  void _showActivationDialog(BuildContext context, bool newValue) {
    showDialog(
      context: context,
      builder: (dialogContext) => _ActivationDialog(
        newValue: newValue,
        parentContext: context,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
      builder: (context, state) {
        return SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
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
                        onChanged: (v) => _showActivationDialog(context, v),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (state.info != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Label(
                          text: LocaleKeys.myRating.localize,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: AppColors.getButtonPrimaryWhiteColor(
                                  context)),
                        ),
                        Row(
                          children: [
                            Label(
                              text: "${state.info?.totalRating ?? 0}"
                                  .toArabicNumbers(context),
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.w700,
                                  color: context.isDarkMode
                                      ? AppColors.whiteColor
                                      : AppColors.PRIMARY_COLOR),
                            ),
                            const Sizer(
                              width: 8,
                            ),
                            RatingBar(
                              initialRating:
                                  state.info!.totalRating?.toDouble() ?? 0,
                              ignoreGestures: true,
                              allowHalfRating: true,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              ratingWidget: RatingWidget(
                                full: SvgPicture.asset(Assets.star1),
                                half: SvgPicture.asset(Assets.halfStar),
                                empty: SvgPicture.asset(
                                  Assets.starEmpty,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.getTextColor(context),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              itemSize: 13,
                              onRatingUpdate: (double value) {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  // const Divider(),
                  const RestaurantStatisticsView(),
                  const Sizer(),
                  RestaurantPhotoPicker(
                      subcategoryId: state.info?.subcategoryId?.id ?? ''),
                  const Sizer(
                    height: 50,
                  ),
                  AppButton(
                    label: LocaleKeys.editFood.localize,
                    onPressed: () {
                      ManageVibration.vibrate();
                      context.push(Routes.EditFoodView,
                          extra: EditFoodParams(
                              restaurantId: widget.restaurantId,
                              subCategoryId:
                                  state.info?.subcategoryId?.id ?? ''));
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
                    backColor: AppColors.getButtonPrimaryColor(context),
                    style: Styles.headerText(
                        color: AppColors.getReversedTextColor(context)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AppButton(
                    label: LocaleKeys.deleteRegistration.localize,
                    onPressed: () {
                      ManageVibration.vibrate();
                      showConfirmationDialog(
                        context,
                        title: LocaleKeys.deleteRegistration.localize,
                        message: LocaleKeys.sureRemoveRestaurant.localize,
                        onConfirm: () async {
                          if (widget.restaurantId.isNotEmpty) {
                            final navigator = Navigator.of(context);
                            await context
                                .read<RestaurantDashboardCubit>()
                                .deleteRestaurantById(context,
                                    id: widget.restaurantId,
                                    subCategoryId:
                                        state.info?.subcategoryId?.id ?? '');
                            navigator.pop(true);
                          }
                        },
                      );
                    },
                    backColor: AppColors.getRedColor(context),
                    style: Styles.headerText(
                        color: AppColors.getReversedTextColor(context)),
                  ),
                  const Sizer(),
                ],
              ),
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
      child: SizedBox(
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
                ManageVibration.vibrate();
                final messenger = ScaffoldMessenger.of(context);
                final Uri phoneUri = Uri(scheme: 'tel', path: phone);
                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                } else {
                  messenger.showSnackBar(
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
                ManageVibration.vibrate();
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
        backgroundColor: AppColors.getFindFillColor(context),
        title: Center(
          child: Text(
            title,
            style: Styles.headerText(
              color: context.isDarkMode
                  ? AppColors.whiteColor
                  : AppColors.PRIMARY_COLOR,
            ),
          ),
        ),
        content: Text(
          message,
          style: Styles.mediumText(
            fontSize: 32,
            color: context.isDarkMode
                ? AppColors.whiteColor
                : AppColors.PRIMARY_COLOR,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
            child: Text(
              LocaleKeys.no.localize,
              style: Styles.mediumText(
                color: AppColors.getTextColor(context),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.getButtonPrimaryColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onConfirm,
            child: Text(
              LocaleKeys.yes.localize,
              style: Styles.mediumText(
                color: context.isDarkMode
                    ? AppColors.PRIMARY_COLOR
                    : AppColors.whiteColor,
              ),
            ),
          ),
        ],
      ));
}

void deleteItem(BuildContext context) {
  Navigator.of(context).pop();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Text(
      LocaleKeys.deleteSuccessfully.localize,
      style: Styles.mediumText(
        color:
            context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.whiteColor,
      ),
    )),
  );
}

class _ActivationDialog extends StatelessWidget {
  final bool newValue;
  final BuildContext parentContext;

  const _ActivationDialog({
    required this.newValue,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.getFindFillColor(parentContext),
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
          Text(
            LocaleKeys.alert.localize,
            textAlign: TextAlign.center,
            style: Styles.mediumText(
              color: AppColors.getRedColor(parentContext),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.areYouSureUpdate.localize,
            textAlign: TextAlign.center,
            style: Styles.mediumText(
              color: AppColors.getRedColor(parentContext),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: AppButton(
                  onPressed: () {
                    ManageVibration.vibrate();
                    Navigator.pop(context);
                  },
                  label: LocaleKeys.cancel.localize,
                  backColor: AppColors.getRedColor(parentContext),
                  color: AppColors.getReversedTextColor(parentContext),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: AppButton(
                  backColor: AppColors.getButtonPrimaryColor(parentContext),
                  onPressed: () async {
                    ManageVibration.vibrate();
                    Navigator.pop(context);
                    await parentContext
                        .read<RestaurantDashboardCubit>()
                        .changeConnectivityStatus(newValue);
                  },
                  label: LocaleKeys.update.localize,
                  color: AppColors.getReversedTextColor(parentContext),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
