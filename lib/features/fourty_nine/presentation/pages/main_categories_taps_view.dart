import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/ads/interstitial_ad_model.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_taps_cubit/main_categories_taps_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: context.read<MainCategoriesTapsCubit>().mainCategories.length,
        vsync: this);
    _scrollController = ScrollController();

    // Listen for tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _scrollToSelectedTab(_tabController.index);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelName = context.locale == Locales.english
        ? context
            .read<MainCategoriesTapsCubit>()
            .mainCategories[0]
            .nameEn
            .toString()
        : context
            .read<MainCategoriesTapsCubit>()
            .mainCategories[0]
            .name
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

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MainCategoriesTapsCubit>();
    return Scaffold(
      appBar: widget.isAppBarShow ? BackAppBar(label: labelName) : null,
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
                      onTap: (i) {
                        controller.selectMainCategory(i);
                        setState(() {
                          labelName = context.locale == Locales.english
                              ? controller.mainCategories[i].nameEn.toString()
                              : controller.mainCategories[i].name.toString();
                        });
                        print(labelName);
                      },
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsetsDirectional.only(end: 10),
                      indicatorColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                      tabAlignment: TabAlignment.start,
                      tabs: List.generate(controller.mainCategories.length,
                          (index) {
                        final category = controller.mainCategories[index];
                        return Container(
                          width: 220.w,
                          // height: 70.h,
                          alignment: AlignmentDirectional.center,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              context.locale == Locales.english
                                  ? category.nameEn!
                                  : category.name ?? "",
                              style: Styles.mediumText(
                                  color: index == state.selectedIndex
                                      ? Colors.white
                                      : Colors.grey),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      })),
                ),
              );
            }),
            const Sizer(),
            BlocBuilder<MainCategoriesTapsCubit, MainCategoriesTapsState>(
              builder: (context, state) {
                if (state.subCategories != null &&
                    state.subCategories!.isNotEmpty) {
                  final controller = context.read<MainCategoriesTapsCubit>();
                  return Expanded(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.subCategories?.length ?? 0,
                      controller: controller.scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 1),
                      itemBuilder: (context, index) {
                        final subCategory = state.subCategories![index];
                        return SubCategoryCard(
                          mainCategory: controller.selectedCategory,
                          item: subCategory,
                          onFav: () {
                            print("object");
                            return controller.toggleSubCategoryToFavorites(
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
    );
  }
}

class MainCategoriesGrideViewSection extends StatefulWidget {
  const MainCategoriesGrideViewSection({super.key});

  @override
  State<MainCategoriesGrideViewSection> createState() =>
      _MainCategoriesGrideViewSectionState();
}

class _MainCategoriesGrideViewSectionState
    extends State<MainCategoriesGrideViewSection>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  String labelName = "";

  @override
  void initState() {
    _tabController = TabController(
        length: context.read<MainCategoriesTapsCubit>().mainCategories.length,
        vsync: this);
    _scrollController = ScrollController();

    // Listen for tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _scrollToSelectedTab(_tabController.index);
      }
    });
    super.initState();
  }

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelName = context.locale == Locales.english
        ? context
            .read<MainCategoriesTapsCubit>()
            .mainCategories[0]
            .nameEn
            .toString()
        : context
            .read<MainCategoriesTapsCubit>()
            .mainCategories[0]
            .name
            .toString();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MainCategoriesTapsCubit>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        controller: _scrollController,
        slivers: [
          BlocBuilder<MainCategoriesTapsCubit, MainCategoriesTapsState>(
            builder: (context, state) {
              if (controller.mainCategories.isNotEmpty) {
                final controller = context.read<MainCategoriesTapsCubit>();
                final mainCategoriesController =
                    context.read<MainCategoriesCubit>();
                return SliverGrid.builder(
                  itemCount: controller.mainCategories.length ?? 0,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: 5 / 4),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () {
                          AdInterstitialTop.loadIntersitialAd();
                          AdInterstitialTop.showInterstitialAd();
                          HandleCashback.setCount(
                              'mainCategoriesCount', context);
                          if(controller.mainCategories[index].id=='62c8b5b09332225799fe335e'){
                            context.push(Routes.MARRIAGESUBCATEGORIES,
                                extra: controller.mainCategories[index]);
                          }else{
                            context.push(Routes.SUBCATEGORIES,
                                extra: controller.mainCategories[index]);
                          }
                        },
                        child: MainCategoryBanner(
                          category: controller.mainCategories[index],
                          onFavorite: () async {
                            var result = await mainCategoriesController
                                .toggleFavoriteMedicalService(
                                    controller.mainCategories[index].id);
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
            },
          ),
        ],
      ),
    );
  }
}
