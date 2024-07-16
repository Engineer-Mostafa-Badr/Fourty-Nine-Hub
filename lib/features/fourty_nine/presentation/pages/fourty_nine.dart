import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/parent_main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/parent_main_categories_cubit/main_categories_cubit.dart';

import '../../../../common/widgets/dynamic/google_ads_banner.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/const.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/dynamic/wallet_widget.dart';
import '../../../../res/style/app_colors.dart';
import '../controllers/main_categories_cubit/parent_main_categories_cubit.dart';
import '../widgets/advertise_your_company.dart';
import '../widgets/announce_widget.dart';
import '../widgets/main_category_card.dart';
import '../widgets/register_options.dart';

class FourtyNineView extends StatefulWidget {
  const FourtyNineView({super.key});

  @override
  State<FourtyNineView> createState() => _FourtyNineViewState();
}

class _FourtyNineViewState extends State<FourtyNineView> {
  bool isList = true;

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      isWithBackArrow: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AnnounceWidget(),
            const WalletWidget(
              margin: 5,
            ),
            const RegisterOptions(),
            // const Sizer(),

            const AdvertiseYourCompany(),
           // const GoogleAddsBanner(),
            const Sizer(),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.GREY_LIGHT_COLOR,
                    blurRadius: 10,
                    spreadRadius: 5,
                  )
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildMazadatWidget(),
                  const Sizer(),
                  BlocBuilder<MainCategoriesCubit,
                      BasicState<List<MainCategoryEntity>>>(
                    builder: (context, state) {
                      if (state.status == StateStatus.loading) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }
                      if (state.status != StateStatus.success) {
                        return const SizedBox.shrink();
                      }
                      return _buildHorizontalServices(state.data!);
                    },
                  ),
                  _buildViewType(),
                  BlocBuilder<ParentMainCategoriesCubit,
                      BasicState<List<ParentMainCategoryEntity>>>(
                    builder: (context, state) {
                      if (state.status == StateStatus.loading) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }
                      if (state.status != StateStatus.success) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: state.data!
                            .map(
                              (e) => _buildFourtyNineServices(
                                e,
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMazadatWidget() {
    return Row(
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
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: AppButton(
                          label: 'Auction',
                          icon: Icons.group,
                          onPressed: () => context.push(Routes.MAZADAT)),
                    ),
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
              height: kToolbarHeight * .5,
              label: 'Installments',
              icon: Icons.list,
              onPressed: () => context.push(Routes.INSTALLMENT)),
        )
      ],
    );
  }

  Widget _buildViewType() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: kToolbarHeight * 2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.PRIMARY_COLOR)),
      child: Row(
        children: [
          Expanded(child: _buildViewItem(icon: Icons.list, isSelected: isList)),
          Expanded(
              child: _buildViewItem(
                  icon: Icons.grid_4x4_outlined, isSelected: !isList)),
        ],
      ),
    );
  }

  Widget _buildViewItem({required IconData icon, required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isSelected ? AppColors.PRIMARY_COLOR : Colors.white),
      child: InkWell(
        onTap: () {
          isList = !isList;
          setState(
            () {},
          );
        },
        child: Icon(
          icon,
          size: 16,
          color: isSelected ? Colors.white : AppColors.PRIMARY_COLOR,
        ),
      ),
    );
  }

  Widget _buildFourtyNineServices(ParentMainCategoryEntity parentMainCategory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: parentMainCategory.name,
          style: Styles.headerText(),
        ),
        GridView.builder(
          itemCount: parentMainCategory.mainCategories.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: isList ? 10 : 0,
              mainAxisSpacing: isList ? 10 : 0,
              crossAxisCount: isList ? 2 : 4,
              childAspectRatio: isList ? 2.5 : 1),
          itemBuilder: (context, index) {
            return _buildServiceItem(
              parentMainCategory.mainCategories[index],
            );
          },
        ),
      ],
    );
  }

  Widget _buildHorizontalServices(List<MainCategoryEntity> mainCategories) {
    return SizedBox(
      height: kToolbarHeight * .5,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mainCategories.length,
        itemBuilder: (context, index) {
          final mainCategory = mainCategories[index];
          return Container(
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.PRIMARY_COLOR,
            ),
            child: Center(
              child: Label(
                text: mainCategory.name,
                style: Styles.mediumText(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const Sizer(
          width: 0,
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 16,
            ),
            Expanded(
                child: Label(text: 'Cairo , Egypt', style: Styles.mediumText()))
          ],
        ),
        const Sizer(
          height: 4,
        ),
        Row(
          children: [
            Expanded(
                child: Container(
              height: kToolbarHeight * .7,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.GRAY_LIGHT_COLOR3),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                  const Sizer(),
                  Label(text: 'Search', style: Styles.mediumText())
                ],
              ),
            )),
            const Sizer(),
            Container(
              height: kToolbarHeight * .7,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.GRAY_LIGHT_COLOR3),
              child: const Icon(
                Icons.sort,
                color: AppColors.PRIMARY_COLOR,
              ),
            ),
          ],
        ),
        const Sizer(),
        Row(
          children: [
            Container(
              height: kToolbarHeight * .5,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.PRIMARY_COLOR)),
              child: Row(
                children: [
                  const Icon(Icons.repeat_sharp,
                      color: AppColors.PRIMARY_COLOR),
                  Label(text: 'Highly Related', style: Styles.mediumText())
                ],
              ),
            ),
            _buildFilterItem(),
            _buildFilterItem(),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterItem() {
    return Container(
      height: kToolbarHeight * .5,
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.PRIMARY_COLOR,
      ),
      child: Row(
        children: [
          Label(
            text: 'Car',
            style: Styles.mediumText(color: Colors.white),
          ),
          const Sizer(
            width: 5,
          ),
          const Icon(
            Icons.clear,
            color: Colors.white,
            size: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(MainCategoryEntity mainCategory) {
    return MainCategoryCard(
      mainCategory: mainCategory,
    );
  }
}
