import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/dynamic/wallet_widget.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_taps_cubit/main_categories_taps_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class MainCategoriesGridView extends StatelessWidget {
  const MainCategoriesGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MainCategoriesTapsCubit>();
    return Scaffold(
      appBar: const BackAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: [
            const WalletWidget(),
            const SizedBox(height: 10),
            SizedBox(
              height: 30,
              child:
                  BlocBuilder<MainCategoriesTapsCubit, MainCategoriesTapsState>(
                builder: (context, state) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final category = controller.mainCategories[index];
                      return GestureDetector(
                        onTap: () {
                          controller.selectMainCategory(index);
                        },
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 120,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Sizer(),
                    itemCount: controller.mainCategories.length,
                  );
                },
              ),
            ),
            const Sizer(),
            BlocBuilder<MainCategoriesTapsCubit, MainCategoriesTapsState>(
              builder: (context, state) {
                if (state.subCategories != null &&
                    state.subCategories!.isNotEmpty) {
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
