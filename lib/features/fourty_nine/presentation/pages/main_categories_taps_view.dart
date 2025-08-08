import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/ads/interstitial_ad_model.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_taps_cubit/main_categories_taps_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/ads_search_view.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/widget/custom_notification_badge.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/assets/assets.dart';
import '../../../../service_locator/service_locator.dart';
import '../../../ads_feature/ads/presentation/cubit/ads_cubit.dart';
import '../../../ads_feature/ads/presentation/pages/marriage_ads_view.dart';
import '../../../ads_feature/ads/presentation/widgets/header_button_widget.dart';
import '../../../ads_feature/create_ad/domain/entities/categorization_entity.dart';
import '../../../subcategories/domain/entities/sub_category_entity.dart';
import '../../../subcategories/presentation/cubit/subcategories_cubit.dart';
import '../../../subcategories/presentation/pages/ads_request_log_view.dart';
import '../../../subcategories/presentation/pages/custom_page_sub_categories_view.dart';
import '../../../subcategories/presentation/pages/favourite_ads_view.dart';
import '../../../subcategories/presentation/pages/my_ads_view.dart';
import '../../../subcategories/presentation/widgets/floating_add_button.dart';
import '../../../subcategories/presentation/widgets/search_bar_widget.dart';

class MainCategoriesGridView extends StatefulWidget {
  const MainCategoriesGridView({super.key, this.isAppBarShow = true});

  final bool isAppBarShow;

  @override
  State<MainCategoriesGridView> createState() => _MainCategoriesGridViewState();
}

class _MainCategoriesGridViewState extends State<MainCategoriesGridView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  String labelName = "";
  bool isFloatingButtonVisible = true;
  late Debouncer _debounce;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    _debounce = Debouncer();
    // context.read<MainCategoriesTapsCubit>().selectMainCategory(0);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
    _tabController = TabController(
        length: context.read<MainCategoriesTapsCubit>().mainCategories.length,
        vsync: this);
    _scrollController = ScrollController();
    // _fetchSubcategories(mainCategoryId: context.read<MainCategoriesTapsCubit>().mainCategories.first.id);
    // Listen for tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _scrollToSelectedTab(_tabController.index);
      }
      _scrollController.addListener(() {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          isFloatingButtonVisible = false;
        } else {
          isFloatingButtonVisible = true;

        }
        setState(() {});
      });
    });
    // _fetchSubcategories(
    //   stateSubCategories: [],
    // );
    context.read<MainCategoriesTapsCubit>().scrollController.addListener(() {
      if (context.read<MainCategoriesTapsCubit>().scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        isFloatingButtonVisible = false;
      } else {
        isFloatingButtonVisible = true;

      }
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelName = context.isArabic
        ? context
            .read<MainCategoriesTapsCubit>()
            .mainCategories[0]
            .name
            .toString()
        : context
            .read<MainCategoriesTapsCubit>()
            .mainCategories[0]
            .nameEn
            .toString();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // Scroll to the selected tab and make it the first tab in view
  void _scrollToSelectedTab(int index) {
    // Assuming each tab has a width of 140.w
    double tabWidth = 235.w;
    double targetScrollPosition = index * tabWidth;
    _scrollController.animateTo(
      targetScrollPosition,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  // List<SubCategoryEntity> subCategories = [];
  String? selectedValue;

// TODO: Handel Pagination
//   void _fetchSubcategories({
//     List<SubCategoryEntity>? stateSubCategories,
//   }) async {
//     // if (stateSubCategories!.isEmpty) {
//     //  await context.read<MainCategoriesTapsCubit>().loadData();
//     // }
//     final subCategoriesList = stateSubCategories ?? [];
//     // print(
//     //     'subCategories==> ${context.read<MainCategoriesTapsCubit>().subCategories.length}');
//     // print(
//     //     'state.subCategories==> ${context.read<MainCategoriesTapsCubit>().state.subCategories?.length}');
//
//     setState(() {
//       subCategories = subCategoriesList;
//       // subCategories = stateSubCategories ?? [];
//     });
//     print(subCategoriesList);
//     // if (stateSubCategories!.isEmpty) {
//     //   // await context.read<MainCategoriesTapsCubit>().loadData('_fetchSubcategories');
//     //   // subCategoriesList.addAll(
//     //   //   context.read<MainCategoriesTapsCubit>().subCategories,
//     //   // );
//     //   print(
//     //       'stateSubCategories!.isEmpty==> ${context.read<MainCategoriesTapsCubit>().subCategories.length}');
//     // }
//   }

  void _showDropdownMenu(
      BuildContext context, List<SubCategoryEntity>? subCategories) async {
    print(
        'selectedCategory in dropdown ${context.read<MainCategoriesTapsCubit>().selectedCategory.subcategories?.length}');
    print(subCategories);
    if (subCategories!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.noCategoriesAvailable.localize)),
      );
      return;
    }
    // final RenderBox button = context.findRenderObject() as RenderBox;
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
                            text: context.isArabic ? item.nameAr : item.nameEn,
                            style:
                                Styles.mediumText(fontWeight: FontWeight.bold)),
                        onTap: () {
                          if (context.isUserLoggedIn) {
                            Navigator.pop(context);
                            context.push(Routes.CREATEAD,
                                extra: CategorizationEntity(
                                    mainCategory: context
                                        .read<MainCategoriesTapsCubit>()
                                        .selectedCategory,
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
      ],
    );

    if (selected != null) {
      setState(() {
        selectedValue = selected;
      });
    }
    print(selectedValue.toString());
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MainCategoriesTapsCubit>();
    return BlocProvider(
      create: (context) => serviceLocator<SubcategoriesCubit>(),
      child: BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
        builder: (context, state) {
          final subCategoriesCubit = context.read<SubcategoriesCubit>();
          return CustomScaffold(
            appBar: widget.isAppBarShow
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(30),
                    child: BackAppBar(
                      label: labelName,
                      enableCustomAppBar: true,
                    ),
                  )
                : null,
            enableCustomAppBar: widget.isAppBarShow,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Column(
                children: [
                  // WalletWidget(),
                  SizedBox(height: 10.h),
                  BlocBuilder<MainCategoriesTapsCubit, MainCategoriesTapsState>(
                    builder: (context, state) {
                      return SizedBox(
                        height: 70.h,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: TabBar(
                            isScrollable: true,
                            controller: _tabController,
                            onTap: (i) async {
                              // controller.state.subCategories;
                              await controller.selectMainCategory(i);
                              // _fetchSubcategories(
                              //     stateSubCategories:
                              //         controller.state.subCategories);
                              // _fetchSubcategories(
                              //     mainCategoryId:
                              //         controller.mainCategories[i].id);
                              setState(() {
                                labelName = context.locale == Locales.english
                                    ? controller.mainCategories[i].nameEn
                                        .toString()
                                    : controller.mainCategories[i].name
                                        .toString();
                                // subCategories = controller.mainCategories[i].subcategories??[];
                              });
                              print(labelName);
                              // if (controller.mainCategories[i].id ==
                              //     '62c8b5b09332225799fe335e') {
                              //   context.push(Routes.MARRIAGESUBCATEGORIES,
                              //       extra: controller.mainCategories[i]);
                              // }
                            },
                            padding: EdgeInsets.zero,
                            labelPadding:
                                const EdgeInsetsDirectional.only(end: 10),
                            indicatorColor: Colors.transparent,
                            dividerColor: Colors.transparent,
                            tabAlignment: TabAlignment.start,
                            tabs: List.generate(
                              controller.mainCategories.length,
                              (index) {
                                final category =
                                    controller.mainCategories[index];
                                return Container(
                                  width: 220.w,
                                  // height: 70.h,
                                  alignment: AlignmentDirectional.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: index == state.selectedIndex
                                        ? AppColors.PRIMARY_COLOR
                                        : null,
                                    border: Border.all(
                                      color: index == state.selectedIndex
                                          ? AppColors.PRIMARY_COLOR
                                          : Colors.red,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      context.isArabic
                                          ? category.name!
                                          : category.nameEn ?? "",
                                      style: Styles.mediumText(
                                        color: index == state.selectedIndex
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const Sizer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
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
                                  : AppColors.PRIMARY_COLOR,
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
                              title: LocaleKeys.favouriteAds.localize,
                              isOpened: context
                                  .read<SubcategoriesCubit>()
                                  .isFavouriteAdsOpen,
                              onPressed: () {
                                if (!context.isUserLoggedIn) {
                                  return pleaseLoginDialog(context);
                                } else {
                                  context
                                      .read<SubcategoriesCubit>()
                                      .loadMyFavouriteAds(
                                          id: controller
                                              .mainCategories[
                                                  _tabController.index]
                                              .id);

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
                              onPressed: () {
                                context
                                    .read<SubcategoriesCubit>()
                                    .loadRequestsLogByMainCategory(
                                        mainCategoryId: controller
                                            .mainCategories[
                                                _tabController.index]
                                            .id);
                                context
                                    .read<SubcategoriesCubit>()
                                    .toggleMyAds('isRequestLogOpen');

                                // context.read<SubcategoriesCubit>().toggleRequestLog();
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
                              // TODO: EDIT THIS
                              if (!context.isUserLoggedIn) {
                                return pleaseLoginDialog(context);
                              } else {
                                context.read<SubcategoriesCubit>().loadMyAds(
                                    id: controller
                                        .mainCategories[_tabController.index]
                                        .id);
                                context
                                    .read<SubcategoriesCubit>()
                                    .toggleMyAds('isMyAdsOpen');
                              }
                              // context.push(Routes.MYADDS);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  if (subCategoriesCubit.isFavouriteAdsOpen)
                    Expanded(
                        child: BlocProvider(
                      create: (context) => serviceLocator<AdvertisementCubit>(),
                      child: FavouriteAdsView(
                        id: controller.mainCategories[_tabController.index].id,
                        isFloatingButtonVisible: (value) {
                          isFloatingButtonVisible = value;
                          setState(() {});
                        },
                      ),
                    )),
                  if (subCategoriesCubit.isRequestLogOpen)
                    Expanded(
                        child: AdsRequestLogView(
                            mainCategoryId: controller
                                .mainCategories[_tabController.index].id,
                            isFloatingButtonVisible: (value) {
                              isFloatingButtonVisible = value;
                              setState(() {});
                            })),
                  if (subCategoriesCubit.isMyAdsOpen)
                    Expanded(
                        child: BlocProvider(
                      create: (context) => serviceLocator<AdvertisementCubit>(),
                      child: MyAdsView(
                        id: controller.mainCategories[_tabController.index].id,
                        isFloatingButtonVisible: (value) {
                          isFloatingButtonVisible = value;
                          setState(() {});
                        },
                      ),
                    )),
                  if (context.read<SubcategoriesCubit>().isSearchAdsOpen)
                    SearchBarWidget(
                      onChanged: (value) {
                        _debounce.run(() {
                          context.read<SubcategoriesCubit>().searchAds(
                                value: value,
                                mainCategoryId: controller
                                    .mainCategories[_tabController.index].id,
                              );
                        });
                      },
                      focusNode: focusNode,
                    ),
                  if (context.read<SubcategoriesCubit>().isSearchAdsOpen)
                    //kslkfjslkfjslkfsldfkjlsfld
                    Expanded(
                      child: BlocProvider(
                        create: (context) =>
                            serviceLocator<AdvertisementCubit>(),
                        child: AdsSearchView(
                          mainCategoryNameAr: controller
                                  .mainCategories[_tabController.index].name ??
                              'N/A',
                          mainCategoryNameEn: controller
                                  .mainCategories[_tabController.index]
                                  .nameEn ??
                              'N/A',
                          isFloatingButtonVisible: (value) {
                            isFloatingButtonVisible = value;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  if (!subCategoriesCubit.isMyAdsOpen &&
                      !subCategoriesCubit.isFavouriteAdsOpen &&
                      !subCategoriesCubit.isRequestLogOpen &&
                      !subCategoriesCubit.isSearchAdsOpen)
                    BlocBuilder<MainCategoriesTapsCubit,
                        MainCategoriesTapsState>(
                      builder: (context, state) {
                        final controller =
                            context.read<MainCategoriesTapsCubit>();

                        if (controller.mainCategories[state.selectedIndex].id ==
                            '62c8b5b09332225799fe335e') {
                          return const Expanded(
                            child: MarriageSubCategoriesView(
                              // mainCategory:
                              //     controller.mainCategories[state.selectedIndex],
                              inGridView: true,
                            ),
                          );
                          // return Container();
                        }
                        if (state.subCategories != null &&
                            state.subCategories!.isNotEmpty) {
                          // final controller = context.read<MainCategoriesTapsCubit>();

                          return Expanded(
                            child: GridView.builder(
                              padding: EdgeInsets.all(24.w),
                              itemCount: state.subCategories?.length ?? 0,
                              controller: controller.scrollController,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: .65,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                              ),
                              itemBuilder: (context, index) {
                                final subCategory = state.subCategories![index];
                                return SubCategoryCard(
                                  mainCategory: controller.selectedCategory,
                                  item: subCategory,
                                  onFav: () {
                                    print("object");
                                    return controller
                                        .toggleSubCategoryToFavorites(
                                            state.subCategories![index].id);
                                  },
                                );
                              },
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                ],
              ),
            ),
            floatingActionButton: isFloatingButtonVisible
                ? BlocBuilder<MainCategoriesTapsCubit, MainCategoriesTapsState>(
                    builder: (context, state) {
                      final controller =
                          context.read<MainCategoriesTapsCubit>();
                      return buildFloatingAction(context, () {
                        _showDropdownMenu(context, state.subCategories);
                      });
                    },
                  )
                : null,
          );
        },
      ),
    );
  }
}

class MainCategoriesGridViewCustomPage extends StatefulWidget {
  const MainCategoriesGridViewCustomPage({super.key, this.isAppBarShow = true});

  final bool isAppBarShow;

  @override
  State<MainCategoriesGridViewCustomPage> createState() =>
      _MainCategoriesGridViewCustomPageState();
}

class _MainCategoriesGridViewCustomPageState
    extends State<MainCategoriesGridViewCustomPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  String labelName = "";
  bool isFloatingButtonVisible = true;
  late Debouncer _debounce;

  @override
  void initState() {
    _debounce = Debouncer();
    super.initState();
    _tabController = TabController(
        length: context.read<MainCategoriesTapsCubit>().mainCategories.length,
        vsync: this);
    _scrollController = ScrollController();
    // _fetchSubcategories(mainCategoryId: context.read<MainCategoriesTapsCubit>().mainCategories.first.id);
    // Listen for tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _scrollToSelectedTab(_tabController.index);
      }
      _scrollController.addListener(() {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          isFloatingButtonVisible = false;
        } else {
          isFloatingButtonVisible = true;
        }
        setState(() {});
      });
    });
    _fetchSubcategories(
        mainCategoryId:
            context.read<MainCategoriesTapsCubit>().mainCategories.first.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelName = context.isArabic
        ? context
            .read<MainCategoriesTapsCubit>()
            .mainCategories[0]
            .name
            .toString()
        : context
            .read<MainCategoriesTapsCubit>()
            .mainCategories[0]
            .nameEn
            .toString();
  }

  // Scroll to the selected tab and make it the first tab in view
  void _scrollToSelectedTab(int index) {
    // Assuming each tab has a width of 140.w
    double tabWidth = 235.w;
    double targetScrollPosition = index * tabWidth;
    _scrollController.animateTo(
      targetScrollPosition,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  List<SubCategoryEntity> subCategories = [];
  String? selectedValue;

  void _fetchSubcategories({String? mainCategoryId}) async {
    final subCategoriesList = await context
        .read<SubcategoriesCubit>()
        .getCustomPageSubcategories(mainCategoryId: mainCategoryId);
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
                            if (context.isUserLoggedIn) {
                              Navigator.pop(context);
                              context.push(
                                Routes.CREATEAD,
                                extra: CategorizationEntity(
                                  mainCategory: context
                                      .read<MainCategoriesTapsCubit>()
                                      .selectedCategory,
                                  subCategory: item,
                                ),
                              );
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

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MainCategoriesTapsCubit>();
    final focusNode = FocusNode();
    return BlocProvider(
      create: (context) => serviceLocator<SubcategoriesCubit>(),
      child: BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
        builder: (context, state) {
          final subCategoriesCubit = context.read<SubcategoriesCubit>();
          return CustomScaffold(
            appBar: widget.isAppBarShow
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(30),
                    child: BackAppBar(
                      label: labelName,
                      enableCustomAppBar: true,
                    ),
                  )
                : null,
            enableCustomAppBar: widget.isAppBarShow,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Column(
                children: [
                  // WalletWidget(),
                  SizedBox(height: 10.h),
                  BlocBuilder<MainCategoriesTapsCubit, MainCategoriesTapsState>(
                    builder: (context, state) {
                      return SizedBox(
                        height: 70.h,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: TabBar(
                            isScrollable: true,
                            controller: _tabController,
                            onTap: (i) async {
                              // controller.state.subCategories;
                              await controller.selectMainCategory(i);
                              _fetchSubcategories(
                                  mainCategoryId:
                                      controller.mainCategories[i].id);
                              setState(() {
                                labelName = context.locale == Locales.english
                                    ? controller.mainCategories[i].nameEn
                                        .toString()
                                    : controller.mainCategories[i].name
                                        .toString();
                                // subCategories = controller.mainCategories[i].subcategories??[];
                              });
                              print(labelName);
                              // if (controller.mainCategories[i].id ==
                              //     '62c8b5b09332225799fe335e') {
                              //   context.push(Routes.MARRIAGESUBCATEGORIES,
                              //       extra: controller.mainCategories[i]);
                              // }
                            },
                            padding: EdgeInsets.zero,
                            labelPadding:
                                const EdgeInsetsDirectional.only(end: 10),
                            indicatorColor: Colors.transparent,
                            dividerColor: Colors.transparent,
                            tabAlignment: TabAlignment.start,
                            tabs: List.generate(
                              controller.mainCategories.length,
                              (index) {
                                final category =
                                    controller.mainCategories[index];
                                return Container(
                                  width: 220.w,
                                  // height: 70.h,
                                  alignment: AlignmentDirectional.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: index == state.selectedIndex
                                        ? AppColors.PRIMARY_COLOR
                                        : null,
                                    border: Border.all(
                                      color: index == state.selectedIndex
                                          ? AppColors.PRIMARY_COLOR
                                          : Colors.red,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      context.isArabic
                                          ? category.name!
                                          : category.nameEn ?? "",
                                      style: Styles.mediumText(
                                        color: index == state.selectedIndex
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const Sizer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
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
                                  : AppColors.PRIMARY_COLOR,
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
                              title: LocaleKeys.favouriteAds.localize,
                              isOpened: context
                                  .read<SubcategoriesCubit>()
                                  .isFavouriteAdsOpen,
                              onPressed: () {
                                if (!context.isUserLoggedIn) {
                                  return pleaseLoginDialog(context);
                                } else {
                                  context
                                      .read<SubcategoriesCubit>()
                                      .loadMyFavouriteAds(
                                          id: controller
                                              .mainCategories[
                                                  _tabController.index]
                                              .id);

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
                              onPressed: () {
                                context
                                    .read<SubcategoriesCubit>()
                                    .loadRequestsLogByMainCategory(
                                        mainCategoryId: controller
                                            .mainCategories[
                                                _tabController.index]
                                            .id);
                                context
                                    .read<SubcategoriesCubit>()
                                    .toggleMyAds('isRequestLogOpen');

                                // context.read<SubcategoriesCubit>().toggleRequestLog();
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
                              // TODO: EDIT THIS
                              if (!context.isUserLoggedIn) {
                                return pleaseLoginDialog(context);
                              } else {
                                context.read<SubcategoriesCubit>().loadMyAds(
                                    id: controller
                                        .mainCategories[_tabController.index]
                                        .id);
                                context
                                    .read<SubcategoriesCubit>()
                                    .toggleMyAds('isMyAdsOpen');
                              }
                              // context.push(Routes.MYADDS);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (context.read<SubcategoriesCubit>().isSearchAdsOpen)
                    SearchBarWidget(
                      onChanged: (value) {
                        _debounce.run(() {
                          context.read<SubcategoriesCubit>().searchAds(
                                value: value,
                                mainCategoryId: controller
                                    .mainCategories[_tabController.index].id,
                              );
                        });
                      },
                      focusNode: focusNode,
                    ),
                  if (subCategoriesCubit.isFavouriteAdsOpen)
                    Expanded(
                        child: BlocProvider(
                      create: (context) => serviceLocator<AdvertisementCubit>(),
                      child: FavouriteAdsView(
                        id: controller.mainCategories[_tabController.index].id,
                        isFloatingButtonVisible: (value) {
                          isFloatingButtonVisible = value;
                          setState(() {});
                        },
                      ),
                    )),
                  if (subCategoriesCubit.isRequestLogOpen)
                    Expanded(
                        child: AdsRequestLogView(
                            mainCategoryId: controller
                                .mainCategories[_tabController.index].id,
                            isFloatingButtonVisible: (value) {
                              isFloatingButtonVisible = value;
                              setState(() {});
                            })),
                  if (subCategoriesCubit.isMyAdsOpen)
                    Expanded(
                        child: BlocProvider(
                      create: (context) => serviceLocator<AdvertisementCubit>(),
                      child: MyAdsView(
                        id: controller.mainCategories[_tabController.index].id,
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
                        create: (context) =>
                            serviceLocator<AdvertisementCubit>(),
                        child: AdsSearchView(
                          mainCategoryNameAr: controller
                                  .mainCategories[_tabController.index].name ??
                              'N/A',
                          mainCategoryNameEn: controller
                                  .mainCategories[_tabController.index]
                                  .nameEn ??
                              'N/A',
                          isFloatingButtonVisible: (value) {
                            isFloatingButtonVisible = value;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  if (!subCategoriesCubit.isMyAdsOpen &&
                      !subCategoriesCubit.isFavouriteAdsOpen &&
                      !subCategoriesCubit.isRequestLogOpen &&
                      !subCategoriesCubit.isSearchAdsOpen)
                    BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
                      builder: (context, state) {
                        // final controller =
                        //     context.read<MainCategoriesTapsCubit>();
                        // if (state.customPageSubCategories.id ==
                        //     '62c8b5b09332225799fe335e') {
                        //   return const Expanded(
                        //     child: MarriageSubCategoriesView(
                        //       // mainCategory:
                        //       //     controller.mainCategories[state.selectedIndex],
                        //       inGridView: true,
                        //     ),
                        //   );
                        //   // return Container();
                        // }
                        if (subCategories.isNotEmpty) {
                          // final controller = context.read<MainCategoriesTapsCubit>();
                          return Expanded(
                            child: GridView.builder(
                              padding: EdgeInsets.all(24.w),
                              itemCount: subCategories.length ?? 0,
                              controller: controller.scrollController,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: .65,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                              ),
                              itemBuilder: (context, index) {
                                final subCategory = subCategories[index];
                                return SubCategoryCard(
                                  mainCategory: controller.selectedCategory,
                                  item: subCategory,
                                  onFav: () {
                                    print("object");
                                    return controller
                                        .toggleSubCategoryToFavorites(
                                            subCategories[index].id);
                                  },
                                );
                              },
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                ],
              ),
            ),
            floatingActionButton: isFloatingButtonVisible
                ? buildFloatingAction(context, () {
                    _showDropdownMenu(context);
                  })
                : null,
          );
        },
      ),
    );
  }
}

class MainCategoriesGrideViewSection extends StatefulWidget {
  const MainCategoriesGrideViewSection({
    super.key,
    required this.controller,
    required this.state,
  });

  final MainCategoriesState state;
  final MainCategoriesCubit controller;

  @override
  State<MainCategoriesGrideViewSection> createState() =>
      _MainCategoriesGrideViewSectionState();
}

class _MainCategoriesGrideViewSectionState
    extends State<MainCategoriesGrideViewSection>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  String labelName = "";

  @override
  void initState() {
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelName = context.locale == Locales.english
        ? widget.state.customPage![0].nameEn.toString()
        : widget.state.customPage![0].name.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        controller: _scrollController,
        slivers: [
          Builder(builder: (context) {
            if (widget.state.customPage!.isNotEmpty) {
              // final mainCategoriesController =
              //     context.read<MainCategoriesCubit>();
              return SliverGrid.builder(
                itemCount: widget.state.customPage!.length ?? 0,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 5 / 4),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        print(
                            'mainCategory.id ${widget.state.customPage![index].id} in gredview test');
                        AdInterstitialTop.loadIntersitialAd();
                        AdInterstitialTop.showInterstitialAd();
                        HandleCashback.setCount('mainCategoriesCount', context);
                        if (widget.state.customPage![index].id ==
                            '62c8b5b09332225799fe335e') {
                          context.push(Routes.MARRIAGESUBCATEGORIES,
                              extra: widget.state.customPage![index]);
                        } else {
                          print(
                              'mainCategory.id ${widget.state.customPage![index].id} in gredview');
                          context.push(Routes.CustomPageSubCategoriesView,
                              extra: CustomPageSubCategoriesParams(
                                mainCategory: widget.state.customPage![index],
                                isCustomPage: true,
                              ));
                        }
                      },
                      child: MainCategoryBanner(
                        category: widget.state.customPage![index],
                        onFavorite: () async {
                          var result = await widget.controller
                              .toggleFavoriteMedicalService(
                                  widget.state.customPage![index].id);
                          print("result$result");
                          return result;
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }
          }),
        ],
      ),
    );
  }
}
