import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../widgets/build_food_list.dart';
import '../../../restaurants_list/domain/entities/restaurant.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../../../restaurant_details/presentation/widgets/restaurant_header.dart';
import '../cubit/restaurant_details_cubit.dart';
import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../../helpers/manage_vibration.dart';

class RestaurantDetailsView extends StatefulWidget {
  final GetAllRestaurantEntity restaurant;

  const RestaurantDetailsView({super.key, required this.restaurant});

  @override
  State<RestaurantDetailsView> createState() => _RestaurantDetailsViewState();
}

class _RestaurantDetailsViewState extends State<RestaurantDetailsView> {
  late ScrollController _scrollController;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context
        .read<RestaurantDetailsCubit>()
        .loadData(id: widget.restaurant.id ?? '');
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context
          .read<RestaurantDetailsCubit>()
          .getMeals(id: widget.restaurant.id ?? '');
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
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BackAppBar(
          label: LocaleKeys.restaurantMenu.tr(),
          backColor: context.theme.appBarTheme.backgroundColor,
        ),
      ),
      // backgroundColor: scaffoldDarkColor(context),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
        builder: (context, state) {
          return state.isLoading
              ? const Center(
                  child: CustomCircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ListView(
                            controller: _scrollController,
                            children: [
                              RestaurantHeader(restaurant: widget.restaurant),
                              const Sizer(),
                              BuildFoodList(
                                restaurantId: widget.restaurant.id ?? '',
                              ),
                              if (context
                                      .read<RestaurantDetailsCubit>()
                                      .isLoadingMore ==
                                  true)
                                const Center(
                                  child: CustomCircularProgressIndicator(),
                                ),
                            ],
                          ),
                        ),
                        _viewCartButton(),
                      ],
                    ),
                    // when add to cart
                    // if (!state.isAddToCart)
                    //   Container(
                    //     decoration: BoxDecoration(
                    //       color: Colors.black.withOpacity(0.7),
                    //     ),
                    //     child: Center(
                    //       child: Container(
                    //           height: 300.h,
                    //           width: 250.w,
                    //           padding: EdgeInsets.all(30.w),
                    //           alignment: Alignment.center,
                    //           decoration: BoxDecoration(
                    //               color: Colors.white,
                    //               borderRadius: BorderRadius.circular(15.r)),
                    //           child: const CustomCircularProgressIndicator(
                    //             color: AppColors.PRIMARY_COLOR,
                    //           )),
                    //     ),
                    //   )
                  ],
                );
        },
      ),
    );
  }

  Widget _viewCartButton() {
    return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                ManageVibration.vibrate();
                if (context.isUserLoggedIn) {
                  context.push(Routes.FOODCART);
                } else {
                  return pleaseLoginDialog(context);

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(
                  //       LocaleKeys.pleaseLoginRegisterToEnjoyTheApp.localize,
                  //       style: Styles.smallText(
                  //           color: AppColors.whiteColor
                  //       ),
                  //     ),
                  //     backgroundColor: Colors.red,
                  //     duration: Duration(seconds: 4),
                  //     action: SnackBarAction(
                  //       label: LocaleKeys.login.localize,
                  //       textColor: Colors.white,
                  //       onPressed: () {
                  ManageVibration.vibrate();
                  //        // context.push(Routes.LOGIN);
                  //       },
                  //     ),
                  //   ),
                  // );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                backgroundColor: AppColors.getRedColor(context),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.view_cart.tr(),
                    style: Styles.headerText(
                      fontWeight: FontWeight.bold,
                      color: AppColors.getReversedTextColor(context),
                    ),
                  ),
                  const Sizer(),
                  Icon(
                    Icons.shopping_cart_rounded,
                    color: AppColors.getReversedTextColor(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
