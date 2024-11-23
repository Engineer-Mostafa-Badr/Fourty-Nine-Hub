import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../restaurants_list/domain/entities/restaurant_mneu.dart';

class ItemCard extends StatefulWidget {
  final String restaurantId;
  final RestaurantMenu meal;
  final bool? fromUpdate;

  const ItemCard({
    super.key,
    required this.meal,
    required this.restaurantId,
    this.fromUpdate,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  int qty = 0;

  @override
  void initState() {
    super.initState();
    // Initialize quantity if needed
  }

  void _increaseQuantity() async {
    // await context.read<RestaurantDetailsCubit>().addToCart(
    //   context,
    //   restaurantId: widget.restaurantId,
    //   foodId: widget.meal.id ?? "",
    //   quantity: (1).toString(),
    // );
    setState(() {
      qty++;
    });
  }

  void _decreaseQuantity() async {
    if (qty > 0) {
      // await context.read<RestaurantDetailsCubit>().addToCart(
      //   context,
      //   restaurantId: widget.restaurantId,
      //   foodId: widget.meal.id ?? "",
      //   quantity: qty.toString(),
      // );
      setState(() {
        qty--;
      });
    }
  }

  void _addToCart() async {
    await context.read<RestaurantDetailsCubit>().addToCart(
          context,
          restaurantId: widget.restaurantId,
          foodId: widget.meal.id ?? "",
          quantity: qty,
        );
    setState(() {
      qty = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<RestaurantDetailsCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: cardDarkColor(context),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: SquareImage(
                  url: widget.meal.picture?.mediaKey ?? "",
                  width: 80.0,
                  height: 80.0,
                ),
              ),
              const SizedBox(width: 12.0),
              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.meal.foodName ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              // Decrease Quantity Button
                              Container(
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: InkWell(
                                  onTap: (widget.fromUpdate ?? false)
                                      ? null
                                      : _decreaseQuantity,
                                  child: const Icon(
                                    Icons.remove,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              // Quantity Text
                              Text(
                                '$qty',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              // Increase Quantity Button
                              Container(
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: InkWell(
                                  onTap: (widget.fromUpdate ?? false)
                                      ? null
                                      : _increaseQuantity,
                                  child: const Icon(
                                    Icons.add,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Item Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    ((widget.meal.price ?? 0.0)).toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.SECONDARY_COLOR,
                    ),
                  ),
                  SizedBox(height: qty > 0 ? 8.0 : 40),
                  if (qty > 0)
                    BadgedLabel(label: 'Add to cart', onTap: _addToCart),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
