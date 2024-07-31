import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';

import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/parent_main_categories_cubit/main_categories_cubit.dart';

import '../../../../common/widgets/dynamic/google_ads_banner.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';

import '../../../../core/enums/ride_services_enum.dart';
import '../../../../res/assets/assets.dart';
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
  final scrollController = ScrollController();

  @override
  void initState() {
    final controller = context.read<MainCategoriesCubit>();
    scrollController.addListener(() async {
      await controller.getMainCategoriesPagination();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
        mainCategoryId: 1,
        isWithBackArrow: false,
        body: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AnnounceWidget(),
                    const AdsTextBanner(),
                    const WalletWidget(),
                    const GoogleAddsBanner(),
                    const Sizer(),
                    _buildMazadatWidget(),
                    const Sizer(),
                    BlocBuilder<MainCategoriesCubit,
                        BasicState<List<MainCategoryEntity>>>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (state.data != null)
                              ...state.data!.map(
                                (e) => _buildMainCategoriesWidget(
                                  category: e,
                                ),
                              ),
                            if (state.isLoading)
                              const CircularProgressIndicator.adaptive()
                          ],
                        );
                      },
                    ),
                  ]),
            )));
  }

  Widget _buildMazadatWidget() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildRideSubCategoryItem(
                  service: RideServicesEnum.comeWithYou,
                  image: Assets.movingCar),
            ),
            const Sizer(),
            Expanded(
              child: _buildRideSubCategoryItem(
                  service: RideServicesEnum.pickMe, image: Assets.walking),
            )
          ],
        ),
        const Sizer(),
        Row(
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
                        child: AppButton(
                            label: 'Auction',
                            icon: Icons.group,
                            onPressed: () => context.push(Routes.MAZADAT)),
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
        ),
      ],
    );
  }

  Widget _buildRideSubCategoryItem({
    required RideServicesEnum service,
    required String image,
  }) {
    return InkWell(
      onTap: () => context.push(Routes.ADS, extra: service.value()),
      child: Container(
        height: kToolbarHeight * 1.3,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(255, 249, 159, 162),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(1, 1))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Label(text: service.title(), style: Styles.headerText()),
            // MovingWidgetHr(asset: image, label: service.title())
          ],
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
        if(category.subcategories?.isNotEmpty??false)
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
