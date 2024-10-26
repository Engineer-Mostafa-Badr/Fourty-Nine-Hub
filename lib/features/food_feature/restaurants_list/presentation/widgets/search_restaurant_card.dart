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

  final Restaurant? restaurant;

  @override
  State<SearchRestaurantCard> createState() => _SearchRestaurantCardState();
}

class _SearchRestaurantCardState extends State<SearchRestaurantCard> {
  @override
  Widget build(BuildContext context) {
    final hasSubscription =
        widget.restaurant?.subscriptionType?.split(' ').first.toLowerCase() !=
            'no';
    return GestureDetector(
      onTap: () {
        // context.pushNamed(Routes.RESTAURANTDETAILS,
        //     extra: widget.restaurant?.id);
        context.push(Routes.RESTAURANTDETAILS, extra: widget.restaurant?.id);
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        child: Column(
          children: [
            if (hasSubscription)
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
                  widget.restaurant!.subscriptionType!.split(' ').first,
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
            // Container(
            //   color: Colors.white,
            //   padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.h),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       /// first row
            //       Column(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Label(
            //               text: widget.restaurant?.name ?? "",
            //               style: Styles.headerText()),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               BlocBuilder<SearchRestaurantsCubit,
            //                   SearchRestaurantState>(builder: (context, state) {
            //                 return Label(
            //                   text: widget.restaurant?.subcategoryId?.name ??
            //                       "${getLang() == "ar" ? state.selectedMealCategory?.nameAr : state.selectedMealCategory?.nameEn}",
            //                   style: Styles.mediumText(),
            //                 );
            //               }),
            //               Label(
            //                 text: "${LocaleKeys.comma.tr()} ",
            //                 style: Styles.mediumText(),
            //               ),
            //               Label(
            //                 text: (getLang() == "ar"
            //                         ? widget.restaurant?.mainCategoryId?.nameAr
            //                         : widget
            //                             .restaurant?.mainCategoryId?.nameEn) ??
            //                     LocaleKeys.meal.tr(),
            //                 style: Styles.mediumText(),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //       const Spacer(),
            //
            //       /// second row
            //       Column(
            //         children: [
            //           Row(
            //             children: [
            //               const Icon(
            //                 Icons.star_rounded,
            //                 color: AppColors.ACCENT_COLOR,
            //               ),
            //               const Sizer(),
            //               Label(
            //                   text: '${widget.restaurant?.totalRating}',
            //                   style: Styles.mediumText(
            //                       fontWeight: FontWeight.w500)),
            //               Label(
            //                   text: '(${widget.restaurant?.numberOfReviews}+)',
            //                   style: Styles.mediumText()),
            //             ],
            //           ),
            //           Label(
            //             text:
            //                 "${widget.restaurant?.menu?.length ?? 0} ${LocaleKeys.meals.tr()}",
            //             style: Styles.mediumText(),
            //           ),
            //         ],
            //       ),
            //       const Spacer(),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
