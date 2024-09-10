import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/thumbnails/thumbnails_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/firebase_notfications_cubit/firebase_notfications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_socket_io/notification_socket_io_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_snackbar.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/ride_thumbnail_entity.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/src/components/screen_util/core/size_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/dynamic/wallet_widget.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../core/enums/ride_services_enum.dart';
import '../../../../core/localization/locale_keys.g.dart';
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
  ScrollController scrollController = ScrollController();
  bool _isScrollingDown = false;

  @override
  void initState() {
    scrollController;
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!_isScrollingDown) {
          setState(() {
            _isScrollingDown = true;
          });
        }
      } else {
        if (_isScrollingDown) {
          setState(() {
            _isScrollingDown = false;
          });
        }
      }
    });
    context.read<FirebaseNotficationsCubit>().setupInterceptedMessage(context: context);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationSocketIoCubit, NotificationSocketIoState>(
      listener: (context, state) {
        if (state is NotificationSocketIoNewNotification) {
          // pr('new notfication is recieved by the bloc listner');
          // pr(state.notificationEntity);
          notificationSnackBar(
            context: context,
            notificationEntity: state.notificationEntity,
          );
        } else if (state is NotificationSocketIoFailed) {
          // pr('Failed to recieve the new notfication ');
          // pr(state.message);
        }
      },
      child: Scaffold(
        appBar: const HomeAppbar(
          isWithBackArrow: false,
          language: true,
        ),
        bottomNavigationBar: BottomNavigator(
          scrollController: scrollController,
          isScrollingDown: _isScrollingDown,
          mainCategory: 1,
          index: 2,
        ),
        floatingActionButton: _isScrollingDown
            ? null
            : const FloatingButton(
                changeView: 1,
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        drawer: const DrawerWidget(),
        body: ListView(
          controller: scrollController,
          padding: EdgeInsets.symmetric(horizontal: 20.zW),
          children: [
            //carousel slider
            const AnnounceWidget(),
            // const Sizer(),
            //wallet
            const WalletWidget(),
            //    const Sizer(),
            //admob
            //   const GoogleAddsBanner(),
            //  const Sizer(),
            //pick me and come with U
            _pickMeAndComeWithUWidget(),
            const Sizer(),
            //auction
            _auctionAndInstallmentWidget(),
            const Sizer(),
            //cats layout
            _buildMainCategoriesViews(),
            const Sizer(),
            //main cats
            BlocBuilder<MainCategoriesCubit, BasicState<List<MainCategoryEntity>>>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[100]!,
                    highlightColor: Colors.white24,
                    child: Column(
                      children: List.generate(
                          6,
                          (index) => Padding(
                                padding: EdgeInsets.only(bottom: 15.zH),
                                child: Container(
                                  height: MediaQuery.of(context).size.height * .15.zH,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 10.zW),
                                  padding: EdgeInsets.symmetric(horizontal: 10.zW),
                                  decoration: BoxDecoration(
                                    color: AppColors.AUTH_CONTAINER_COLOR,
                                    borderRadius: BorderRadius.circular(20.zR),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                ),
                              )),
                    ),
                  );
                }
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
                        child: MainCategoryBanner(
                          category: state.data![index],
                          onFavorite: () {},
                        ),
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
      ),
    );
  }

  Widget _buildMainCategoriesViews() {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20.zR),
          boxShadow: const [
            BoxShadow(
              color: AppColors.GRAY_LIGHT_COLOR3,
              blurRadius: 5,
              spreadRadius: 5,
            )
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.zR),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildItemTabBar(
              SvgPicture.asset(
                Assets.threeDots,
                height: 34.zH,
                width: 34.zW,
              ),
              Routes.MAINCATEGORIESTREE,
            ),
            _buildItemTabBar(
              SvgPicture.asset(
                Assets.mobile,
                height: 34.zH,
                width: 34.zW,
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
        padding: EdgeInsets.symmetric(vertical: 6.zW, horizontal: 10.zH),
        decoration: const BoxDecoration(),
        child: icon,
      ),
    );
  }

  BlocBuilder<ThumbnailsCubit, BasicState<List<RideThumbnailEntity>>> _pickMeAndComeWithUWidget() {
    return BlocBuilder<ThumbnailsCubit, BasicState<List<RideThumbnailEntity>>>(
      builder: (context, state) {
        if (state.status == StateStatus.loading) {
          return Row(
            children: List.generate(
                2,
                (index) => Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[100]!,
                        highlightColor: Colors.white24,
                        child: Container(
                          width: 100.zW,
                          height: kToolbarHeight * 2.zH,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: AppColors.AUTH_CONTAINER_COLOR,
                            borderRadius: BorderRadius.circular(20.zR),
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                      ),
                    )),
          );
        } else if (state.status == StateStatus.success) {
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
                  route: Routes.AVAILABLE_TRIPS,
                ),
              )
            ],
          );
        } else {
          return Container(
            padding:
                //EdgeInsets.all
                const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              LocaleKeys.noRideSubcategories.localize,
              style: TextStyle(fontSize: 32.zW, fontWeight: FontWeight.w500),
            ),
          );
        }
      },
    );
  }

  Row _auctionAndInstallmentWidget() {
    return Row(
      children: [
        itemAuctionAndInstallmentWidget(LocaleKeys.auction.localize, () => context.push(Routes.MAZADAT), Icons.group),
        const Sizer(),
        itemAuctionAndInstallmentWidget(
            LocaleKeys.installments.localize, () => context.push(Routes.INSTALLMENT), Icons.list),
      ],
    );
  }

  Widget itemAuctionAndInstallmentWidget(String label, Function function, IconData icon) {
    return Expanded(
      child: InkWell(
        onTap: () => context.go(Routes.MAZADAT),
        child: SizedBox(
          height: kToolbarHeight * .8.zH,
          child: Stack(
            children: [
              Positioned.fill(
                child: AppButton(
                    color: AppColors.AUTH_CONTAINER_COLOR,
                    label: label,
                    style: Styles.mediumText(
                      color: AppColors.AUTH_CONTAINER_COLOR,
                      fontWeight: FontWeight.bold,
                    ),
                    icon: icon,
                    iconSize: 30.zH,
                    onPressed: () => function()),
              ),
              Positioned(
                  bottom: 5,
                  left: 5,
                  child: Icon(
                    Icons.star,
                    size: 20.zH,
                    color: AppColors.ACCENT_COLOR,
                  )),
              Positioned(
                  top: 0,
                  left: 10,
                  child: Icon(
                    Icons.star,
                    size: 20.zH,
                    color: AppColors.ACCENT_COLOR,
                  )),
              Positioned(
                  top: 15,
                  right: 10,
                  child: Icon(
                    Icons.star,
                    size: 20.zH,
                    color: AppColors.ACCENT_COLOR,
                  ))
            ],
          ),
        ),
      ),
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
        height: kToolbarHeight * 2.zH,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10.zR),
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
                borderRadius: BorderRadius.circular(10.zR),
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
                    style: Styles.mediumText(
                      color: AppColors.AUTH_CONTAINER_COLOR,
                      fontSize: 34,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {},
                          child: Icon(
                            Icons.favorite_border,
                            color: AppColors.SECONDARY_COLOR,
                            size: 38.zH,
                          ),
                        ),
                        const Spacer(),
                        Label(
                          text: '4 ${LocaleKeys.ads.tr()}',
                          style: Styles.smallText(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
