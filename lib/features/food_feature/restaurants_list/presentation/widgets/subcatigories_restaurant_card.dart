import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/Images_profile_for_restaurant.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../social_media/twitter/presentation/widgets/report_view.dart';
import '../../../../subscripe/presentation/controllers/subscription_controller.dart';

class SubCategoriesRestaurantCard extends StatelessWidget {
  final Restaurant? item;
  final bool isVertical;
  final String mealId;
  final Function(String id) favouriteRestaurant;
  const SubCategoriesRestaurantCard({
    super.key,
    this.isVertical = true,
    this.item,
    required this.mealId, required this.favouriteRestaurant,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.RESTAURANTDETAILS, extra: item),
      child: isVertical
          ? VerticalRestaurantCard(item: item, mealId: mealId, favouriteRestaurant: (String id) =>favouriteRestaurant(id),)
          : HorizontalRestaurantCard(item: item),
    );
  }
}

class VerticalRestaurantCard extends StatelessWidget {
  final Restaurant? item;
  final String mealId;
  final Function(String id) favouriteRestaurant;
  const VerticalRestaurantCard({super.key, this.item, required this.mealId,required this.favouriteRestaurant});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.92,
      height: MediaQuery.of(context).size.width * 1.1,
      child: PropertyCard(
        item: item!,
        mealId: mealId,
        myRestaurant: false, favouriteRestaurant: (String id) =>favouriteRestaurant(id),
      ),
    );
  }
}

class HorizontalRestaurantCard extends StatelessWidget {
  final Restaurant? item;

  const HorizontalRestaurantCard({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: SquareImage(
            radius: 5,
            url: item?.restaurantMedia?.first.mediaKey,
          ),
        ),
        const Sizer(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: item?.name ?? "",
                style: Styles.mediumText(fontWeight: FontWeight.w400),
              ),
              Label(
                text: item?.description ?? "",
                style: Styles.mediumText(color: Colors.grey),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.ACCENT_COLOR,
                  ),
                  const Sizer(),
                  Label(
                    text: '${item?.totalRating} ',
                    style: Styles.mediumText(fontWeight: FontWeight.w500),
                  ),
                  Label(
                    text: '(${item?.numberOfReviews}+)',
                    style: Styles.mediumText(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Restaurant item;
  final String mealId;
  final bool myRestaurant;
  final Function(String id) favouriteRestaurant;
  const PropertyCard(
      {super.key,
      required this.item,
      required this.mealId,
      required this.favouriteRestaurant,
      required this.myRestaurant});

  @override
  Widget build(BuildContext context) {
    final hasSubscription =
        item.subscriptionType?.split(' ').first.toLowerCase() != 'no';
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.hardEdge,
          color: cardDarkColor(context),
          elevation: myRestaurant ? 0 : 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasSubscription)
                EliteBanner(subscriptionType: item.subscriptionType??''),
              Flexible(
                flex: 4,
                child: Stack(
                  children: [
                    ImagesProfileForRestaurant(
                      autoPlay: true,
                      restaurantMedia: item.restaurantMedia,
                    ),
                    if (!myRestaurant&&context.read<UserCubit>().isLoggedIn)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: FavoriteButton(item: item, mealId: mealId, favouriteRestaurant: (String id)=>favouriteRestaurant(id)),
                      ),
                  ],
                ),
              ),
              Flexible(
                  flex: 3,
                  child:
                      DetailsSection(item: item, myRestaurant: myRestaurant)),
              if (!myRestaurant) const SizedBox(height: 4),
              if (!myRestaurant) PremiumAndRequestButtons(item: item),
              if (!myRestaurant) const SizedBox(height: 4),
              if (!myRestaurant) CallMessageReportButtons(item: item),
              if (!myRestaurant) const SizedBox(height: 2),
              // CallMessageButtons(
              //     otherUserId: item.userIdModel!.id??''!,
              //     subcategoryId: item.subcategoryId!.id,
              //     phone: item.number!,
              //     id: item.id!),
            ],
          ),
        );
      },
    );
  }
}

class PropertyCardShimmer extends StatelessWidget {
  const PropertyCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.92,
        height: MediaQuery.of(context).size.width * 1.1,
        child: Card(
          clipBehavior: Clip.hardEdge,
          color: Colors.grey[300],
          elevation: 5,
        ),
      ),
    );
  }
}

class EliteBanner extends StatelessWidget {
  final String subscriptionType;

  const EliteBanner({super.key, required this.subscriptionType});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: subscriptionType=='Premium subscription'?const Color(0xFFD4AF37):AppColors.DARK_GRAY_COLOR,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
      child: Row(
        children: [
          Icon(Icons.workspace_premium_outlined,
            size: 55.w,
            color: subscriptionType=='Premium subscription'?AppColors.SECONDARY_COLOR:subscriptionType=='Regular subscription'?AppColors.PRIMARY_COLOR:null,
          ),
          const Sizer(),
          Text(
            subscriptionType == 'Premium subscription'
                ? LocaleKeys.premium.localize
                : subscriptionType == 'Regular subscription'
                ? LocaleKeys.regular.localize
                : LocaleKeys.notSubscribed.localize,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final Restaurant item;
  final String mealId;
  final Function(String id) favouriteRestaurant;
  const FavoriteButton({super.key, required this.item, required this.mealId,required this.favouriteRestaurant});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        (item.isFavorite??false) ? Icons.favorite : Icons.favorite_border,
        color: AppColors.SECONDARY_COLOR,
      ),
      onPressed: () async {
       await favouriteRestaurant( item.id!);


        // if (mealId.isNotEmpty) {
        //   await BlocProvider.of<RestaurantsCubit>(context)
        //       .getSubCategoryRestaurants(id: mealId);
        // } else {
        //   // await BlocProvider.of<RestaurantsCubit>(context).getAllRestaurant();
        // }
      },
    );
  }
}

class DetailsSection extends StatelessWidget {
  final Restaurant item;

  final bool myRestaurant;

  const DetailsSection(
      {super.key, required this.item, required this.myRestaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(child: Row(
            children: [
              Expanded(child: Text(item.name ?? '', style: Styles.headerText())),
              if(myRestaurant)ClickableWidget(
                  onTap: (){
                    context.push(Routes.RestaurantOrders);
                  },
                  child: Text(LocaleKeys.showAllOrders.localize, style: Styles.mediumText(color: AppColors.SECONDARY_COLOR,decoration: TextDecoration.underline,decorationThickness: 2.w))),
            ],
          )),
          Expanded(
            child: Text(
                "${context.isArabic?item.subcategoryId?.nameAr:item.subcategoryId?.nameEn ?? ''}, ${item.description ?? ''}",
                style: Styles.mediumText(
                    fontWeight: FontWeight.w600, fontSize: 30)),
          ),
          if (myRestaurant)
            Expanded(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '${context.isArabic?item.government?.governorateNameAr??'':item.government?.governorateNameEn ?? ''}, ${context.isArabic?item.city?.cityNameAr:item.city?.cityNameEn ?? ''}',
                      style: Styles.mediumText()),
                  const Spacer(),
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.ACCENT_COLOR,
                  ),
                  const Sizer(),
                  Label(
                    text: '${item.totalRating}',
                    style: Styles.mediumText(fontWeight: FontWeight.w500),
                  ),
                  Label(
                    text: '(${item.numberOfReviews}+)',
                    style: Styles.mediumText(),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Text(
                  '${context.isArabic?item.government?.governorateNameAr??'':item.government?.governorateNameEn ?? ''}, ${context.isArabic?item.city?.cityNameAr:item.city?.cityNameEn ?? ''}',
                  style: Styles.mediumText()),
            ),
          if (!myRestaurant)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.ACCENT_COLOR,
                      ),
                      const Sizer(),
                      Label(
                        text: '${item.totalRating}',
                        style: Styles.mediumText(fontWeight: FontWeight.w500),
                      ),
                      Label(
                        text: '(${item.numberOfReviews}+)',
                        style: Styles.mediumText(),
                      ),
                    ],
                  ),
                  if (!myRestaurant)
                    Text((item.isActive??false) ? LocaleKeys.available.localize : LocaleKeys.notAvailable.localize,
                        style: Styles.headerText(
                            color: AppColors.SECONDARY_COLOR)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class PremiumAndRequestButtons extends StatelessWidget {
  final Restaurant item;

  const PremiumAndRequestButtons({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
      child: Row(
        children: [
          _buildButton(
            label: LocaleKeys.premiumRequest.localize,
            color: AppColors.PRIMARY_COLOR_DARK,
            onPressed: () async {
              serviceLocator<SubscriptionController>().checkIfUserSubscribed(
                showRegular: false,
                title: "${context.isArabic?item.subcategoryId?.nameAr:item.subcategoryId?.nameEn} Subscription",
                onSubscribed: () {
                  context.push(Routes.RESTAURANTDETAILS, extra: item);
                },
                subCategoryId: item.subcategoryId!.id,
              );
            },
          ),
          const SizedBox(width: 4),
          _buildButton(
            label: LocaleKeys.request.localize,
            color: AppColors.PRIMARY_COLOR,
            onPressed: () {
              context.push(Routes.RESTAURANTDETAILS, extra: item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Flexible(
      child: AppButton(
        height: 60.h,
        padding: 0,
        margin: 0,
        label: label,
        backColor: color,
        style: Styles.mediumText(color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}

class CallMessageReportButtons extends StatelessWidget {
  final Restaurant item;

  const CallMessageReportButtons({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isChatEnabled = item.enableOrDisableChat != 'disable';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
      child: Row(
        children: [
          _buildButtonWithIcon(
            label: LocaleKeys.call.localize,
            icon: Icons.call,
            color:isChatEnabled?AppColors.PRIMARY_COLOR: AppColors.GREY_DARK_COLOR,
            onPressed: isChatEnabled
                ? () => launchUrlString("tel://${item.number}")
                : () {
              SubscriptionMethod().subscribe(subscribeId: item.subcategoryId?.id??'', title: item.name??'');

            },
          ),
          const SizedBox(width: 4),
          _buildButtonWithIcon(
            label: LocaleKeys.message.localize,
            icon: Icons.message,
            color:isChatEnabled?AppColors.PRIMARY_COLOR: AppColors.GREY_DARK_COLOR,
            onPressed: isChatEnabled
                ? () {
                    BlocProvider.of<RestaurantsCubit>(context)
                        .getExpiredOrders();
                    // Implement message functionality here
                  }
                : () {
              SubscriptionMethod().subscribe(subscribeId: item.subcategoryId?.id??'', title: item.name??'');

            },
          ),
          const SizedBox(width: 4),
          _buildButtonWithIcon(
            label: LocaleKeys.report.localize,
            icon: Icons.report,
            color: AppColors.PRIMARY_COLOR_DARK,
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return SizedBox(
                    height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
                    child: ReportView(
                      id: item.id!,
                      categoryId: item.subcategoryId!.id,
                    ),
                  );
                },
              );

              // Implement report functionality here
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButtonWithIcon({
    required String label,
    required IconData icon,
    required Color color,
    required Function onPressed,
  }) {
    return Expanded(
      child: AppButton(
        padding: 0,
        margin: 0,
        height: 60.h,
        label: label,
        icon: icon,
        iconSize: 70.h,
        backColor: color,
        style: Styles.mediumText(color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
