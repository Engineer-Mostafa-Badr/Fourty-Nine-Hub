import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import 'package:fourtyninehub/core/enums/base_status_enum.dart';

import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';

import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/parent_main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

import '../../../../common/widgets/stateless/buttons/app_button.dart';

import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/dynamic/wallet_widget.dart';
import '../../../../res/style/app_colors.dart';

import '../../../subcategories/presentation/widgets/subcategory_card.dart';
import '../widgets/ads_text_banner.dart';
import '../widgets/announce_widget.dart';

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
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const AnnounceWidget(),
            const AdsTextBanner(),
            const WalletWidget(),
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
                return Column(
                  children: state.data!
                      .map(
                        (e) => _buildMainCategoriesWidget(
                          category: e,
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ]),
        )));
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

  Widget _buildMainCategoriesWidget({
    required MainCategoryEntity category,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: category.name,
          style: Styles.headerText(),
        ),
        SizedBox(
          height: kToolbarHeight * 3,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return SubCategoryCard(
                  mainCategory: category,
                  item: category.subcategories![index]);
              },
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: category.subcategories?.length ?? 0),
        )
      ],
    );
  }
}
