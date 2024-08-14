import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/list_view_pagination.dart';

import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';

import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/parent_main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/thumbnails/thumbnails_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/ride_thumbnail_entity.dart';

import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/dynamic/google_ads_banner.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';

import '../../../../core/enums/ride_services_enum.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/dynamic/wallet_widget.dart';
import '../../../../res/style/app_colors.dart';

import '../widgets/ads_text_banner.dart';
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
      appBar:  const HomeAppbar(
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
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AnnounceWidget(),
                  const AdsTextBanner(),
                  const WalletWidget(),
                  const GoogleAddsBanner(),
                  const Sizer(),
                  _buildMazadatWidget(),
                  const Sizer(),
                   SizedBox(
                    height: 500,
                    child: PaginationView<MainCategoryEntity>(
                      build: (ScrollController scrollController,
                          List<MainCategoryEntity> data) {
                        return ListView.separated(
                          itemCount: data.length,
                          shrinkWrap: true,
                          controller: scrollController,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                context.push(Routes.SUBCATEGORIES,
                                    extra: data[index]);
                              },
                              child: MainCategoryBanner(category: data[index]),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Sizer(),
                        );
                      },
                      fetchData: (PaginationParams paginationParams) => context
                          .read<MainCategoriesCubit>()
                          .getMainCategories(paginationParams),
                    ),
                  ),
                ]),
          )),
    );
  }

  Widget _buildMazadatWidget() {
    return Column(
      children: [
        BlocBuilder<ThumbnailsCubit, BasicState<List<RideThumbnailEntity>>>(
          builder: (context, state) {
            if (state.status == StateStatus.success &&
                state.data != null &&
                state.data!.isNotEmpty) {
              return Row(
                children: [
                  Expanded(
                    child: _buildRideSubCategoryItem(
                      service: state.data![0].service,
                      image: state.data![0].image,
                    ),
                  ),
                  const Sizer(),
                  Expanded(
                    child: _buildRideSubCategoryItem(
                      service: state.data![1].service,
                      image: state.data![1].image,
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
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
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
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
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
  }) {
    return InkWell(
      onTap: () => context.push(Routes.ADS, extra: service.value()),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 5
              ),
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