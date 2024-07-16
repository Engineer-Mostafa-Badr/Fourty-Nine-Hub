import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../../../restaurant_details/presentation/widgets/meal_card.dart';
import '../../../restaurant_details/presentation/widgets/restaurant_header.dart';
import '../../data/models/selected_meal_model.dart';
import '../cubit/restaurant_details_cubit.dart';

class RestaurantDetailsView extends StatefulWidget {
  final String id;
  const RestaurantDetailsView({super.key, required this.id});

  @override
  State<RestaurantDetailsView> createState() => _RestaurantDetailsViewState();
}

class _RestaurantDetailsViewState extends State<RestaurantDetailsView> {
  @override
  void initState() {
    context.read<RestaurantDetailsCubit>().loadData(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: _buildBuscketButton(),
      body: BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
          builder: (context, state) {
        return ListView(
          children: [
            if (state.restaurant != null)
              RestaurantHeader(restaurant: state.restaurant!),
            const Divider(),
            // _buildFilter(),
            _buildFoodList(context: context),
          ],
        );
      }),
    );
  }

  Widget _buildBuscketButton() {
    return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
        builder: (context, state) {
      return Container(
          margin: const EdgeInsets.all(10),
          child: AppButton(
              backColor: state.selectedMeals?.isNotEmpty ?? false
                  ? AppColors.SECONDARY_COLOR
                  : AppColors.SECONDARY_COLOR.withOpacity(.7),
              label: 'View Cart - ${state.selectedMeals?.length ?? 0} Items',
              onPressed: () {
                if (state.selectedMeals?.isNotEmpty ?? false) {
                  context.push(Routes.FOODCART);
                }
              }));
    });
  }

  Widget _buildFoodList({required BuildContext context}) {
    final controller = context.read<RestaurantDetailsCubit>();
    return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
        builder: (context, state) {
      return state.meals?.isNotEmpty ?? false
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: state.meals?.length ?? 0,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return MealCard(
                      restaurantId: widget.id,
                      addToCart: (SelectedMealModel v) => controller.addToCart(
                          context: context, selectedMeal: v),
                      item: state.meals![index],
                    );
                  }))
          : const SizedBox();
    });
  }

  Widget _buildFilter() {
    return Container(
      height: kToolbarHeight * .5,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Label(text: 'Break Fast', style: Styles.mediumText()),
                  if (index == 0)
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      color: AppColors.SECONDARY_COLOR,
                      height: 2,
                      width: 80,
                    ),
                ],
              ),
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: 20),
    );
  }
}
