import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/thumbnails/thumbnails_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/ride_thumbnail_entity.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/dynamic/google_ads_banner.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/dynamic/wallet_widget.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../core/enums/ride_services_enum.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../widgets/announce_widget.dart';

class FourtyNineView extends StatefulWidget {
  const FourtyNineView({super.key});

  @override
  State<FourtyNineView> createState() => _FourtyNineViewState();
}

class _FourtyNineViewState extends State<FourtyNineView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(
        isWithBackArrow: false,
      ),
      bottomNavigationBar: const BottomNavigator(
        mainCategory: 1,
        index: 2,
      ),
      floatingActionButton: const FloatingButton(
        changeView: 1,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: const DrawerWidget(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const AnnounceWidget(),
          const WalletWidget(),
          const Sizer(),
          const GoogleAddsBanner(),
          const Sizer(),
          _buildMazadatWidget(),
          const Sizer(),
          _buildMainCategoriesViews(),
          const Sizer(),
          BlocBuilder<MainCategoriesCubit, BasicState<List<MainCategoryEntity>>>(
            builder: (context, state) {
              if (state.isSuccess && state.data != null) {
                return ListView.separated(
                  itemCount: state.data?.length ?? 0,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        context.push(Routes.SUBCATEGORIES, extra: state.data![index]);
                      },
                      child: MainCategoryBanner(category: state.data![index]),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Sizer(),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainCategoriesViews() {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildItemTabBar(
              SvgPicture.asset(
                Assets.threeDots,
                height: 20,
                width: 20,
              ),
              Routes.MAINCATEGORIESTREE,
            ),
            _buildItemTabBar(
              SvgPicture.asset(
                Assets.mobile,
                height: 20,
                width: 20,
              ),
              Routes.MAINCATEGORIESCARDS,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTabBar(
    Widget icon,
    String routeName,
  ) {
    return InkWell(
      onTap: () => context.push(routeName),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
        decoration: const BoxDecoration(),
        child: icon,
      ),
    );
  }

  Widget _buildMazadatWidget() {
    return Column(
      children: [
        BlocBuilder<ThumbnailsCubit, BasicState<List<RideThumbnailEntity>>>(
          builder: (context, state) {
            if (state.status == StateStatus.success && state.data != null && state.data!.isNotEmpty) {
              return Row(
                children: [
                  Expanded(
                    child: _buildRideSubCategoryItem(
                      service: state.data![0].service,
                      image: state.data![0].image,
                      // route: Routes.TRIP_JOIN,
                    ),
                  ),
                  const Sizer(),
                  Expanded(
                    child: _buildRideSubCategoryItem(
                      service: state.data![1].service,
                      image: state.data![1].image,
                      route: Routes.TRIP_JOIN,
                    ),
                  )
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        const Sizer(),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => context.go(Routes.MAZADAT),
                child: SizedBox(
                  height: kToolbarHeight * .5,
                  width: kToolbarHeight * 2,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: AppButton(
                            color: Colors.white,
                            label: 'Auction',
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                            icon: Icons.group,
                            iconSize: 22,
                            onPressed: () => context.push(Routes.MAZADAT)),
                      ),
                      const Positioned(
                          bottom: 5,
                          left: 5,
                          child: Icon(
                            Icons.star,
                            size: 10,
                            color: AppColors.ACCENT_COLOR,
                          )),
                      const Positioned(
                          top: 0,
                          left: 10,
                          child: Icon(
                            Icons.star,
                            size: 10,
                            color: AppColors.ACCENT_COLOR,
                          )),
                      const Positioned(
                          top: 15,
                          right: 10,
                          child: Icon(
                            Icons.star,
                            size: 10,
                            color: AppColors.ACCENT_COLOR,
                          ))
                    ],
                  ),
                ),
              ),
            ),
            const Sizer(),
            Expanded(
              child: AppButton(
                  padding: 5,
                  color: Colors.white,
                  height: kToolbarHeight * .5,
                  label: 'Installments',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                  icon: Icons.list,
                  iconSize: 22,
                  onPressed: () => context.push(Routes.INSTALLMENT)),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildRideSubCategoryItem({
    required RideServicesEnum service,
    required String image,
    String? route,
  }) {
    return InkWell(
      // onTap: () => context.push(Routes.ADS, extra: service.value()),
      onTap: () => route != null ? context.push(route) : null,
      child: Container(
        height: kToolbarHeight * 1.3,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 249, 159, 162),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(1, 1),
            )
          ],
        ),
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SquareImage(
                      fit: BoxFit.cover,
                      url: image,
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.3), // Darken the background
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  Label(
                    text: service.title(),
                    style: Styles.headerText(color: Colors.white),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {},
                        child: const Icon(
                          Icons.favorite_border,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                      ),
                      const Sizer(
                        height: 20,
                      ),
                      Label(
                        text: '1 Ads',
                        style: Styles.mediumText(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
