import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_taps_cubit/main_categories_taps_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainCategoriesGridView extends StatefulWidget {
  MainCategoriesGridView({super.key});

  @override
  State<MainCategoriesGridView> createState() => _MainCategoriesGridViewState();
}

class _MainCategoriesGridViewState extends State<MainCategoriesGridView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<MainCategoriesTapsCubit>();
    return Scaffold(
      appBar: const BackAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        child: Column(
          children: [
            //  WalletWidget(),
            SizedBox(height: 10.h),
            // SizedBox(
            //   height: 30.h,
            //   child:
            //       BlocBuilder<MainCategoriesTapsCubit, MainCategoriesTapsState>(
            //     builder: (context, state) {
            //       return ListView.separated(
            //         scrollDirection: Axis.horizontal,
            //         physics:  ScrollPhysics(),
            //         itemBuilder: (context, index) {
            //           final category = controller.mainCategories[index];
            //           return GestureDetector(
            //             onTap: () {
            //               controller.selectMainCategory(index);
            //             },
            //             child: Container(
            //               constraints:  BoxConstraints(
            //                 minWidth: 120,
            //               ),
            //               padding:  EdgeInsets.symmetric(horizontal: 10),
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(20),
            //                 color: index == state.selectedIndex
            //                     ? AppColors.PRIMARY_COLOR
            //                     : null,
            //                 border: Border.all(
            //                   color: index == state.selectedIndex
            //                       ? Colors.white
            //                       : Colors.red,
            //                 ),
            //               ),
            //               child: Center(
            //                 child: Text(
            //                   category.name,
            //                   style: Styles.mediumText(
            //                       color: index == state.selectedIndex
            //                           ? Colors.white
            //                           : Colors.grey),
            //                 ),
            //               ),
            //             ),
            //           );
            //         },
            //         separatorBuilder: (context, index) =>  Sizer(),
            //         itemCount: controller.mainCategories.length,
            //       );
            //     },
            //   ),
            // ),
            BlocBuilder<MainCategoriesTapsCubit, MainCategoriesTapsState>(
                builder: (context, state) {
              return SizedBox(
                height: 60.h,
                child: TabBar(
                    isScrollable: true,
                    onTap: (i) {
                      controller.selectMainCategory(i);
                    },
                    padding: EdgeInsets.zero,
                    labelPadding: const EdgeInsetsDirectional.only(end: 10),
                    indicatorColor: Colors.transparent,
                    dividerColor: Colors.transparent,
                    tabAlignment: TabAlignment.start,
                    controller: TabController(
                        length: controller.mainCategories.length, vsync: this),
                    tabs: List.generate(controller.mainCategories.length,
                        (index) {
                      final category = controller.mainCategories[index];
                      return Container(
                        // constraints:  BoxConstraints(
                        //   minWidth: 120,
                        // ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: index == state.selectedIndex
                              ? AppColors.PRIMARY_COLOR
                              : null,
                          border: Border.all(
                            color: index == state.selectedIndex
                                ? Colors.white
                                : Colors.red,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            category.name,
                            style: Styles.mediumText(
                                color: index == state.selectedIndex
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                        ),
                      );
                    })),
              );
            }),
            Sizer(),
            BlocBuilder<MainCategoriesTapsCubit, MainCategoriesTapsState>(
              builder: (context, state) {
                if (state.subCategories != null &&
                    state.subCategories!.isNotEmpty) {
                  final controller = context.read<MainCategoriesTapsCubit>();
                  return Expanded(
                    child: GridView.builder(
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
