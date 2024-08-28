import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/data/models/selected_meal_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    super.key,
    required this.meal,
  });

  final RestaurantMenu? meal;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  int qty = 1;
  double total = 0.0;
  bool add = false;

  @override
  void initState() {
    total = widget.meal?.price ?? 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RestaurantDetailsCubit>();
    return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
        builder: (context, state) {
      return ListTile(
        onTap: () {
          // controller.selectMeal(meal: meal!, index: index);
        },
        dense: true,
        visualDensity: VisualDensity.comfortable,
        title: Text(
          widget.meal?.foodName ?? "",
          style: Styles.headerText(
              fontWeight: FontWeight.bold, color: AppColors.PRIMARY_COLOR),
        ),
        subtitle: Text(
          '${widget.meal?.price} EGP',
          style: Styles.headerText(
            fontWeight: FontWeight.bold,
            color: AppColors.ACCENT_COLOR,
          ),
        ),
        leading: SquareImage(
          url: widget.meal?.picture?.mediaKey ?? "",
          height: 50,
          width: 50,
        ),
        trailing: Checkbox(
          value: add,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                add = value;
              });
              if (value) {
                controller.selectMeal(meal: widget.meal!);
              } else {
                controller.removeMeal(meal: widget.meal!);
              }
            }
          },
          activeColor: AppColors.SECONDARY_COLOR,
          checkColor: Colors.white,
          visualDensity: VisualDensity.comfortable,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    });
  }
}
