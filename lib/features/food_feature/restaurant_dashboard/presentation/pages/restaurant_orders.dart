import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/numbers_extensions.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import '../cubit/restaurant_dashboard_cubit.dart';
import '../../../../../helpers/subscription_method.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../social_media/instagram/presentation/widgets/comment_widget_insta.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../social_media/twitter/presentation/widgets/report_view.dart';
import '../../../food_cart/presentation/pages/cart_view.dart';
import '../../domain/entity/order_food_entity.dart';
import '../../../../../helpers/manage_vibration.dart';

class AvailableRequestFood extends StatefulWidget {
  const AvailableRequestFood({super.key});

  @override
  State<AvailableRequestFood> createState() => _AvailableRequestFoodState();
}

class _AvailableRequestFoodState extends State<AvailableRequestFood> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<RestaurantDashboardCubit>().getOrders(false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<RestaurantDashboardCubit>().getOrders(false);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
        builder: (context, state) {
          final controller = context.read<RestaurantDashboardCubit>();

          if (state.status == RestaurantDashboardStates.loading &&
              controller.orders.isEmpty) {
            return const Center(child: CustomCircularProgressIndicator());
          }

          if (controller.orders.isEmpty) {
            // return Center(
            //     child:
            //         CustomEmptyWidget(label: LocaleKeys.thereNoItems.localize));
            return Center(
              child: CustomEmptyWidget(
                label:
                    context.isArabic ? 'لا يوجد طلبات' : 'There are no orders',
              ),
            );
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              //final data = controller.orders[index];
              final data = OrderEntity(
                id: '090980',
                userId: null,
                restaurantId: 'sadsadas',
                orders: [
                  OrderItemEntity(
                    foodId: FoodIdEntity(
                        id: null,
                        foodName: "ham ham",
                        picture: PictureEntity(
                            id: "674323e0c5309f771695ae96",
                            mediaKey:
                                "https://d3j5umpuujp1ej.cloudfront.net/food/beans/falafel/66b9da437b1fafcdf897bbe1/846e09ba-bc39-4f81-a499-3d50fca96c1a.png")),
                    quantity: 2,
                    price: 320,
                    totalPriceOfItem: 640,
                    id: 'ewrwewr',
                  )
                ],
                total: 2300,
                isPremium: false,
                address: 'mansoura ,dakahlia',
                phone: '01233333333',
                createdAt: "2025-06-01T14:34:54.774Z",
                updatedAt: null,
                completed: false,
                userRate: 3,
                currencyEn: 'EGP',
                currencyAr: 'ج.م',
                openCallAndChat: 'rewrwr',
              );
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.isDarkMode
                        ? AppColors.whiteColor
                        : Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: AppColors.getFindFillColor(context),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0, top: 4),
                                        child: ImageFromInternet(
                                          isCircle: true,
                                          //image: data.userId!.userProfile!.profilePictureKey!.mediaKey!,
                                          image: data
                                                  .userId
                                                  ?.userProfile
                                                  ?.profilePictureKey!
                                                  .mediaKey! ??
                                              '',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: -15,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 2,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.star,
                                                  color: Colors.yellow,
                                                  size: 14),
                                              const SizedBox(width: 2),
                                              Text(
                                                data.userRate
                                                        ?.toStringAsFixed(1)
                                                        .toArabicNumbers(
                                                            context) ??
                                                    "0".toArabicNumbers(
                                                        context),
                                                style: Styles.smallText(
                                                  // fontSize: 12,
                                                  color:
                                                      AppColors.PRIMARY_COLOR,

                                                  // color:  context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Sizer(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      data.userId?.firstName ?? "",
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.mediumText(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        color: context.isDarkMode
                                            ? AppColors.whiteColor
                                            : AppColors.PRIMARY_COLOR,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // if (data.orders != null &&
                          //     data.orders!.isNotEmpty &&
                          //     data.orders![index].foodId != null)
                          Expanded(
                            child: Column(
                              // spacing: 10,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Label(
                                  // text: data.orders!
                                  //     .map((e) => (e.foodId?.foodName ?? "").toString())
                                  //     .join(', '),
                                  text:
                                      data.orders?[0].foodId?.foodName ?? "N/A",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  // textAlign: TextAlign.end,
                                  style: Styles.mediumText(
                                    fontWeight: FontWeight.w600,
                                    color: context.isDarkMode
                                        ? AppColors.whiteColor
                                        : AppColors.PRIMARY_COLOR,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Label(
                                  text:
                                      '${data.orders!.map((e) => (e.price ?? 0).toString()).join(', ').toArabicNumbers(context)} ${(context.isArabic ? data.currencyAr : data.currencyEn) ?? ''}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  // textAlign: TextAlign.end,
                                  style: Styles.mediumText(
                                    fontWeight: FontWeight.w600,
                                    color: context.isDarkMode
                                        ? AppColors.whiteColor
                                        : AppColors.PRIMARY_COLOR,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ImageFromInternet(
                              //image: data.userId!.userProfile!.profilePictureKey!.mediaKey!,
                              image:
                                  data.orders?[0].foodId?.picture?.mediaKey ??
                                      '',
                              width: 100,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (data.createdAt != null)
                            Label(
                              text: context.isArabic
                                  ? DateFormat('d MMM, yyyy h:mm a', 'ar')
                                      .format(
                                          DateTime.parse(data.createdAt ?? ""))
                                  : DateFormat('MMM d, yyyy h:mm a', 'en')
                                      .format(
                                          DateTime.parse(data.createdAt ?? "")),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          // Label(
                          //   text: "Today",
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.w600,
                          //     fontSize: 14,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // Text("Here${state.orders?.data?.subcategoryId ?? ""}"),
                    CallMessageReportButtonsDashBoard(
                      item: data,
                      subcategoryId: state.orders?.data?.subcategoryId ?? "",
                      index: index,
                    ),
                    const SizedBox(height: 8),
                    AppButton(
                      height: 40,
                      color: AppColors.getReversedTextColor(context),
                      backColor: AppColors.getButtonPrimaryWhiteColor(context),
                      label: context.isArabic ? 'اكمال' : "Complete",
                      onPressed: () {
                        ManageVibration.vibrate();
                        controller.completeOrder(data.id!);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CallMessageReportButtonsDashBoard extends StatelessWidget {
  final OrderEntity item;
  final String subcategoryId;
  final int index;

  const CallMessageReportButtonsDashBoard(
      {super.key,
      required this.item,
      required this.subcategoryId,
      required this.index});

  @override
  Widget build(BuildContext context) {
    // final isChatEnabled = item.enableOrDisableChat?.toLowerCase() == 'enable';
    final isChatEnabled = item.openCallAndChat != 'disable';
    return Row(
      // spacing: 15,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              Assets.phoneIconRed,
              width: 22,
              height: 22,
              color: isChatEnabled == true
                  ? AppColors.getRedColor(context)
                  : AppColors.GREY_DARK_COLOR,
            ),
            color: isChatEnabled == true
                ? AppColors.PRIMARY_COLOR
                : AppColors.GREY_DARK_COLOR,
            onPressed: isChatEnabled
                ? () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: cardDarkColor(context),
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            spacing: 16,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppButton(
                                backColor:
                                    AppColors.getButtonPrimaryColor(context),
                                color: AppColors.getReversedTextColor(context),
                                onPressed: () {
                                  ManageVibration.vibrate();
                                  Navigator.pop(context); // Close first sheet
                                  // _showFreeCallBottomSheet(context, item);
                                },
                                label: LocaleKeys.freeCall.localize,
                              ),
                              AppButton(
                                backColor: AppColors.cD9D9D9,
                                color: AppColors.black,
                                onPressed: () {
                                  ManageVibration.vibrate();
                                  Navigator.pop(context); // Close first sheet
                                  _showRegularCallBottomSheet(
                                      context, item); // Open second
                                },
                                label: LocaleKeys.regularCall.localize,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                : () {
                    SubscriptionMethod().subscribe(
                      subscribeId: subcategoryId,
                      title: item.orders?[index].foodId?.foodName ?? '',
                    );
                  },
          ),
        ),
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              Assets.mailIconRed,
              width: 18,
              height: 18,
              color: isChatEnabled == true
                  ? AppColors.getRedColor(context)
                  : AppColors.GREY_DARK_COLOR,
            ),
            color: isChatEnabled == true
                ? AppColors.getRedColor(context)
                : AppColors.GREY_DARK_COLOR,
            onPressed: isChatEnabled
                ? () {
                    // BlocProvider.of<RestaurantDashboardCubit>(context)
                    //     .getExpiredOrders();
                    // Implement message functionality here
                  }
                : () {
                    SubscriptionMethod().subscribe(
                      subscribeId: subcategoryId ?? '',
                      title: item.orders?[index].foodId?.foodName ?? '',
                    );
                  },
          ),
        ),
        Expanded(
          child: IconButton(
            icon: const Icon(
              Icons.report,
              size: 26,
            ),
            color: AppColors.getRedColor(context),
            onPressed: () async {
              ManageVibration.vibrate();
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: AppColors.getFindFillColor(context),
                builder: (context) {
                  return SizedBox(
                    height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
                    child: ReportView(
                      id: item.id!,
                      categoryId: subcategoryId ?? '',
                    ),
                  );
                },
              );

              // Implement report functionality here
            },
          ),
        )
      ],
    );
  }

  void _showRegularCallBottomSheet(BuildContext context, OrderEntity item) {
    bool isBookingForAnotherClient = false;
    bool hasPhoneError = false;
    final TextEditingController phoneController =
        TextEditingController(text: item.phone ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.getFindFillColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            phoneController.addListener(() {
              if (hasPhoneError && phoneController.text.isNotEmpty) {
                setState(() {
                  hasPhoneError = false;
                });
              }
            });

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    activeColor: AppColors.getButtonPrimaryWhiteColor(context),
                    contentPadding: EdgeInsets.zero,
                    checkColor: AppColors.getPrimaryTextColor(context),
                    value: isBookingForAnotherClient,
                    onChanged: (value) {
                      setState(() {
                        isBookingForAnotherClient = value!;
                        hasPhoneError = false;
                        if (isBookingForAnotherClient) {
                          phoneController.clear();
                        } else {
                          // phoneController.text = item.number ?? '';
                        }
                      });
                    },
                    title: Text(
                      LocaleKeys.imBookingOfAnotherClient.localize,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.c717171,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    // enabled: isBookingForAnotherClient,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      color: AppColors.getTextColor(context),
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          color: AppColors.getButtonPrimaryWhiteColor(context),
                          Assets.phoneIconRed,
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                        ),
                      ),
                      hintText: LocaleKeys.phone.localize,
                      errorText: hasPhoneError
                          ? LocaleKeys.enterPhoneNumber.localize
                          : null,
                      filled: true,
                      fillColor: AppColors.getFillColor(context),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      backColor: AppColors.getButtonPrimaryColor(context),
                      color: AppColors.getReversedTextColor(context),
                      label: LocaleKeys.submit.localize,
                      onPressed: () {
                        ManageVibration.vibrate();
                        final enteredNumber = phoneController.text.trim();
                        if (isBookingForAnotherClient) {
                          if (enteredNumber.isEmpty) {
                            setState(() {
                              hasPhoneError = true;
                            });
                            return;
                          }
                          launchUrlString("tel://$enteredNumber");
                        } else {
                          // launchUrlString("tel://${item.number}");
                        }

                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class PastRequestFood extends StatefulWidget {
  const PastRequestFood({super.key});

  @override
  State<PastRequestFood> createState() => _PastRequestFoodState();
}

class _PastRequestFoodState extends State<PastRequestFood> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<RestaurantDashboardCubit>().getOrdersPast(true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<RestaurantDashboardCubit>().getOrdersPast(true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
        builder: (context, state) {
          final controller = context.read<RestaurantDashboardCubit>();

          if (state.status == RestaurantDashboardStates.loading &&
              controller.ordersPast.isEmpty) {
            return const Center(child: CustomCircularProgressIndicator());
          }

          if (controller.ordersPast.isEmpty) {
            return Center(
              child: CustomEmptyWidget(
                label:
                    context.isArabic ? 'لا يوجد طلبات' : 'There are no orders',
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: controller.ordersPast.length,
            itemBuilder: (context, index) {
              final data = controller.ordersPast[index];
              // return Text("${data.id}");
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.isDarkMode
                        ? AppColors.whiteColor
                        : Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: AppColors.getFindFillColor(context),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0, top: 4),
                                        child: ImageFromInternet(
                                          isCircle: true,
                                          image: data
                                                  .userId
                                                  ?.userProfile
                                                  ?.profilePictureKey
                                                  ?.mediaKey ??
                                              '',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: -15,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 2,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.star,
                                                  color: Colors.yellow,
                                                  size: 14),
                                              const SizedBox(width: 2),
                                              Text(
                                                data.userRate
                                                        ?.toStringAsFixed(1)
                                                        .toArabicNumbers(
                                                            context) ??
                                                    "0".toArabicNumbers(
                                                        context),
                                                style: Styles.smallText(
                                                  // fontSize: 12,
                                                  color:
                                                      AppColors.PRIMARY_COLOR,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Text(
                                      data.userId?.firstName ?? "",
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.mediumText(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        color: context.isDarkMode
                                            ? AppColors.whiteColor
                                            : AppColors.PRIMARY_COLOR,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // if (data.orders != null &&
                          //     data.orders!.isNotEmpty &&
                          //     data.orders![0].foodId != null)
                          Expanded(
                            child: Column(
                              // spacing: 10,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Label(
                                  text: data.orders!
                                      .map((e) => (e.foodId?.foodName ?? "N/A")
                                          .toString())
                                      .join(', '),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  // textAlign: TextAlign.end,
                                  style: Styles.mediumText(
                                    fontWeight: FontWeight.w600,
                                    color: context.isDarkMode
                                        ? AppColors.whiteColor
                                        : AppColors.PRIMARY_COLOR,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Label(
                                  text:
                                      '${data.orders!.map((e) => (e.price ?? 0).toString()).join(', ').toArabicNumbers(context)} ${(context.isArabic ? data.currencyAr : data.currencyEn) ?? ''}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  // textAlign: TextAlign.end,
                                  style: Styles.mediumText(
                                    fontWeight: FontWeight.w600,
                                    color: context.isDarkMode
                                        ? AppColors.whiteColor
                                        : AppColors.PRIMARY_COLOR,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ImageFromInternet(
                                //image: data.userId!.userProfile!.profilePictureKey!.mediaKey!,
                                image:
                                    data.orders?[0].foodId?.picture?.mediaKey ??
                                        '',
                                width: 100,
                                height: 70,
                                fit: BoxFit.cover,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (data.createdAt != null)
                            Label(
                              text: context.isArabic
                                  ? DateFormat('d MMM, yyyy h:mm a', 'ar')
                                      .format(
                                          DateTime.parse(data.createdAt ?? ""))
                                  : DateFormat('MMM d, yyyy h:mm a', 'en')
                                      .format(
                                          DateTime.parse(data.createdAt ?? "")),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          // Label(
                          //   text: "Today",
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.w600,
                          //     fontSize: 14,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // Text("Here${state.orders?.data?.subcategoryId ?? ""}"),
                    CallMessageReportButtonsDashBoard(
                      item: data,
                      subcategoryId: state.orders?.data?.subcategoryId ?? "",
                      index: index,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
