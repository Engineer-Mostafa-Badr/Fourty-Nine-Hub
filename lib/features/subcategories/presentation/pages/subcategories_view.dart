import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../common/models/public/pagination_params.dart';
import '../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../common/widgets/stateful/dynamic/pagination_view.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/widget/custom_notification_badge.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../../service_locator/service_locator.dart';
import '../../../ads_feature/ads/presentation/cubit/ads_cubit.dart';
import '../../../ads_feature/ads/presentation/widgets/header_button_widget.dart';
import '../../../ads_feature/create_ad/domain/entities/categorization_entity.dart';
import '../../../fourty_nine/domain/entities/main_category_entity.dart';
import '../../domain/entities/sub_category_entity.dart';
import '../cubit/subcategories_cubit.dart';
import '../widgets/floating_add_button.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/subcategory_card.dart';
import 'ads_request_log_view.dart';
import 'ads_search_view.dart';
import 'favourite_ads_view.dart';
import 'my_ads_view.dart';

class SubCategoriesView extends StatefulWidget {
  final MainCategoryEntity mainCategory;

  const SubCategoriesView({super.key, required this.mainCategory});

  @override
  State<SubCategoriesView> createState() => _SubCategoriesViewState();
}

class _SubCategoriesViewState extends State<SubCategoriesView> {
  late ScrollController scrollController;
  bool isFloatingButtonVisible = true;

  // bool isSearchOpen = false;

  late Debouncer _debounce;

  final FocusNode focusNode = FocusNode();

  List<SubCategoryEntity> subCategories = [];

  String? selectedValue;

  // void _showDropdownMenu(BuildContext context) async {
  //   if (subCategories.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('No subcategories available')),
  //     );
  //     return;
  //   }
  //   final RenderBox button = context.findRenderObject() as RenderBox;
  //   final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  //   final RelativeRect position = RelativeRect.fromLTRB(
  //     overlay.size.width - 20,
  //     overlay.size.height - 250,
  //     200,
  //     100,
  //   );
  //
  //   final String? selected = await showMenu<String>(
  //     color: Colors.white,
  //     menuPadding: const EdgeInsets.all(10),
  //      shadowColor: Colors.grey.shade300,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     context: context,
  //     position: position,
  //     items: subCategories.map((SubCategoryEntity item) {
  //       return PopupMenuItem<String>(
  //         value: item.id,
  //         child: Row(
  //           children: [
  //             Label(text: item.nameAr  ?? '', style: Styles.mediumText())
  //
  //           ],
  //         ),
  //       );
  //     }).toList(),
  //   );
  //
  //   if (selected != null) {
  //     setState(() {
  //       selectedValue = selected;
  //     });
  //   }
  //   print(selectedValue.toString());
  // }
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      enableCustomAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: context.isArabic
              ? widget.mainCategory.name
              : widget.mainCategory.nameEn,
          textColor: Colors.white,
          iconColor: Colors.white,
          enableCustomAppBar: true,
        ),
      ),
      body: BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
        builder: (context, state) {
          final controller = context.read<SubcategoriesCubit>();

          return Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        ManageVibration.vibrate();
                        context
                            .read<SubcategoriesCubit>()
                            .toggleMyAds('isSearchAdsOpen');
                        // setState(() {
                        //   isSearchOpen = !isSearchOpen;
                        // });
                      },
                      icon: SvgPicture.asset(
                        Assets.searchIcon,
                        colorFilter: ColorFilter.mode(
                          context.read<SubcategoriesCubit>().isSearchAdsOpen
                              ? const Color(0xffF33D49)
                              : AppColors.getButtonPrimaryWhiteColor(context),
                          BlendMode.srcIn,
                        ),
                        // color: context.isDarkMode ? Colors.white : null,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: CustomNotificationBadge(
                        count: 0,
                        child: HeaderButtonWidget(
                          title: context.isArabic?'Favourites':'المفضلة',
                          isOpened: context
                              .read<SubcategoriesCubit>()
                              .isFavouriteAdsOpen,
                          onPressed: () async {
                            ManageVibration.vibrate();
                            if (!context.isUserLoggedIn) {
                              return pleaseLoginDialog(context);
                            } else {
                              await context
                                  .read<SubcategoriesCubit>()
                                  .loadMyFavouriteAds(
                                      id: widget.mainCategory.id);
                              context
                                  .read<SubcategoriesCubit>()
                                  .toggleMyAds('isFavouriteAdsOpen');
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: CustomNotificationBadge(
                        count: 0,
                        child: HeaderButtonWidget(
                          title: LocaleKeys.requestLog.localize,
                          isOpened: context
                              .read<SubcategoriesCubit>()
                              .isRequestLogOpen,
                          onPressed: () async {
                            ManageVibration.vibrate();

                            if (!context.isUserLoggedIn) {
                              return pleaseLoginDialog(context);
                            }

                            try {
                              await context
                                  .read<SubcategoriesCubit>()
                                  .loadRequestsLogByMainCategory(
                                      mainCategoryId: widget.mainCategory.id);

                              context
                                  .read<SubcategoriesCubit>()
                                  .toggleMyAds('isRequestLogOpen');
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('خطأ في تحميل البيانات: $error')),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: HeaderButtonWidget(
                        title: LocaleKeys.myAds.localize,
                        isOpened:
                            context.read<SubcategoriesCubit>().isMyAdsOpen,
                        onPressed: () {
                          ManageVibration.vibrate();
                          // TODO: EDIT THIS
                          if (!context.isUserLoggedIn) {
                            return pleaseLoginDialog(context);
                          } else {
                            context
                                .read<SubcategoriesCubit>()
                                .loadMyAds(id: widget.mainCategory.id);
                            context
                                .read<SubcategoriesCubit>()
                                .toggleMyAds('isMyAdsOpen');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              if (context.read<SubcategoriesCubit>().isSearchAdsOpen)
                SearchBarWidget(
                  onChanged: (value) {
                    _debounce.run(() {
                      context.read<SubcategoriesCubit>().searchAds(
                            value: value,
                            mainCategoryId: widget.mainCategory.id,
                          );
                    });
                  },
                  focusNode: focusNode,
                ),
              if (context.read<SubcategoriesCubit>().isFavouriteAdsOpen)
                Expanded(
                    child: BlocProvider(
                  create: (context) => serviceLocator<AdvertisementCubit>(),
                  child: FavouriteAdsView(
                    id: widget.mainCategory.id,
                    isFloatingButtonVisible: (value) {
                      isFloatingButtonVisible = value;
                      setState(() {});
                    },
                  ),
                )),
              if (context.read<SubcategoriesCubit>().isRequestLogOpen)
                Expanded(
                    child: AdsRequestLogView(
                        mainCategoryId: widget.mainCategory.id,
                        isFloatingButtonVisible: (value) {
                          isFloatingButtonVisible = value;
                          setState(() {});
                        })),
              if (context.read<SubcategoriesCubit>().isMyAdsOpen)
                Expanded(
                    child: BlocProvider(
                  create: (context) => serviceLocator<AdvertisementCubit>(),
                  child: MyAdsView(
                    id: widget.mainCategory.id,
                    isFloatingButtonVisible: (value) {
                      isFloatingButtonVisible = value;
                      setState(() {});
                    },
                  ),
                )),
              if (context.read<SubcategoriesCubit>().isSearchAdsOpen)
                //kslkfjslkfjslkfsldfkjlsfld
                Expanded(
                  child: BlocProvider(
                    create: (context) => serviceLocator<AdvertisementCubit>(),
                    child: AdsSearchView(
                      mainCategoryNameAr: widget.mainCategory.name ?? 'N/A',
                      mainCategoryNameEn: widget.mainCategory.nameEn ?? 'N/A',
                      isFloatingButtonVisible: (value) {
                        isFloatingButtonVisible = value;
                        setState(() {});
                      },
                    ),
                  ),
                ),
              if (!context.read<SubcategoriesCubit>().isMyAdsOpen &&
                  !context.read<SubcategoriesCubit>().isFavouriteAdsOpen &&
                  !context.read<SubcategoriesCubit>().isRequestLogOpen &&
                  !context.read<SubcategoriesCubit>().isSearchAdsOpen)
                Expanded(
                  child: PaginationView<SubCategoryEntity>(
                    build: (ScrollController scrollController,
                        List<SubCategoryEntity> data) {
                      print("data.length ${data.length}");
                      return GlowingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        color: AppColors.SECONDARY_COLOR,
                        child: GridView.builder(
                          padding: EdgeInsets.all(24.w),
                          itemCount: data.length,
                          controller: this.scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: .65,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                          itemBuilder: (context, index) => SubCategoryCard(
                            mainCategory: widget.mainCategory,
                            item: data[index],
                            onFav: () async {
                              var result = await controller
                                  .toggleSubCategoryToFavorites(data[index].id);
                              return result;
                            },
                          ),
                        ),
                      );
                    },
                    fetchData: (PaginationParams paginationParams) => context
                        .read<SubcategoriesCubit>()
                        .getSubcategories(
                            paginationParams:
                                PaginationParams(limit: 200, page: 1)),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: isFloatingButtonVisible
          ? buildFloatingAction(context, () {
              _showDropdownMenu(context);
            })
          : null,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
    _debounce = Debouncer();
    context
        .read<SubcategoriesCubit>()
        .init(mainCategoryId: widget.mainCategory.id);
    _fetchSubcategories();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        isFloatingButtonVisible = false;
      } else {
        isFloatingButtonVisible = true;
      }
      setState(() {});
    });
    super.initState();
  }

  void _fetchSubcategories() async {
    final subCategoriesList =
        await context.read<SubcategoriesCubit>().getSubcategories(
              paginationParams: PaginationParams(page: 1, limit: 200),
            );
    setState(() {
      subCategories = subCategoriesList;
    });
  }

  void _showDropdownMenu(BuildContext context) async {
    if (subCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No subcategories available')),
      );
      return;
    }
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final double bottomPadding =
        MediaQuery.of(context).viewInsets.bottom + 200.0;

    final RelativeRect position = RelativeRect.fromLTRB(
      overlay.size.width - 300,
      overlay.size.height - 300,
      50,
      bottomPadding,
    );

    final String? selected = await showMenu<String>(
        color: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
        menuPadding: EdgeInsets.zero,
        shadowColor: Colors.grey.shade300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        position: position,
        items: [
          PopupMenuItem<String>(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 600,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: subCategories.map((SubCategoryEntity item) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          dense: true,
                          title: Label(
                              text:
                                  context.isArabic ? item.nameAr : item.nameEn,
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.bold)),
                          onTap: () {
                            ManageVibration.vibrate();
                            if (context.isUserLoggedIn) {
                              Navigator.pop(context);
                              context.push(Routes.CREATEAD,
                                  extra: CategorizationEntity(
                                      mainCategory: widget.mainCategory,
                                      subCategory: item));
                            } else {
                              return pleaseLoginDialog(context);

                              // context.push(Routes.LOGIN);
                            }
                          },
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade300,
                        )
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ]);

    if (selected != null) {
      setState(() {
        selectedValue = selected;
      });
    }
    print(selectedValue.toString());
  }
}
