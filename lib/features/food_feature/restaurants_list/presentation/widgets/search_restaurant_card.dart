import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/Images_profile_for_restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcatigories_restaurant_card.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class SearchRestaurantCard extends StatefulWidget {
  const SearchRestaurantCard({
    super.key,
    required this.restaurant,
  });

  final GetAllRestaurantEntity? restaurant;

  @override
  State<SearchRestaurantCard> createState() => _SearchRestaurantCardState();
}

class _SearchRestaurantCardState extends State<SearchRestaurantCard> {
  @override
  Widget build(BuildContext context) {
    final hasSubscription = widget.restaurant?.isPremium;
    return GestureDetector(
      onTap: () {
        // context.pushNamed(Routes.RESTAURANTDETAILS,
        //     extra: widget.restaurant?.id);
        context.push(Routes.RESTAURANTDETAILS, extra: widget.restaurant);
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        child: Column(
          children: [
            if (hasSubscription == true)
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFD4AF37),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
                child: Text(
                  widget.restaurant!.subscriptionType!.ar! ,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            Expanded(
              flex: 4,
              child: ImagesProfileForRestaurant(
                restaurantMedia: widget.restaurant?.restaurantMedia,
                heightCarousel: MediaQuery.of(context).size.width * 0.72,
                widthForImages: MediaQuery.of(context).size.width,
              ),
            ),
            Expanded(
                flex: 2,
                child: DetailsSection(
                    item: widget.restaurant!, myRestaurant: false)),
          ],
        ),
      ),
    );
  }
}
