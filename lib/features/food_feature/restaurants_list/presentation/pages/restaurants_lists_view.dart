import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/banner.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/meal_categories.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/resturant_dashboard_banner.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcatigories_restaurant_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/meal_cubit/restaurants_list_cubit.dart';
import '../widgets/restaurant_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
          ),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEliteBanner(),
              _buildImageSection(screenWidth),
              _buildDetailsSection(),
              const SizedBox(height: 10),
              const PremiumAndRequestButtons(),
              const SizedBox(height: 10),
              const CallMessageReportButtons(),
              const SizedBox(height: 2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEliteBanner() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFD4AF37), // Elite banner color
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      child: const Text(
        'Elite',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildImageSection(double screenWidth) {
    return Stack(
      children: [
        Container(
          height: screenWidth * 0.6, // Responsive image height
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                'https://via.placeholder.com/400', // Replace with your image URL
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Icon(
            Icons.verified,
            color: AppColors.SECONDARY_COLOR,
            size: 50.h,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.favorite_border),
            color: Colors.white,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'مطعم الدهان',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'القاهرة الجديدة, القاهرة',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'منذ 3 ايام',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const Text(
                'لللمندي والمشاوي',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Premium and Request buttons
class PremiumAndRequestButtons extends StatelessWidget {
  const PremiumAndRequestButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildButton(
          label: 'Premium Request',
          color: Colors.red,
          onPressed: () {},
        ),
        const SizedBox(width: 10),
        _buildButton(
          label: 'Request',
          color: Colors.black,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Flexible(
      child: AppButton(
          height: 60.h,
          label: label,
          backColor: color,
          style: Styles.headerText(color: Colors.white),
          onPressed: onPressed),
    );
    //   Expanded(
    //   child: ElevatedButton(
    //     onPressed: onPressed,
    //     style: ElevatedButton.styleFrom(
    //       backgroundColor: color,
    //       padding: const EdgeInsets.symmetric(vertical: 15),
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(8),
    //       ),
    //     ),
    //     child: Text(
    //       label,
    //       style: const TextStyle(color: Colors.white, fontSize: 16),
    //     ),
    //   ),
    // );
  }
}

// Call, Message, and Report buttons
class CallMessageReportButtons extends StatelessWidget {
  const CallMessageReportButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildElevatedButtonWithIcon(
          label: 'Call',
          icon: Icons.call,
          onPressed: () {},
          color: Colors.grey,
        ),
        const SizedBox(width: 10),
        _buildElevatedButtonWithIcon(
          label: 'Message',
          icon: Icons.message,
          onPressed: () {},
          color: Colors.grey,
        ),
        const SizedBox(width: 10),
        _buildElevatedButtonWithIcon(
          label: 'Report',
          icon: Icons.report,
          color: Colors.red,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildElevatedButtonWithIcon({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Flexible(
      child: AppButton(
          height: 60.h,
          label: label,
          icon: icon,
          iconSize: 80.h,
          backColor: color,
          style: Styles.headerText(color: Colors.white),
          onPressed: onPressed),
    );
    //   Expanded(
    //   child: ElevatedButton.icon(
    //     onPressed: onPressed,
    //     icon: Icon(icon, color: Colors.white),
    //     label: Text(
    //       label,
    //       style: const TextStyle(color: Colors.white),
    //     ),
    //     style: ElevatedButton.styleFrom(
    //       backgroundColor: color,
    //       padding: const EdgeInsets.symmetric(vertical: 12),
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(8),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class RestaurantsListsView extends StatelessWidget {
  const RestaurantsListsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => serviceLocator<RestaurantsListCubit>(),
        child: SharedScaffold(
          mainCategoryId: 1,
          body: RefreshIndicator(
            onRefresh: () async =>
                serviceLocator<RestaurantsListCubit>().loadData(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return context.watch<RestaurantsListCubit>().user == null
                      ? Center(
                          child: Label(
                          text: LocaleKeys.needToLogin.tr(),
                        ))
                      : Stack(
                          children: [
                            ListView(
                              children: [
                                const MealBanner(),
                                const PropertyCard(),
                                Visibility(
                                  visible:
                                      state.isResturant?.isRestaurant == false,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (context
                                          .read<UserCubit>()
                                          .isLoggedIn) {
                                        context.push(Routes.CREATERESTURANT);
                                      } else {
                                        context.push(Routes.REGISTER);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Text(
                                        LocaleKeys
                                            .youCanEnjoyServingYourClintsUsingYourRestaurantByClickingOnTheRigesterButtonAbove
                                            .tr(),
                                        style: Styles.mediumText(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Sizer(),
                                Visibility(
                                    visible: (state.isResturant?.isRestaurant ??
                                            false) &&
                                        (state.isResturant?.approved ?? false),
                                    child: const ResturantDashboardButton()),
                                const Sizer(),
                                GestureDetector(
                                  onTap: () {
                                    if (context.read<UserCubit>().isLoggedIn) {
                                      context.push(Routes.SEARCHMEALS);
                                    } else {
                                      context.push(Routes.REGISTER);
                                    }
                                  },
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      height: 36.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: .5, color: Colors.grey),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(LocaleKeys.search.tr()),
                                          const Icon(Icons.search,
                                              color: Colors.grey),
                                        ],
                                      )),
                                ),
                                const Sizer(),
                                if (state.mealCategories?.isNotEmpty ?? false)
                                  const MealCategories(),
                                if (state.loadingSubCategories) ...[
                                  Shimmer.fromColors(
                                      baseColor: Colors.grey[100]!,
                                      highlightColor: Colors.white,
                                      child: Row(
                                        children: List.generate(
                                          2,
                                          (index) => Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ))
                                ],
                                if ((state.subCategories?.isNotEmpty ??
                                        false) &&
                                    state.isSuccess) ...[
                                  Label(
                                    text: LocaleKeys.restaurantsForSelectedMeal
                                        .tr(),
                                    style: Styles.headerText(),
                                  ),
                                  const Sizer(),
                                  _buildSubCatigoriesRestaurants(),
                                ],
                                const Sizer(),
                                const Sizer(),
                                if ((state.allRestaurant?.isNotEmpty ??
                                    false)) ...[
                                  Label(
                                      text: LocaleKeys.allRestaurants.tr(),
                                      style: Styles.headerText()),
                                  const Sizer(),
                                  _buildAllRestaurants(),
                                ],
                              ],
                            ),

                            /// numOfRestaurants
                            if (state.numOfRestaurants != null)
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: FloatingActionButton(
                                  tooltip: LocaleKeys.restaurants.tr(),
                                  backgroundColor: AppColors.PRIMARY_COLOR,
                                  onPressed: () {},
                                  child: Text(
                                    "${state.numOfRestaurants}",
                                    style: Styles.mediumText(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                          ],
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubCatigoriesRestaurants() {
    return BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
        builder: (context, state) {
      return SizedBox(
          height: kToolbarHeight * 3.15,
          child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => SubCatigoriesRestaurantCard(
                  item: state.subCategories?[index]),
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: state.subCategories?.length ?? 0));
    });
  }

  Widget _buildAllRestaurants() {
    return BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
        builder: (context, state) {
      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => RestaurantCard(
                isVert: false,
                item: state.allRestaurant![index],
              ),
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: state.allRestaurant?.length ?? 0);
    });
  }
}
