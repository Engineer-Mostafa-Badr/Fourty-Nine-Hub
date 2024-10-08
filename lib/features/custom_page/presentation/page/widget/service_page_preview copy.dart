import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/slider_cubit.dart/slider_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/thumbnails/thumbnails_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/firebase_notfications_cubit/firebase_notfications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_socket_io/notification_socket_io_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/ride_thumbnail_entity.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/dynamic/wallet_widget.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/ride_services_enum.dart';
import '../../../../../core/loading/custom_loading.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../fourty_nine/domain/entities/slider_item_entity.dart';
import '../../cubit/custom_page_cubit.dart';
import '../../cubit/custom_page_states.dart';
import 'custom_page_botton_nav_bar.dart';

class ServicePagePreview extends StatefulWidget {
  const ServicePagePreview({super.key});

  @override
  State<ServicePagePreview> createState() => _ServicePagePreviewState();
}

class _ServicePagePreviewState extends State<ServicePagePreview> {
  ScrollController scrollController = ScrollController();
  bool _isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _setupScrollController();
    context
        .read<FirebaseNotficationsCubit>()
        .setupInterceptedMessage(context: context);
    context
        .read<NotificationSocketIoCubit>()
        .notificationListener(languageCode: 'en');
  }

  void _setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!_isScrollingDown) {
          setState(() {
            _isScrollingDown = true;
          });
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isScrollingDown) {
          setState(() {
            _isScrollingDown = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => serviceLocator<SliderCubit>(),
        ),
        BlocProvider(
          create: (BuildContext context) => serviceLocator<ThumbnailsCubit>(),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              serviceLocator<CustomPageCubit>()..fetchSubTab(),
        )
      ],
      child: BlocBuilder<SliderCubit, BasicState<List<SliderItemEntity>>>(
        builder: (BuildContext context, state) {
          return BlocBuilder<ThumbnailsCubit,
              BasicState<List<RideThumbnailEntity>>>(
            builder: (BuildContext context,
                BasicState<List<RideThumbnailEntity>> state) {
              return Scaffold(
                bottomNavigationBar: CustomPageBottonNavBar(
                  scrollController: scrollController, currentIndex: 2,
                  isScrollingDown: _isScrollingDown,
                  // mainCategory: 1,
                  // index: 2,
                ),
                body: BlocBuilder<CustomPageCubit, CustomPageState>(
                  builder: (BuildContext context, subTab) {
                    if (subTab.status == CustomPageStates.success) {
                      return ListView(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        children: [
                          const Sizer(),
                          //carousel slider
                          !context.read<UserCubit>().isLoggedIn
                              ? const Sizer()
                              : const SizedBox.shrink(),
                          //wallet
                          context.read<UserCubit>().isLoggedIn
                              ? const WalletWidget()
                              : const SizedBox.shrink(),
                          //    Sizer(),
                          //admob
                          //   const GoogleAddsBanner(),
                          //  Sizer(),
                          //pick me and come with U
                          _pickMeAndComeWithUWidget(subTab),
                          if (subTab.subTab?.carpool == true ||
                              subTab.subTab?.tripJoin == true)
                            const Sizer(),
                          //auction
                          _auctionAndInstallmentWidget(subTab),
                          if (subTab.subTab?.auction == true ||
                              subTab.subTab?.installment == true)
                            const Sizer(),
                          //cats layout
                          _buildMainCategoriesViews(),
                          const Sizer(),
                          //main cats
                          BlocBuilder<MainCategoriesCubit, MainCategoriesState>(
                            builder: (context, state) {
                              final controller =
                                  context.read<MainCategoriesCubit>();
                              if (state.status == StateStatus.loading) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[100]!,
                                  highlightColor: Colors.white24,
                                  child: Column(
                                    children: List.generate(
                                        6,
                                        (index) => Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 15.h),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .15.h,
                                                width: double.infinity,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10.w),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w),
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .AUTH_CONTAINER_COLOR,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.r),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            )),
                                  ),
                                );
                              }
                              if (state.status == StateStatus.success &&
                                  state.data != null) {
                                return ListView.separated(
                                  itemCount: state.data?.length ?? 0,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        context.push(Routes.SUBCATEGORIES,
                                            extra: state.data![index]);
                                      },
                                      child: MainCategoryBanner(
                                        category: state.data![index],
                                        onFavorite: () async {
                                          var result = await controller
                                              .toggleFavoriteMedicalService(
                                                  state.data![index].id);
                                          print("result$result");
                                          return result;
                                        },
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Sizer(),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ],
                      );
                    } else {
                      return const CustomLoading();
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMainCategoriesViews() {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: const [
            BoxShadow(
              color: AppColors.GRAY_LIGHT_COLOR3,
              blurRadius: 5,
              spreadRadius: 5,
            )
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildItemTabBar(
              SvgPicture.asset(
                Assets.threeDots,
                height: 34.h,
                width: 34.h,
              ),
              Routes.MAINCATEGORIESTREE,
            ),
            _buildItemTabBar(
              SvgPicture.asset(
                Assets.mobile,
                height: 34.h,
                width: 34.h,
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
        padding: EdgeInsets.symmetric(vertical: 6.h.w, horizontal: 10.h),
        decoration: const BoxDecoration(),
        child: icon,
      ),
    );
  }

  BlocBuilder<ThumbnailsCubit, BasicState<List<RideThumbnailEntity>>>
      _pickMeAndComeWithUWidget(subTab) {
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
                          width: 100.h,
                          height: kToolbarHeight * 2.h,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: AppColors.AUTH_CONTAINER_COLOR,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                      ),
                    )),
          );
        } else if (state.status == StateStatus.success) {
          return Row(
            children: [
              subTab.subTab?.carpool == true
                  ? Expanded(
                      child: _buildRideSubCategoryItem(
                        service: state.data![0].service,
                        image: state.data![0].image,
                      ),
                    )
                  : const SizedBox.shrink(),
              const Sizer(),
              subTab.subTab?.tripJoin == true
                  ? Expanded(
                      child: _buildRideSubCategoryItem(
                        service: state.data![1].service,
                        image: state.data![1].image,
                        route: Routes.AVAILABLE_TRIPS,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          );
        } else {
          return Container(
            padding:
                //EdgeInsets.all
                const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              LocaleKeys.noRideSubcategories.localize,
              style: TextStyle(fontSize: 32.sp.w, fontWeight: FontWeight.w500),
            ),
          );
        }
      },
    );
  }

  Row _auctionAndInstallmentWidget(subTab) {
    return Row(
      children: [
        subTab.subTab?.auction == true
            ? itemAuctionAndInstallmentWidget(LocaleKeys.auction.localize,
                () => context.push(Routes.MAZADAT), Icons.group)
            : const SizedBox.shrink(),
        const Sizer(),
        subTab.subTab?.installment == true
            ? itemAuctionAndInstallmentWidget(LocaleKeys.installments.localize,
                () => context.push(Routes.INSTALLMENT), Icons.list)
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget itemAuctionAndInstallmentWidget(
      String label, Function function, IconData icon) {
    return Expanded(
      child: InkWell(
        onTap: () => context.go(Routes.MAZADAT),
        child: SizedBox(
          height: kToolbarHeight * .9.h,
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
                    iconSize: 50.h,
                    onPressed: () => function()),
              ),
              Positioned(
                  bottom: 5,
                  left: 5,
                  child: Icon(
                    Icons.star,
                    size: 20.h,
                    color: AppColors.ACCENT_COLOR,
                  )),
              Positioned(
                  top: 0,
                  left: 10,
                  child: Icon(
                    Icons.star,
                    size: 20.h,
                    color: AppColors.ACCENT_COLOR,
                  )),
              Positioned(
                  top: 15,
                  right: 10,
                  child: Icon(
                    Icons.star,
                    size: 20.h,
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
        height: kToolbarHeight * 2.h,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10.r),
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
                borderRadius: BorderRadius.circular(10.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SquareImage(
                      fit: BoxFit.cover,
                      url: image,
                    ),
                    Container(
                      color: Colors.black
                          .withOpacity(0.3), // Darken the background
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  Label(
                    text: service.title(),
                    style: Styles.mediumText(
                      color: AppColors.AUTH_CONTAINER_COLOR,
                      fontSize: 65.sp,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {},
                          child: Icon(
                            Icons.favorite_border,
                            color: AppColors.SECONDARY_COLOR,
                            size: 38.h,
                          ),
                        ),
                        const Spacer(),
                        Label(
                          text: '4 ${LocaleKeys.ads.tr()}',
                          style: Styles.mediumText(
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
