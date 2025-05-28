import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/installment_list_cubit.dart';
import '../widgets/installment_ad_card.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class InstallmentView extends StatelessWidget {
  const InstallmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstallmentListCubit, InstallmentListState>(
      listener: (context, state) {},
      builder: (context, state) {
        final controller = context.read<InstallmentListCubit>();
        return SharedScaffold(
            mainCategoryId: 1,
            body: RefreshIndicator(
              onRefresh: () async => controller.loadData(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // _buildHorizontalCategories(
                  //   context: context,
                  // ),
                  _buildViewType(context: context),
                  Expanded(child: _buildProductsWidget()),
                ],
              ),
            ));
      },
    );
  }

  Widget _buildViewType({required BuildContext context}) {
    return BlocBuilder<InstallmentListCubit, InstallmentListState>(
        builder: (context, state) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10),
        width: kToolbarHeight * 2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.PRIMARY_COLOR)),
        child: Row(
          children: [
            Expanded(
                child: _buildViewItem(
                    icon: Icons.list,
                    value: false,
                    isSelected: !state.isGrid,
                    context: context)),
            Expanded(
                child: _buildViewItem(
                    icon: Icons.grid_4x4_outlined,
                    value: true,
                    isSelected: state.isGrid,
                    context: context)),
          ],
        ),
      );
    });
  }

  Widget _buildViewItem(
      {required IconData icon,
      required bool isSelected,
      required bool value,
      required BuildContext context}) {
    final controller = context.read<InstallmentListCubit>();
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isSelected ? AppColors.PRIMARY_COLOR : Colors.white),
      child: InkWell(
        onTap: () => controller.changeView(isGrid: value),
        child: Icon(
          icon,
          size: 16,
          color: isSelected ? Colors.white : AppColors.PRIMARY_COLOR,
        ),
      ),
    );
  }

  Widget _buildHorizontalCategories({
    required BuildContext context,
  }) {
    final controller = context.read<InstallmentListCubit>();
    return BlocBuilder<InstallmentListCubit, InstallmentListState>(
        builder: (context, state) {
      return SizedBox(
        height: kToolbarHeight * .5,
        child: Row(
          children: [
            // InkWell(
            //   onTap: () {
            //     bottomSheet(context: context, widget: CustomScaffold());
            //   },
            //   child: Container(
            //     height: kToolbarHeight * .5,
            //     margin: EdgeInsets.only(left: 10),
            //     padding: EdgeInsets.symmetric(horizontal: 10),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(5),
            //         border: Border.all(color: AppColors.PRIMARY_COLOR),
            //         color: AppColors.PRIMARY_COLOR),
            //     child: const Icon(
            //       Icons.sort,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.subCategories?.length ?? 0,
                itemBuilder: (context, index) {
                  final subCategory = state.subCategories![index];
                  return InkWell(
                    onTap: () => controller.changeSubCategory(v: subCategory),
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: state.selectedSubCategory == subCategory
                              ? null
                              : Border.all(color: AppColors.LIGHT_GRAY_COLOR),
                          color: state.selectedSubCategory == subCategory
                              ? AppColors.PRIMARY_COLOR
                              : AppColors.LIGHT_GRAY_COLOR),
                      child: Center(
                        child: Label(
                            text: context.isArabic
                                ? subCategory.nameAr
                                : subCategory.nameEn,
                            style: Styles.mediumText(
                                color: state.selectedSubCategory == subCategory
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Sizer(
                  width: 0,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildProductsWidget() {
    return BlocBuilder<InstallmentListCubit, InstallmentListState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: state.isLoading
            ? const Center(
                child: CustomCircularProgressIndicator(),
              )
            : state.isGrid
                ? GridView.builder(
                    itemBuilder: (context, index) => InstallmentAdCard(
                          item: state.installments![index],
                        ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: .8,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            crossAxisCount: 2),
                    itemCount: state.installments?.length ?? 0)
                : ListView.separated(
                    itemBuilder: (context, index) => InstallmentAdCard(
                          item: state.installments![index],
                          isVertical: false,
                        ),
                    separatorBuilder: (context, index) => const Sizer(),
                    itemCount: state.installments?.length ?? 0),
      );
    });
  }
}
